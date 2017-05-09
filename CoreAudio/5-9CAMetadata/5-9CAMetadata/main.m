//
//  main.m
//  5-9CAMetadata
//
//  Created by wyman on 2017/5/9.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 1.校验参数
        if (argc < 2) {
            printf("缺少文件路径参数");
            return -1;
        }
        
        // 2.获取文件资源URL
        NSString *audioFilePath = [NSString stringWithUTF8String:argv[1]];
        NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
        
        // 3.引用文件创建CoreAudio中的媒体索引
        AudioFileID audioFile = nil; // 文件id指针
        OSStatus theErr = noErr;     // api状态码
        theErr = AudioFileOpenURL((__bridge CFURLRef _Nonnull)(audioURL), kAudioFileReadPermission, 0, &audioFile); // 打开文件
        assert(theErr == noErr); // 断言
        
        // 4.获取文件信息属性
        // 4.1.获取文件属性的描述
        UInt32 dictionarySize = 0; // 元数据大小
        theErr = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0); // 获取文件属性信息的描述
        assert(theErr == noErr); // 断言
        // 4.2.获取文件属性
        CFDictionaryRef filePropertyDict; // 文件属性
        theErr = AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, &filePropertyDict); // 获取文件属性
        assert(theErr == noErr); // 断言
        
        // 5.打印
        NSLog (@"dictionary: %@", filePropertyDict);
        
        // 6.内存释放及关闭文件流
        CFRelease(filePropertyDict);
        theErr = AudioFileClose(audioFile);
        assert(theErr == noErr); // 断言
        
        
    }
    return 0;
}
