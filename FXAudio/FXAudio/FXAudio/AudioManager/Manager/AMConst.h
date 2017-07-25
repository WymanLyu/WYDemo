//
//  AMConst.h
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef AMConst_h
#define AMConst_h


#define FS 44100                          // 采样率
#define BUFFER_SIZE 12                    // IO回调buffer的时长  == FS*BUFFER_SIZE*0.01 个samples 单位是ms
#define CHANNELS 2                        // 通道数
#define BUFFER_SAMPLE_COUNT 512           // IO回调buffer的采样数 eg：FS*BUFFER_SIZE*0.01 个samples 但是apple会自动对齐2的次方

#define WEBRTC_BUFFER_SAMPLE_COUNT 441    // webrtc要求的10ms的数据

#endif /* AMConst_h */
