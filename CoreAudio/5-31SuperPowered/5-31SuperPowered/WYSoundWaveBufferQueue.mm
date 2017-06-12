//
//  WYSoundWaveBufferQueue.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYSoundWaveBufferQueue.h"

#include<vector>

template<typename TEle>
class BufferUnitClass {
public:
    TEle *bufferRef;
    size_t size;
    BufferUnitClass(size_t size) : bufferRef(nullptr), size(0)
    {
        bufferRef = new TEle[size];
        this->size = size;
        _ref_count++;
    }
    BufferUnitClass(const BufferUnitClass<TEle>& other)
    {
        
    }
    BufferUnitClass& operator=(BufferUnitClass<TEle>& other)
    {
        other._ref_count --;
        if(&other == this) return;
        _ref_count++;
        other->retain_count();
    }
    ~BufferUnitClass()
    {
        _ref_count--;
        if(!bufferRef && 0 == _ref_count)
            delete[] bufferRef;
    }
    
    void retain_count()
    {
        _ref_count++;
    }

private:
    int _ref_count = 0;
    
};

static std::vector<BufferUnitClass<int16_t>> buffers;

@implementation WYSoundWaveBufferQueue
{

@protected;
    

}


- (instancetype)initQueueWithObserver:(id)observer inputBufferSize:(int)inputSampleCount outputBufferSize:(int)outputSampleCount callBackFrequency:(double)callbackFrequency enqueueBufferFrequency:(double)enqueueFrequency {
    if (self = [super init]) {
        
//        buffers.push_back(a);
//        buffers.front();
//        buffers.erase(buffers.cbegin());
        
    }
    return self;
}


@end
