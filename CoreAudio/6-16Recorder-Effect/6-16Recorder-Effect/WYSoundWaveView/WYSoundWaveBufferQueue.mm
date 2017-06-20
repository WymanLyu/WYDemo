//
//  WYSoundWaveBufferQueue.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYSoundWaveBufferQueue.h"
#import <QuartzCore/QuartzCore.h>
#import <pthread.h>

typedef struct BufferUnit {
    SInt16 *bufferRef;
    int sampleCount;
} BufferUnit;

@interface WYSoundWaveBufferQueue()

@property (nonatomic, weak) id<WYSoundWaveBufferQueueDelegate> observer;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign, getter=isRunning) BOOL running;

@end

@implementation WYSoundWaveBufferQueue
{

@protected;
    BufferUnit *_bufferList;    // 循环缓冲列表
    SInt16 _bufferListLenght;   // 循环缓冲列表的长度
    SInt16 _bufferLenght;       // 循环缓冲单元的长度
    
    SInt16 *_callBackBufferList;      // 降采样回调列表
    SInt16 _callBackBufferListLenght; // 回调的buffer列表长度
    
    int _head_index;     // 头索引
    
    pthread_mutex_t _mutex_lock; // 线程锁

}

- (void)dealloc {
    for (int i=0; i < _bufferListLenght; i++) {
        BufferUnit bufferUnit = _bufferList[i];
        if (NULL != bufferUnit.bufferRef) {
            free(bufferUnit.bufferRef);
        }
    }
    free(_bufferList);
    free(_callBackBufferList);
    [self.displayLink invalidate];
    self.displayLink = nil;
}


- (instancetype)initQueueWithObserver:(id<WYSoundWaveBufferQueueDelegate>)observer inputBufferSize:(int)inputSampleCount outputBufferSize:(int)outputSampleCount callBackFrequency:(double)callbackFrequency enqueueBufferFrequency:(double)enqueueFrequency {
    if (self = [super init]) {
        
        if (!inputSampleCount || !outputSampleCount || !callbackFrequency || !enqueueFrequency) {
            NSLog(@"初始化参数不正确");
            return nil;
        }
        self.observer = observer;
        
        // 0.获取速率比
        double ratio = callbackFrequency / enqueueFrequency;
        int inputListLenght = 1;
        if (ratio < 1) { // 入列速度比 出列快
            inputListLenght = ceil(1/ratio);
        }else { //  出列比入列快 会取到相同的数
            NSLog(@"回调取到的数周期性重复");
        }
        
        // 1.初始化缓冲区域
        self->_bufferList = (BufferUnit *)malloc(sizeof(BufferUnit)*inputListLenght);
        memset(self->_bufferList, 0, sizeof(BufferUnit)*inputListLenght);
        self->_bufferListLenght = inputListLenght;
        self->_bufferLenght = inputSampleCount;
        
        self->_callBackBufferList = (SInt16 *)malloc(sizeof(SInt16)*outputSampleCount);
        self->_callBackBufferListLenght = outputSampleCount;
        memset(self->_callBackBufferList, 0, self->_callBackBufferListLenght);
        
        // 2.设置定时器，进行回调
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback)];
        self.displayLink.frameInterval = callbackFrequency * 1.0/60.0; // 跳过多少帧调用
        _running = NO;
        
        
        // 3.循环缓冲的游标索引
        _head_index = 0;
        
        // 4.初始化锁
        pthread_mutex_init(&_mutex_lock, NULL);
        
    }
    return self;
}

#pragma mark - 回调

- (void)displayLinkCallback {
    [self dequeueBuffer];
//    NSLog(@"%@ - %zd", [NSThread currentThread], self->_callBackBufferListLenght);
}


#pragma mark - 入队

- (void)enqueueBuffer:(SInt16 *)samples sampleCount:(int)sampleCount {
    
    pthread_mutex_lock(&_mutex_lock);
    
    // 头元素
    BufferUnit *headUnit = (BufferUnit *)&(self->_bufferList[_head_index]);
//    NSLog(@"%p-%p == %p-%p", self->_bufferList+0, self->_bufferList+1, &self->_bufferList[0],  &self->_bufferList[1]);
    headUnit->sampleCount = sampleCount;
    if (NULL == headUnit->bufferRef) {
        headUnit->bufferRef = (SInt16 *)malloc(sizeof(SInt16)*headUnit->sampleCount);
        
        NSLog(@"new memory");
    }

    // 重新写入数据
    memcpy(headUnit->bufferRef, samples, sizeof(SInt16)*headUnit->sampleCount);
    
    // 5.启动循环
    if (!self.isRunning) {
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _running = YES;
    }
    
    pthread_mutex_unlock(&_mutex_lock);
}

#pragma mark - 出队

- (void)dequeueBuffer {
    
    pthread_mutex_lock(&_mutex_lock);
    
    // 1.总的buffer长度
    int totalBufferLenght = 0;
    int index = 0;
    while (index < self->_bufferListLenght) {
        BufferUnit bufferUnit = (BufferUnit)self->_bufferList[index];
        if (NULL == bufferUnit.bufferRef) {
            index++;
            continue;
        }
        totalBufferLenght += bufferUnit.sampleCount;
        index++;
    }

    // 2.根据 回调的buffer列表长度 获取降采样间距
    int sampleInterval = floor((totalBufferLenght*1.0) / self->_callBackBufferListLenght);
    
    // 3.等距降采样
    int indexgap = 0;
    int callBackListIndex = 0;  // call buffer的指针索引
    int sampleIntervalIndex= 0; // ring buffer的指针索引

    while (indexgap < self->_bufferListLenght) {
        int bufferUnitIndex = (_head_index+indexgap) % self->_bufferLenght; // 获取bufferUnit索引
        BufferUnit bufferUnit = (BufferUnit)self->_bufferList[bufferUnitIndex];
        if (sampleIntervalIndex >= bufferUnit.sampleCount) { // 超过这个buffer的长度，跳到下一个buffer
            sampleIntervalIndex = 0; // buffer的指针索引置位
            index++; // bufferList的索引增加
            continue;
        }
        SInt16 sampleVolum = bufferUnit.bufferRef[sampleIntervalIndex];
        NSLog(@"xxxxxxxxxxx->%ud", ABS(sampleVolum));
        self->_callBackBufferList[callBackListIndex] = sampleVolum;
        sampleIntervalIndex += sampleInterval;
        callBackListIndex++;
        if (callBackListIndex >= self->_callBackBufferListLenght) {
            break;
        }
    }
    
    // 4.头指针循环往前移动
    _head_index++;
    if (_head_index >= _bufferListLenght) {
        _head_index %= _bufferListLenght;
    }
    
    // 5.回调
    if ([self.observer respondsToSelector:@selector(soundWaveBufferQueueOutCallback:reSampleCount:)]) {
        [self.observer soundWaveBufferQueueOutCallback:self->_callBackBufferList reSampleCount:self->_callBackBufferListLenght];
    }
    
    pthread_mutex_unlock(&_mutex_lock);
}



@end
