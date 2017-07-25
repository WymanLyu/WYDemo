//
// Created by Paint on 2017/7/3.
//

#ifndef KTVDEMO_AUDIOPROCESSINGPROXY_H
#define KTVDEMO_AUDIOPROCESSINGPROXY_H

#include <webrtc/modules/audio_processing/audio_processing_impl.h>
#include <webrtc/modules/audio_processing/include/audio_processing.h>
#include <webrtc/modules/include/module_common_types.h>
#include <webrtc/common_audio/resampler/push_sinc_resampler.h>
#include <stdlib.h>

using namespace webrtc;


// Audio processing
const NoiseSuppression::Level kDefaultNsMode = NoiseSuppression::kModerate;
const bool kDefaultNsState =
#if defined(WEBRTC_ANDROID) || defined(WEBRTC_IOS)
       false;
#else
true;
#endif
const GainControl::Mode kDefaultAgcMode =
#if defined(WEBRTC_ANDROID) || defined(WEBRTC_IOS)
        GainControl::kAdaptiveDigital;
#else
GainControl::kAdaptiveAnalog;
#endif
const bool kDefaultAgcState =
#if defined(WEBRTC_ANDROID) || defined(WEBRTC_IOS)
        false;
#else
true;
#endif
// VolumeControl
enum { kMinVolumeLevel = 0 };
enum { kMaxVolumeLevel = 255 };



class AudioProcessingProxy{
public:

    const int k10ms_ratio = 100; //10ms数据和采样率的转换因子

    AudioProcessingProxy();

    ~AudioProcessingProxy();

    int setAgcState(bool enable);

    int setAgcMode(GainControl::Mode mode);

    int setNsState(bool enable);

    int setNsLevel(NoiseSuppression::Level level);

    /**
     *
     * @param input intput and output address can be the same
     * @param output
     * @param numberOfSamples
     * @param samplerate
     * @param num_channels 2 for stereo, 1 for mono
     * @param speech_type
     * @param vad_activity
     * @param energy
     * @return
     */
    int process(short int *input, short int *output, int numberOfSamples, int samplerate,
                size_t num_channels = 1, AudioFrame::SpeechType speech_type = AudioFrame::kNormalSpeech,
                AudioFrame::VADActivity vad_activity = AudioFrame::kVadUnknown, uint32_t energy = -1);

private:
    AudioProcessing* apm;
    AudioFrame* audioFrame;
    short int * inputBuffer;
    short int * outputBuffer;

    size_t inputNumFrames;
    size_t procNumFrames;

    PushSincResampler* inputResampler;
    PushSincResampler* outputResampler;

    int calCurProcNumFrame(int input_num_frames);

};
#endif //KTVDEMO_AUDIOPROCESSINGPROXY_H
