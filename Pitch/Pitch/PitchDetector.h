//
//  PitchDetector.h
//  Demo
//
//  Created by wyman on 2017/7/19.
//  Copyright © 2017年 Tobias Kräntzer. All rights reserved.
//

#ifndef PitchDetector_h
#define PitchDetector_h

#include <stdio.h>
#include <Accelerate/Accelerate.h>
#include <string.h>
#include <queue>

extern std::string calStep(double frequency);

typedef enum : long {
    PitchStepUndefined    = 0,
    PitchStepC            = 1,
    PitchStepD            = 2,
    PitchStepE            = 3,
    PitchStepF            = 4,
    PitchStepG            = 5,
    PitchStepA            = 6,
    PitchStepB            = 7
} PitchStep;

typedef struct Pitch {
    double frequency; // 频率
    double amplitude; // 能量
    long octave;      // 八度音阶
    long key;         // 音高关系
    PitchStep step;   // 音高
    std::string stepString;// 音高符号
} Pitch;

class PitchDetector {
    
private:
    unsigned int numberOfSamples;
    double sampleRate;
    
    float *windowFunc; // 窗函数
    float *FFTBuffer;  // fft处理buffer
    COMPLEX_SPLIT A;   // fft变换函数处理buffer
    float *magnitudes; // 能量
    FFTSetup setupReal;// fft预设
    
    std::queue<Pitch> pitchQueue;
    Pitch bestPitch;

public:
    
    PitchDetector(unsigned int numberOfSamples, double sampleRate);
    ~PitchDetector();
    
    // 单声道
    Pitch process(float *input, unsigned int numberOfSamples);
    // 计算10次的最大值
    Pitch process2queue_max(float *input, unsigned int numberOfSamples);
    // 计算10次的平均值
    Pitch process2queue_average(float *input, unsigned int numberOfSamples);
    
};


#endif /* AudioPitch_h */
