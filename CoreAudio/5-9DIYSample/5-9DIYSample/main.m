//
//  main.m
//  5-9DIYSample
//
//  Created by wyman on 2017/5/9.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define SAMPLE_RATE 44100 // 采样率
#define DURATION 5        // 音频时长
//#define FILENAME_FORMAT @"%0.3f-square.aif"   // 文件名
//#define FILENAME_FORMAT @"%0.3f-sawtooth.aif"   // 文件名
#define FILENAME_FORMAT @"%0.3f-sin.aif"   // 文件名

// 获取矩形波的采样数值
SInt16 cacultSquareSample(double wavelengthInSamples, long currentIndexIncycle)
{
    if (currentIndexIncycle < wavelengthInSamples/2) { // 极大
        return CFSwapInt16BigToHost(SHRT_MAX); //  SHRT_MAX 一个字节的最大值
    } else { // 极小
        return CFSwapInt16BigToHost(SHRT_MIN); //  SHRT_MIN 一个字节的最小值
    }
}

// 获取牙形波的采样数值
SInt16 cacultSawtoothSample(double wavelengthInSamples, long currentIndexIncycle)
{
    return CFSwapInt16BigToHost((currentIndexIncycle / wavelengthInSamples) * SHRT_MAX *2);
}

// 获取sin波的采样数值
SInt16 cacultSinSample(double wavelengthInSamples, long currentIndexIncycle)
{
    return CFSwapInt16BigToHost((SInt16)SHRT_MAX *sin(2*M_PI*(currentIndexIncycle/wavelengthInSamples)));
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 1.校验输入参数
        if (argc < 2) {
            printf("缺少音频频率【每秒的完整声波震动长度（归一化无单位）】参数");
            return -1;
        }
         NSLog(@"开始---");
        
//        2017-05-09 16:03:28.074314 5-9DIYSample[9182:471905] 开始---
//        2017-05-09 16:03:28.614638 5-9DIYSample[9182:471905] 写入了220524个采样数据 耗时0.6s
        
//        2017-05-09 16:04:45.646092 5-9DIYSample[9228:473142] 开始---
//        2017-05-09 16:04:45.646313 5-9DIYSample[9228:473142] 结束                 耗时0.0003s
        
        // 上述看出些frame是非常耗时CPU的
        
        
        // 2.获取音频通道数
        double hz = atof(argv[1]); // 将参数的字符串转成浮点数
        assert(hz); // 断言
        
        // 3.获取写入的URL
        NSString *fileName = [NSString stringWithFormat:FILENAME_FORMAT, hz];
        NSString *filePath = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:fileName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        // 4.设置ASDB【AudioStreamBasicDescription】音频文件的基本格式
        // --------
//        Float64             mSampleRate;
//        AudioFormatID       mFormatID;
//        AudioFormatFlags    mFormatFlags;
//        UInt32              mBytesPerPacket;
//        UInt32              mFramesPerPacket;
//        UInt32              mBytesPerFrame;
//        UInt32              mChannelsPerFrame;
//        UInt32              mBitsPerChannel;
//        UInt32              mReserved;
        // --------
        AudioStreamBasicDescription asdb; // 初始ASDB的局部变量
        memset(&asdb, 0, sizeof(asdb));   // 清空ASDB的属性值（栈中）
        asdb.mSampleRate = SAMPLE_RATE;   // 设置采样率
        asdb.mFormatID = kAudioFormatLinearPCM; // 线性PCM
        asdb.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked; // 音频数据在buff中的内存细节:大端存储 | 有符号整形 | 每个bit都有意义
        asdb.mBytesPerPacket = 2;    // 线性PCM，packet就是frame,而1个frame是2字节（8bit）
        asdb.mFramesPerPacket = 1;   // 线性PCM，packet就是frame
        asdb.mBytesPerFrame = 2;     // 每个样本占据2个字节（说明位深是8bit*2）
        asdb.mChannelsPerFrame = 1;  // 每个样本有一条声道，这是
        asdb.mBitsPerChannel = 16;   // 位深16bit
        
        // 5.设置准备写入的文件
        AudioFileID audioFile; // CoreAudio中的媒体文件标识
        OSStatus theErr = noErr; // 错误码
        theErr = AudioFileCreateWithURL((__bridge CFURLRef _Nonnull)(fileURL), kAudioFileAIFFType, &asdb, kAudioFileFlags_EraseFile, &audioFile); //  创建音频文件，kAudioFileAIFFType格式【这个跟url后缀要一致】，kAudioFileFlags_EraseFile重新写入
        assert(theErr == noErr);// 断言
        
        // 6.写入采样值【就是音频波的采样数字】
        long maxSampleCount = SAMPLE_RATE * DURATION; // 整个音频的采样数
        long currentSampleCount = 0; // 当前写入的采样数
        UInt32 byteToWrite = 2; // 每个采样数据写入的字节数
        double wavelengthInSamples = SAMPLE_RATE / hz; // 每秒的样本数 / 每秒的震荡周期数 == 每个波周期内的采样数
        while (currentSampleCount < maxSampleCount) { // 一个样本一个样本写
            for (int i = 0 ; i < wavelengthInSamples; i++) { // 实际上内循环是一个周期一个周期写
                SInt16 sample; // 采样数值
                
                // 计算采样值
                // 矩形波
//                sample = cacultSquareSample(wavelengthInSamples, i);
                // 牙形波
//                sample = cacultSawtoothSample(wavelengthInSamples, i);
                // sin波
                sample = cacultSinSample(wavelengthInSamples, i);

                // CBR类型写入媒体文件 1.文件 2.是否内存缓存 3.当前的文件偏移位 4.写入的单个样本的字节数 5.写入的数值
                theErr = AudioFileWriteBytes(audioFile, false, currentSampleCount*2, &byteToWrite, &sample);
                assert (theErr == noErr);// 断言
                // 写入后的当前的样本数增加
                currentSampleCount++;
            }
        }
        
        // 7.关闭媒体文件
        theErr = AudioFileClose(audioFile);
        assert(theErr == noErr);
        NSLog(@"写入了%zd个采样数据", currentSampleCount);
        
    }
    return 0;
}
