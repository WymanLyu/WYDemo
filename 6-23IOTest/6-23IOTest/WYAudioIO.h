//
//  WYAudioIO.h
//  6-23IOTest
//
//  Created by wyman on 2017/7/1.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYAudioIODelegate <NSObject>

@end
   
typedef bool (*audioProcessingCallback) (void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime);

@interface WYAudioIO : NSObject

- (instancetype)initWithDelegate:(id)delegate preferredIOBufferDuration:(unsigned int)preferredIOBufferDuration preferredSampleRate:(unsigned int)preferredSampleRate audioSessionCategory:(NSString *)audioSessionCategory channels:(int)channels audioProcessingCallback:(audioProcessingCallback)callback clientdata:(void *)clientdata;

- (bool)start;
- (void)stop;

@end
