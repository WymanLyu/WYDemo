//
//  WYSoundWaveRenderBufferQueue.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYSoundWaveRenderBufferQueue.h"
#import <QuartzCore/QuartzCore.h>
#include<stdint.h>

class BufferUnitClass {
public:
    int16_t *bufferRef;
    size_t size;
    BufferUnitClass() : bufferRef(nullptr), size(0)
    {
        
    }
    ~BufferUnitClass()
    {
        if(!bufferRef)
            delete[] bufferRef;
    }
    
};

typedef struct BufferUnit {
    SInt16 *bufferRef;
    int sampleCount;
} BufferUnit;

@interface WYSoundWaveRenderBufferQueue()

@property (nonatomic, weak) id<WYSoundWaveRenderBufferQueueDelegate> observer;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation WYSoundWaveRenderBufferQueue
{
@protected
    BufferUnit **_bufferList;   // 循环缓冲列表
    SInt16 _bufferListLenght;   // 循环缓冲列表的长度
    SInt16 _bufferLenght;       // 循环缓冲单元的长度
    
    SInt16 *_callBackBufferList;      // 降采样回调列表
    SInt16 _callBackBufferListLenght; // 回调的buffer列表长度
    
}

- (void)dealloc {
    free(_callBackBufferList);
    int index = 0;
    while (index < self->_bufferListLenght) {
        BufferUnit *bufferUnitRef = (BufferUnit *)self->_bufferList[index];
        free(bufferUnitRef->bufferRef);
        index++;
    }
    free(_bufferList);
}

- (instancetype)initQueueWithObserver:(id<WYSoundWaveRenderBufferQueueDelegate>)observer inputBufferSize:(int)inputSampleCount outputBufferSize:(int)outputSampleCount callBackFrequency:(double)callbackFrequency enqueueBufferFrequency:(double)enqueueFrequency {
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
        self->_bufferList = (BufferUnit **)malloc(sizeof(int)*inputListLenght);
        memset(self->_bufferList, 0, sizeof(int)*inputListLenght);
        self->_bufferListLenght = inputListLenght;
        self->_bufferLenght = inputSampleCount;
        
        self->_callBackBufferList = (SInt16 *)malloc(sizeof(SInt16)*outputSampleCount);
        self->_callBackBufferListLenght = outputSampleCount;
        
        // 2.设置定时器，进行回调
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback)];
        self.displayLink.frameInterval = callbackFrequency * 1.0/60.0; // 跳过多少帧调用
        
    }
    return self;
}

#pragma mark - 回调

- (void)displayLinkCallback {
    NSLog(@"displayLinkCallback");
}

#pragma mark - 出队
- (void)dequeueBuffer {
    
    // 1.总的buffer长度
    int totalBufferLenght = 0;
    int index = 0;
    while (index < self->_bufferListLenght) {
        BufferUnit *bufferUnitRef = (BufferUnit *)self->_bufferList[index];
        totalBufferLenght += bufferUnitRef->sampleCount;
        index++;
    }
    
    // 2.根据 回调的buffer列表长度 获取降采样间距
    int sampleInterval =  floor((totalBufferLenght*1.0) / self->_callBackBufferListLenght);
    
    // 3.等距降采样
    index = 0;
    int callBackListIndex = 0;
    int sampleIntervalIndex= 0;
    while (index < self->_bufferListLenght) {
        BufferUnit *bufferUnitRef = (BufferUnit *)self->_bufferList[index];
        if (sampleIntervalIndex >= bufferUnitRef->sampleCount) { // 超过这个buffer的长度，跳到下一个buffer
            sampleIntervalIndex = 0; // buffer的指针索引置位
            index++; // bufferList的索引增加
            continue;
        }
        SInt16 sampleVolum = bufferUnitRef->bufferRef[sampleIntervalIndex];
        self->_callBackBufferList[callBackListIndex] = sampleVolum;
        sampleIntervalIndex += sampleInterval;
        callBackListIndex++;
        if (callBackListIndex >= self->_callBackBufferListLenght) {
            break;
        }
    }
    
    // 4.回调出队
    if ([self.observer respondsToSelector:@selector(renderBufferQueueOutCallback:reSampleCount:)]) {
        [self.observer renderBufferQueueOutCallback:self->_callBackBufferList reSampleCount:self->_callBackBufferListLenght];
    }
    
}

#pragma mark - 入队

- (void)enqueueBuffer:(SInt16 *)samples sampleCount:(int)sampleCount {
    
    if (self.displayLink.isPaused) {
//        [self.displayLink ]
    }
    
    // 1.删除最后一个
    // 1.1清空最后一个内容
    BufferUnit *lastBuffer = (BufferUnit *)(self->_bufferList[self->_bufferListLenght-1]);
    if (lastBuffer != NULL) {
        free(lastBuffer->bufferRef);
        lastBuffer->bufferRef = NULL;
        free(lastBuffer);
        lastBuffer = NULL;
    }
    
    // 2.平移前几个
    int index = self->_bufferListLenght;
    while (index > 1) {
       BufferUnit *buffer_p = (BufferUnit *)(self->_bufferList[index-2]); // index前一个指针
       self->_bufferList[index-1] = buffer_p;
       index--;
    }
    
    // 3.新加入第一个
    // 3.1.清空第一个内存
    BufferUnit *firstBuffer = (BufferUnit *)(self->_bufferList[0]);
    if (firstBuffer != NULL) {
        firstBuffer = NULL;
    }
    // 3.3.加入第一个
    self->_bufferList[0] = (BufferUnit *)malloc(sizeof(BufferUnit));
    BufferUnit *newBuffer = self->_bufferList[0];
    newBuffer->bufferRef = (SInt16 *)malloc(sizeof(SInt16)*sampleCount);
    memcpy(newBuffer->bufferRef, samples, sampleCount);
    newBuffer->sampleCount = sampleCount;
    
}






@end
