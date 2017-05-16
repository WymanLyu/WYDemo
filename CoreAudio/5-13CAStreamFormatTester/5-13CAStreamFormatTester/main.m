//
//  main.m
//  5-13CAStreamFormatTester
//
//  Created by wyman on 2017/5/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // 0.文件类型和媒体格式
        AudioFileTypeAndFormatID fileTypeAndFormat;
        fileTypeAndFormat.mFileType = kAudioFileAIFFType;
        fileTypeAndFormat.mFormatID = kAudioFormatLinearPCM;
        
        // 1.状态
        OSStatus theErr = noErr;
        
        // 2.获取文件全局属大小
        UInt32 infoSize = 0;
        theErr = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, sizeof(fileTypeAndFormat), &fileTypeAndFormat, &infoSize); // 全局属性名 - 标示大小 - 标示指针 - 获取到的属性大小
        assert(theErr == noErr);
        
        // 3.获取文件的全局属性
        AudioStreamBasicDescription *asbds = malloc(infoSize);
        theErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, sizeof(fileTypeAndFormat), &fileTypeAndFormat, &infoSize, asbds);
        assert(theErr == noErr);
        
        // 4.打印支持的格式
        for (int i = 0; i < infoSize/sizeof(AudioStreamBasicDescription) ; i++) {
            
            // 获取描述
            AudioStreamBasicDescription asbd = asbds[i];
            
            UInt32 format4cc = CFSwapInt32HostToBig(asbd.mFormatID); // 大端读取

            
            NSLog (@"mFormatId:%4.4s, mFormatFlags:%d, mBitsPerChannel:%d",(char*)&format4cc,asbd.mFormatFlags,asbd.mBitsPerChannel);
        
//            NSLog(@"序号%zd --- mSampleRate:%f-AudioFormatID:%s-AudioFormatFlags:%zd-mBytesPerPacket:%zd-mFramesPerPacket:%zd-mBytesPerFrame:%zd-mChannelsPerFrame:%zd-mBitsPerChannel:%zd-mReserved:%zd",i, asbd.mSampleRate, (char *)&format4cc, asbd.mFormatFlags, asbd.mBytesPerPacket, asbd.mFramesPerPacket, asbd.mBytesPerFrame, asbd.mChannelsPerFrame,asbd.mBitsPerChannel, asbd.mReserved);
            
        }
    }
    return 0;
}
