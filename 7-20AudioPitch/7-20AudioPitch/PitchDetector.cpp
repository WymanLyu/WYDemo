//
//  PitchDetector.cpp
//  Demo
//
//  Created by wyman on 2017/7/19.
//  Copyright © 2017年 Tobias Kräntzer. All rights reserved.
//

#include "PitchDetector.h"
#include <math.h>
#include <stdio.h>
#include <assert.h>
#include <map>

#define DEFAULT_QUEUE_SIZE 10

static void calStep(Pitch *pitch);

PitchDetector::PitchDetector(unsigned int numberOfSamples, double sampleRate)
{
    assert(numberOfSamples > 0);
    assert(sampleRate > 0);
    this->numberOfSamples = numberOfSamples;
    this->sampleRate = sampleRate;
    this->queueSize = DEFAULT_QUEUE_SIZE;
//    this->FFTBuffer = new float(numberOfSamples);
    
    this->FFTBuffer = (float *)calloc(sizeof(float), numberOfSamples);
    
    // 1.窗函数
    this->windowFunc = (float *)calloc(sizeof(float), numberOfSamples);
    vDSP_hamm_window(windowFunc, numberOfSamples, 0);

    // 2.fft处理buffer
    this->A.realp = (float  * __nonnull)malloc(sizeof(float)*(numberOfSamples/2));
    this->A.imagp = (float  * __nonnull)malloc(sizeof(float)*(numberOfSamples/2));

    // 3.能量
    this->magnitudes = (float *)malloc(sizeof(float)*(numberOfSamples/2));
    
    // 4.fft变换的预设
    float originalRealInLog2 = log2f(numberOfSamples);
    this->setupReal = vDSP_create_fftsetup(originalRealInLog2, FFT_RADIX2);

}

PitchDetector::~PitchDetector()
{
    free(this->A.realp);
    free(this->A.imagp);
    free(this->magnitudes);
    free(this->FFTBuffer);
//    delete this->FFTBuffer;
    vDSP_destroy_fftsetup(this->setupReal);
}

Pitch PitchDetector::process(float *input, unsigned int numberOfSamples)
{
    assert(this->numberOfSamples==numberOfSamples);
    int n = numberOfSamples;
    float *originalReal = this->FFTBuffer;
    
    // 1.1.时域上加窗
    vDSP_vmul(input, 1, this->windowFunc, 1, originalReal, 1, n);
    // 分前后加窗没什么不一样啊
//    vDSP_vmul(input, 1, this->windowFunc, 1, originalReal+(n/2), 1, n/2);
//    vDSP_vmul(input+(n/2), 1, this->windowFunc+(n/2), 1, originalReal, 1, n/2);
    
    // 2.拆成复数形似{1+2i, 3+4i, ..., 1023+1024i} 原始数组可以认为是（COMPLEX*）交错存储 现在拆成COMPLEX_SPLIT非交错（分轨式）存储
    vDSP_ctoz((COMPLEX*)originalReal, 2, &this->A, 1, n/2); // 读取originalReal以2的步长塞进A里面
    
//    // 3.fft变换的预设
    float originalRealInLog2 = log2f(n);
//    FFTSetup setupReal = vDSP_create_fftsetup(originalRealInLog2, FFT_RADIX2);
    
    // 4.傅里叶变换
    vDSP_fft_zrip(this->setupReal, &this->A, 1, originalRealInLog2, FFT_FORWARD);
    
    // 5.转换成能量值
    vDSP_zvabs(&this->A, 1, this->magnitudes, 1, n/2);
    Float32 one = 1;
    vDSP_vdbcon(this->magnitudes, 1, &one, this->magnitudes, 1, n/2, 0);
    
    // 6.获取基频f0
    float maxValue;
    vDSP_Length index;
    vDSP_maxvi(this->magnitudes, 1, &maxValue, &index, n/2);
    // 6.1.微调参数
    double alpha    = this->magnitudes[index - 1];
    double beta     = this->magnitudes[index];
    double gamma    = this->magnitudes[index + 1];
    double p = 0.5 * (alpha - gamma) / (alpha - 2 * beta + gamma);
    
    // 7.转换为频率 indexHZ = index * (SampleRate / (n/2))
    float indexHZ = (index+p) * ((this->sampleRate*1.0) / n);
    
    // 8.乐理信息生成
    Pitch pitch;
    pitch.frequency = indexHZ;
    pitch.amplitude = beta;
    pitch.key = 12 * log2(indexHZ / 127.09) + 28.5;
    pitch.octave = (pitch.key - 3.0) / 12 + 1;
    calStep(&pitch);
    pitch.stepString = calStep(indexHZ);
    
    return pitch;
}

Pitch PitchDetector::process2queue_max(float *input, unsigned int numberOfSamples)
{
    Pitch pitch = this->process(input, numberOfSamples);
    if (this->pitchQueue.size() > this->queueSize) {
        // reCalulate best pitch
        Pitch maxAmplitudePitch;
        while (!this->pitchQueue.empty()) {
            Pitch pitch = this->pitchQueue.back();
            this->pitchQueue.pop();
            if (pitch.amplitude > maxAmplitudePitch.amplitude) {
                maxAmplitudePitch = pitch;
            }
        }
        this->bestPitch = maxAmplitudePitch;
    } else {
        pitchQueue.push(pitch);
    }
    if (this->bestPitch.amplitude == 0.0) {
        this->bestPitch = pitch;
    }
    return this->bestPitch;
}

Pitch PitchDetector::process2queue_average(float *input, unsigned int numberOfSamples)
{
    static double sumFre = 0.0;
    static double sumAmp = 0.0;
    Pitch pitch = this->process(input, numberOfSamples);
    if (this->pitchQueue.size() > this->queueSize) {
        Pitch front_pitch = this->pitchQueue.front();
        sumFre -= front_pitch.frequency;
        sumAmp -= front_pitch.amplitude;
        this->pitchQueue.pop();
        this->pitchQueue.push(pitch);
        sumFre += pitch.frequency;
        sumAmp += pitch.amplitude;
        
        // 计算平均
        this->bestPitch.frequency = sumFre/this->queueSize;
        this->bestPitch.amplitude = sumAmp/this->queueSize;
        this->bestPitch.key = 12 * log2(this->bestPitch.frequency / 127.09) + 28.5;
        this->bestPitch.octave = (this->bestPitch.key - 3.0) / 12 + 1;
        calStep(&this->bestPitch);
        this->bestPitch.stepString = calStep(this->bestPitch.frequency);
    } else {
        if (pitch.frequency > 0.0) {
            this->pitchQueue.push(pitch);
            sumFre += pitch.frequency;
            sumAmp += pitch.amplitude;
        }
    }
    if (this->bestPitch.amplitude == 0.0) {
        this->bestPitch = pitch;
    }
    return this->bestPitch;
}

void PitchDetector::setQueueSize(int queueSize)
{
    assert(queueSize > 0);
    this->queueSize = queueSize;
}

static void calStep(Pitch *pitch)
{
    long keyInOctave = pitch->key - 3 - (12 * (pitch->octave - 1));
    switch (keyInOctave) {
        case 0:
        case 1: {pitch->step = PitchStepC;break;}
        case 2:
        case 3: {pitch->step = PitchStepD;break;}
        case 4:
        case 5: {pitch->step = PitchStepE;break;}
        case 6: {pitch->step = PitchStepF;break;}
        case 7:
        case 8: {pitch->step = PitchStepG;break;}
        case 9:
        case 10: {pitch->step = PitchStepA;break;}
        case 11:
        case 12: {pitch->step = PitchStepB;break;}
        default: pitch->step = PitchStepUndefined;
    }
}

extern std::string calStep(double frequency)
{
    static double frequency2pitch_keys[] = {27.50, 29.14, 30.87, // A0, A0#, B0
        32.70, 34.65, 36.71, 38.89, 41.20, 43.65, 46.25, 49.00, 51.91, 55.00, 58.27,
        61.74, // C1 - B1
        // C, C#, D, D#, E, F, F#, G, G#, A, A#, B
        65.51, 69.30, 73.42, 77.78, 82.41, 87.31, 92.50, 98.00, 103.83, 110.00, 116.54,
        123.47, // C2 - B2
        130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00,
        233.08, 246.94, // C3 - B3
        261.63, 277.18, 293.67, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00,
        466.16, 493.88, // C4 - B4
        523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99, 830.61, 880.00,
        932.33, 987.77, // C5 - B5
        1046.5, 1108.7, 1174.7, 1244.5, 1318.5, 1396.9, 1480.0, 1568.0, 1661.2, 1760.0,
        1864.7, 1975.5, // C6 - B6
        2093.0, 2217.5, 2349.3, 2489.0, 2637.0, 2793.0, 2960.0, 3136.0, 3322.4, 3520.0,
        3729.3, 3951.1, // C7 - B7
        4186.0}; // C8
    
    // 国际谱 参考 https://bideyuanli.com/%E5%A3%B0%E4%B9%90%E5%9F%BA%E7%A1%80%E7%90%86%E8%AE%BA/%E9%9F%B3%E9%AB%98
    static std::map<double, std::string>pitch_names;
    pitch_names.insert(std::map<double, std::string>::value_type(27.50, "A0"));
    pitch_names.insert(std::map<double, std::string>::value_type(29.14, "A0#"));
    pitch_names.insert(std::map<double, std::string>::value_type(30.87, "B0"));
    
    pitch_names.insert(std::map<double, std::string>::value_type(32.70, "C1"));
    pitch_names.insert(std::map<double, std::string>::value_type(34.65, "C#1"));
    pitch_names.insert(std::map<double, std::string>::value_type(36.71, "D1"));
    pitch_names.insert(std::map<double, std::string>::value_type(38.89, "D#1"));
    pitch_names.insert(std::map<double, std::string>::value_type(41.20, "E1"));
    pitch_names.insert(std::map<double, std::string>::value_type(43.65, "F1"));
    pitch_names.insert(std::map<double, std::string>::value_type(46.25, "F#1"));
    pitch_names.insert(std::map<double, std::string>::value_type(49.00, "G1"));
    pitch_names.insert(std::map<double, std::string>::value_type(51.91, "G#1"));
    pitch_names.insert(std::map<double, std::string>::value_type(55.00, "A1"));
    pitch_names.insert(std::map<double, std::string>::value_type(58.27, "A#1"));
    pitch_names.insert(std::map<double, std::string>::value_type(61.74, "B1"));
    
    pitch_names.insert(std::map<double, std::string>::value_type(65.51, "C2"));
    pitch_names.insert(std::map<double, std::string>::value_type(69.30, "C#2"));
    pitch_names.insert(std::map<double, std::string>::value_type(73.42, "D2"));
    pitch_names.insert(std::map<double, std::string>::value_type(77.78, "D#2"));
    pitch_names.insert(std::map<double, std::string>::value_type(82.41, "E2"));
    pitch_names.insert(std::map<double, std::string>::value_type(87.31, "F2"));
    pitch_names.insert(std::map<double, std::string>::value_type(92.50, "F#2"));
    pitch_names.insert(std::map<double, std::string>::value_type(98.00, "G2"));
    pitch_names.insert(std::map<double, std::string>::value_type(103.83, "G#2"));
    pitch_names.insert(std::map<double, std::string>::value_type(110.00, "A2"));
    pitch_names.insert(std::map<double, std::string>::value_type(116.54, "A#2"));
    pitch_names.insert(std::map<double, std::string>::value_type(123.47, "B2"));
    
    pitch_names.insert(std::map<double, std::string>::value_type(130.81, "C3"));
    pitch_names.insert(std::map<double, std::string>::value_type(138.59, "C#3"));
    pitch_names.insert(std::map<double, std::string>::value_type(146.83, "D3"));
    pitch_names.insert(std::map<double, std::string>::value_type(155.56, "D#3"));
    pitch_names.insert(std::map<double, std::string>::value_type(164.81, "E3"));
    pitch_names.insert(std::map<double, std::string>::value_type(174.61, "F3"));
    pitch_names.insert(std::map<double, std::string>::value_type(185.00, "F#3"));
    pitch_names.insert(std::map<double, std::string>::value_type(196.00, "G3"));
    pitch_names.insert(std::map<double, std::string>::value_type(207.65, "G#3"));
    pitch_names.insert(std::map<double, std::string>::value_type(220.00, "A3"));
    pitch_names.insert(std::map<double, std::string>::value_type(233.08, "A#3"));
    pitch_names.insert(std::map<double, std::string>::value_type(246.94, "B3"));

    pitch_names.insert(std::map<double, std::string>::value_type(261.63, "C4"));
    pitch_names.insert(std::map<double, std::string>::value_type(277.18, "C#4"));
    pitch_names.insert(std::map<double, std::string>::value_type(293.67, "D4"));
    pitch_names.insert(std::map<double, std::string>::value_type(311.13, "D#4"));
    pitch_names.insert(std::map<double, std::string>::value_type(329.63, "E4"));
    pitch_names.insert(std::map<double, std::string>::value_type(349.23, "F4"));
    pitch_names.insert(std::map<double, std::string>::value_type(369.99, "F#4"));
    pitch_names.insert(std::map<double, std::string>::value_type(392.00, "G4"));
    pitch_names.insert(std::map<double, std::string>::value_type(415.30, "G#4"));
    pitch_names.insert(std::map<double, std::string>::value_type(440.00, "A4"));
    pitch_names.insert(std::map<double, std::string>::value_type(466.16, "A#4"));
    pitch_names.insert(std::map<double, std::string>::value_type(493.88, "B4"));

    pitch_names.insert(std::map<double, std::string>::value_type(523.25, "C5"));
    pitch_names.insert(std::map<double, std::string>::value_type(554.37, "C#5"));
    pitch_names.insert(std::map<double, std::string>::value_type(587.33, "D5"));
    pitch_names.insert(std::map<double, std::string>::value_type(622.25, "D#5"));
    pitch_names.insert(std::map<double, std::string>::value_type(659.26, "E5"));
    pitch_names.insert(std::map<double, std::string>::value_type(698.46, "F5"));
    pitch_names.insert(std::map<double, std::string>::value_type(739.99, "F#5"));
    pitch_names.insert(std::map<double, std::string>::value_type(783.99, "G5"));
    pitch_names.insert(std::map<double, std::string>::value_type(830.61, "G#5"));
    pitch_names.insert(std::map<double, std::string>::value_type(880.00, "A5"));
    pitch_names.insert(std::map<double, std::string>::value_type(932.33, "A#5"));
    pitch_names.insert(std::map<double, std::string>::value_type(987.77, "B5"));

    pitch_names.insert(std::map<double, std::string>::value_type(1046.5, "C6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1108.7, "C#6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1174.7, "D6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1244.5, "D#6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1318.5, "E6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1396.9, "F6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1480.0, "F#6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1568.0, "G6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1661.2, "G#6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1760.0, "A6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1864.7, "A#6"));
    pitch_names.insert(std::map<double, std::string>::value_type(1975.5, "B6"));

    pitch_names.insert(std::map<double, std::string>::value_type(2093.0, "C7"));
    pitch_names.insert(std::map<double, std::string>::value_type(2217.5, "C#7"));
    pitch_names.insert(std::map<double, std::string>::value_type(2349.3, "D7"));
    pitch_names.insert(std::map<double, std::string>::value_type(2489.0, "D#7"));
    pitch_names.insert(std::map<double, std::string>::value_type(2637.0, "E7"));
    pitch_names.insert(std::map<double, std::string>::value_type(2793.0, "F7"));
    pitch_names.insert(std::map<double, std::string>::value_type(2960.0, "F#7"));
    pitch_names.insert(std::map<double, std::string>::value_type(3136.0, "G7"));
    pitch_names.insert(std::map<double, std::string>::value_type(3322.4, "G#7"));
    pitch_names.insert(std::map<double, std::string>::value_type(3520.0, "A7"));
    pitch_names.insert(std::map<double, std::string>::value_type(3729.3, "A#7"));
    pitch_names.insert(std::map<double, std::string>::value_type(3951.1, "B7"));

    pitch_names.insert(std::map<double, std::string>::value_type(4186.0, "C8"));

    
    double pre_fre = 0.0;
    int arr_count = sizeof(frequency2pitch_keys) / sizeof(frequency2pitch_keys[0]);
    for (int i = 0 ; i < arr_count; i++) {
        
        double cur_fre = frequency2pitch_keys[i];
        double next_fre = frequency2pitch_keys[i+1];
        
        double range_min = (0==i ? 0 : cur_fre - (cur_fre - pre_fre) / 2.0);
        double range_max = ((arr_count-1)==i ? MAXFLOAT : cur_fre + (next_fre - cur_fre) / 2.0);
        if (frequency >= range_min && frequency < range_max) {
            std::map<double, std::string>::const_iterator citor;
            citor = pitch_names.find(cur_fre);
            return citor->second;
        } else {
            continue;
        }
    }
    return "UnkownPitch";
}



















