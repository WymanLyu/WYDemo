//
//  FXWebRTC.cpp
//  FXAudioDemo
//
//  Created by wyman on 2017/7/4.
//  Copyright © 2017年 wyman. All rights reserved.
//

#include "FXWebRTC.h"
#include "WYAudioRingBuffer.h"
#include <stdlib.h>
#include <assert.h>
#import "SuperpoweredSimple.h"

#define BUFFER_COUNT 3

FXWebRTC::FXWebRTC(unsigned int inputNumberOfSamples, unsigned int outputNumberOfSamples, unsigned int channels)
{
    assert(inputNumberOfSamples > 0);
    assert(outputNumberOfSamples > 0);
    assert(channels > 0);
    
    // 0.初始化apm
    this->apm = new AudioProcessingProxy();
    this->apm->setAgcState(false);
    this->apm->setNsState(true);
    
    // 1.设置参数
    this->inputNumberOfSamples = inputNumberOfSamples;
    this->outputNumberOfSamples = outputNumberOfSamples;
    this->channels = channels;
    
    // 2.两个RingBuffer
    this->inputBuffer = new WYAudioRingBuffer(channels, this->inputNumberOfSamples*BUFFER_COUNT);
    this->outputBuffer = new WYAudioRingBuffer(channels, this->inputNumberOfSamples*BUFFER_COUNT);
    
    // 3.申请内存
    // 3.1.交错浮点
    this->outputBuffer_read__Interleave = new float [this->outputNumberOfSamples*channels+8*channels];
    // 3.2.交错短整形
    this->outputBuffer_read__Interleave_shortInt = new short int [this->outputNumberOfSamples*channels+8*channels];
    max_inputBuffer_read_count = this->inputNumberOfSamples*BUFFER_COUNT / this->outputNumberOfSamples;
    // 3.3.从input的ringBuffer中读取的buffer
    this->inputBuffer_read_array = new float **[max_inputBuffer_read_count];
    for (int i = 0; i < max_inputBuffer_read_count; i++) {
        inputBuffer_read_array[i] = new float *[channels];
        for (int index = 0; index < channels; index++) {
            inputBuffer_read_array[i][index] = new float [this->outputNumberOfSamples];
            std::fill_n(inputBuffer_read_array[i][index], this->outputNumberOfSamples, 0);
//            memset(inputBuffer_read_array[i][index], 0, this->outputNumberOfSamples*sizeof(float));
        }
    }
    // 3.4.从output的ringBuffer中读取的Buffer
    this->outputBuffer_read = new float *[channels];
    for (int i = 0; i < channels; i++) {
        this->outputBuffer_read[i] = new float [this->inputNumberOfSamples];
        std::fill_n(outputBuffer_read[i], this->inputNumberOfSamples, 0);
    }
}

FXWebRTC::~FXWebRTC()
{
    for (int i = 0; i < max_inputBuffer_read_count; i++) {
        for (int index = 0; index < channels; index++) {
            delete [] inputBuffer_read_array[i][index];
        }
        delete [] inputBuffer_read_array[i];
    }
    delete [] inputBuffer_read_array;
    
    
    for (int i = 0; i < channels; i++) {
        delete [] this->outputBuffer_read[i];
    }
    delete [] this->outputBuffer_read;
    delete [] this->outputBuffer_read__Interleave;
    delete [] this->outputBuffer_read__Interleave_shortInt;
    
}

bool FXWebRTC::process(float **buffers, unsigned int numberOfSamples, unsigned int channels)
{
    
    assert(numberOfSamples == this->inputNumberOfSamples);
    assert(channels == this->channels);
    
    // 1.写入inputRingBuffer
    this->inputBuffer->Write(buffers, channels, numberOfSamples);
    
    // 2.循环处理buffer
    int index = 0;
//    size_t readFramesAvailable = this->inputBuffer->ReadFramesAvailable();
    while (this->inputBuffer->ReadFramesAvailable() > this->outputNumberOfSamples) {
        // 2.1.读取inputRingBuffer -- 10ms*N
        float **buffers_webrtc = this->inputBuffer_read_array[index];
        this->inputBuffer->Read(buffers_webrtc, channels, this->outputNumberOfSamples);
        
        // 2.2.处理webrtc的buffer
        // 2.2.1.交错buffer
        // a.交错类型
        SuperpoweredInterleave(buffers_webrtc[0], buffers_webrtc[1], this->outputBuffer_read__Interleave, this->outputNumberOfSamples);
        // b.交错短整型
        SuperpoweredFloatToShortInt(this->outputBuffer_read__Interleave, this->outputBuffer_read__Interleave_shortInt, this->outputNumberOfSamples);
        
        // 2.2.2.处理buffer
        this->apm->process(this->outputBuffer_read__Interleave_shortInt, this->outputBuffer_read__Interleave_shortInt, this->outputNumberOfSamples, 44100, channels);
        
        // 2.2.3.反交错buffer
        // a.交错浮点
        SuperpoweredShortIntToFloat(this->outputBuffer_read__Interleave_shortInt, this->outputBuffer_read__Interleave, this->outputNumberOfSamples);
        // b.反交错
        SuperpoweredDeInterleave(this->outputBuffer_read__Interleave, buffers_webrtc[0], buffers_webrtc[1], this->outputNumberOfSamples);
        
        // 2.3.写入outputRingBuffer -- 10ms*N
        this->outputBuffer->Write(buffers_webrtc, channels, this->outputNumberOfSamples);

        index++;
    }
    if (index<1) { //表示没有buffer进行处理
        return false;
    }
    
    // 4.读取outputRingBuffer
//    size_t readFramesAvailable_output = this->outputBuffer->ReadFramesAvailable();
    if (this->outputBuffer->ReadFramesAvailable() > this->inputNumberOfSamples) {
        this->outputBuffer->Read(this->outputBuffer_read, channels, this->inputNumberOfSamples);
        // 4.1.重写覆盖
        if (numberOfSamples == this->inputNumberOfSamples) {
            for (int i = 0; i <channels; i++) {
                memcpy(buffers[i], this->outputBuffer_read[i], sizeof(float)*this->inputNumberOfSamples);
            }
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
    
   

}
















