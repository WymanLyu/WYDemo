//
//  FXWebRTC.hpp
//  FXAudioDemo
//
//  Created by wyman on 2017/7/4.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef FXWebRTC_hpp
#define FXWebRTC_hpp

#include <stdio.h>
#import "AudioProcessingProxy.h"

typedef class WYAudioRingBuffer WYAudioRingBuffer;
//class AudioProcessingProxy;

class FXWebRTC {
  
protected:
    WYAudioRingBuffer *inputBuffer;     // input环形缓冲区
    WYAudioRingBuffer *outputBuffer;    // output环形缓冲区
    
private:
    int max_inputBuffer_read_count;     // input最大连续读取次数
    float ***inputBuffer_read_array;    // 从input读取出的buffer的数组
    float **outputBuffer_read;          // 从output读取的buffer
    
    float *outputBuffer_read__Interleave;              // 从output读取的buffer->交错
    short int *outputBuffer_read__Interleave_shortInt; // 从output读取的buffer->交错短整型
    
    unsigned int inputNumberOfSamples;  // 写入buffer的samples数 --》 与process一致
    unsigned int outputNumberOfSamples; // webrtc处理buffer的samples数，在input-output两个缓冲区的处理samples数
    unsigned int channels;              // buffer的通道数 --》 与process一致
    
public:
    FXWebRTC(unsigned int inputNumberOfSamples, unsigned int outputNumberOfSamples, unsigned int channels);
    ~FXWebRTC();
    bool process(float **buffers, unsigned int numberOfSamples, unsigned int channels);
    
    AudioProcessingProxy *apm; // webrtc处理模块
};

#endif /* FXWebRTC_hpp */
