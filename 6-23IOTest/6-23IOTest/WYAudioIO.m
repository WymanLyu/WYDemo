//
//  WYAudioIO.m
//  6-23IOTest
//
//  Created by wyman on 2017/7/1.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYAudioIO.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

#define DEFAULT_PREFERREDSAMPLERATE 44100

// 错误校验
extern void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) {
        return;
    }
    char errorString[20];
    // 检查四个字节的错误码
    *(UInt32 *)(errorString+1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) { // 说明是四字节的错误码
        errorString[0] = errorString[5] = '\''; // 补上个引号，为了好看点
        errorString[6] = '\0'; // 字符串结尾
    } else { // 其他错误码，格式化写入字符串
        sprintf(errorString, "%d", (int)error);
    }
    // 打印错误并退出程序
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

@implementation WYAudioIO
{
    AudioUnit _remoteAU;
    BOOL _started;
    
    audioProcessingCallback _audioProcessingCallback;
    void *_processingClientdata;
    
    AudioBufferList *inputBufferListForRecordingCategory; // bufferList
    
    NSString *_audioSessionCategory;
    unsigned int _preferredIOBufferDuration; // 期待的回调时间 单位ms
    double _preferredSampleRate; // 期待的采样率
    int _channels; // 轨道数
    
}

static OSStatus coreAudioProcessingCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
    
    __unsafe_unretained WYAudioIO *self = (__bridge WYAudioIO *)inRefCon;
    
    if (!ioData) ioData = self->inputBufferListForRecordingCategory;
    div_t d = div(inNumberFrames, 8);
//    if ((d.rem != 0) || (ioData->mNumberBuffers != self->_channels)) {
//        return kAudioUnitErr_InvalidParameter;
//    };
    
    // Get audio input.
    unsigned int inputChannels = (!AudioUnitRender(self->_remoteAU, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData)) ? self->_channels : 0;
    float *bufs[self->_channels];
    for (int n = 0; n < self->_channels; n++) bufs[n] = (float *)ioData->mBuffers[n].mData;
    
    self->_audioProcessingCallback(self->_processingClientdata, bufs, self->_channels, inputChannels, inNumberFrames, self->_preferredSampleRate, inTimeStamp->mHostTime);
    
    return noErr;
}

- (void)dealloc {
    if (_remoteAU != NULL) {
        AudioUnitUninitialize(_remoteAU);
        AudioComponentInstanceDispose(_remoteAU);
    };
    if (inputBufferListForRecordingCategory) {
        for (int n = 0; n < _channels; n++) free(inputBufferListForRecordingCategory->mBuffers[n].mData);
        free(inputBufferListForRecordingCategory);
    };
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (instancetype)initWithDelegate:(id)delegate preferredIOBufferDuration:(unsigned int)preferredIOBufferDuration preferredSampleRate:(unsigned int)preferredSampleRate audioSessionCategory:(NSString *)audioSessionCategory channels:(int)channels audioProcessingCallback:(audioProcessingCallback)callback clientdata:(void *)clientdata {
    if (self = [super init]) {
        
        // 0.记录属性
        if (preferredSampleRate < 8000 || preferredSampleRate > 48000) {
            preferredSampleRate = DEFAULT_PREFERREDSAMPLERATE;
        }
        _preferredIOBufferDuration = preferredIOBufferDuration;
        _preferredSampleRate = preferredSampleRate;
        _channels = channels;
        _audioSessionCategory = audioSessionCategory;
        _audioProcessingCallback = callback;
        _processingClientdata = clientdata;
        
        // 1.音频有向图
        [self initAUGraph];
        
//        kAUVoiceIOProperty_VoiceProcessingEnableAGC
        
        
        
    }
    return self;
}

- (void)createAudioBuffersForRecordingCategory {
    inputBufferListForRecordingCategory = (AudioBufferList *)malloc(sizeof(AudioBufferList) + (sizeof(AudioBuffer) * _channels));
    inputBufferListForRecordingCategory->mNumberBuffers = _channels;
    for (int n = 0; n < _channels; n++) {
        inputBufferListForRecordingCategory->mBuffers[n].mDataByteSize = 2048 * 4;
        inputBufferListForRecordingCategory->mBuffers[n].mNumberChannels = 1;
        inputBufferListForRecordingCategory->mBuffers[n].mData = malloc(inputBufferListForRecordingCategory->mBuffers[n].mDataByteSize);
    };
}


#pragma mark - 初始化音频有向图

- (void)initAUGraph {
    
    // 0.配置音频会话[只有一个unit]
    [self setupAudioSession];
    
    // 1.获取音频单元
    _remoteAU = [self createRemoteAU];
    
    
}

- (void)setupAudioSession {
    NSError *error = nil;
//    [[AVAudioSession sharedInstance] setActive:NO error:&error];
    [[AVAudioSession sharedInstance] setPreferredInputNumberOfChannels:_channels error:&error];
    [[AVAudioSession sharedInstance] setPreferredOutputNumberOfChannels:_channels error:&error];
    [[AVAudioSession sharedInstance] setPreferredSampleRate:_preferredSampleRate error:&error];
//    NSAssert(error, @"setPreferredSampleRate错误");
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:_preferredIOBufferDuration*0.001 error:&error];
//    NSAssert(error, @"setPreferredIOBufferDuration错误");
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[AVAudioSession sharedInstance] setCategory:_audioSessionCategory error:&error];
//    NSAssert(error, @"setCategory错误");
}

- (AudioUnit)createRemoteAU {
    AudioUnit au = NULL;
    OSStatus theErr = noErr;
    
    // 1.音频单元描述
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_RemoteIO;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    // 2.根据音频描述查找音频组件
    AudioComponent component = AudioComponentFindNext(NULL, &desc);
    
    // 3.实例化音频组件【音频组件==音频单元】
    if (AudioComponentInstanceNew(component, &au) != 0) return NULL;
    
    // 4.设置属性
    // 4.1.设置input/output开关打开
    UInt32 outputOpen = 1;
    theErr = AudioUnitSetProperty(au, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, 0, &outputOpen, sizeof(outputOpen));
    CheckError(theErr, "设置output开关打开");
    UInt32 intputOpen = 1;
    theErr = AudioUnitSetProperty(au, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &intputOpen, sizeof(intputOpen));
    CheckError(theErr, "设置intput开关打开");
    // 4.2.回调设置
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = coreAudioProcessingCallback;
    callbackStruct.inputProcRefCon = (__bridge void *)self;
    theErr = AudioUnitSetProperty(au, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &callbackStruct, sizeof(callbackStruct));
    CheckError(theErr, "设置回调失败");
    
    // 5.初始化AU
    theErr = AudioUnitInitialize(au);
    CheckError(theErr, "初始化AU失败");
    
    return au;
}

- (bool)start {
    _started = true;
    if (_remoteAU == NULL) return false;
    if (AudioOutputUnitStart(_remoteAU)) return false;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    return true;
}

- (void)stop {
    _started = false;
    if (_remoteAU != NULL) AudioOutputUnitStop(_remoteAU);
}

@end
