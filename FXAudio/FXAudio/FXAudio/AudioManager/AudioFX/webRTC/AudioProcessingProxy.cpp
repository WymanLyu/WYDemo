//
// Created by Paint on 2017/7/3.
//


//#include <webrtc/modules/audio_processing/agc/legacy/gain_control.h>
#include "AudioProcessingProxy.h"

#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)

#include "android/log.h"
#include "constants/LogTag.h"

#endif


AudioProcessingProxy::AudioProcessingProxy() {
    apm = AudioProcessingImpl::Create();

    //default config for agc
    GainControl *agc = apm->gain_control();
    if (agc->set_analog_level_limits(kMinVolumeLevel, 1.4125) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO,
                            "Failed to set analog level limits with minimum: %d", kMinVolumeLevel);
#endif
    }
    if (agc->set_mode(kDefaultAgcMode) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set mode: %d",
                            kDefaultAgcMode);
#endif
    }
    if (agc->Enable(kDefaultAgcState) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set agc state: %d",
                            kDefaultAgcState);
#endif
    }
    //>>
    if (agc->set_target_level_dbfs(-3.0)!=0) {
        
    }
//    if (agc->set_compression_gain_db(28.0)!=0) {
//        
//    }
    //>>

    //default config for ns
    NoiseSuppression *ns = apm->noise_suppression();
    if (ns->set_level(kDefaultNsMode) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set ns level: %d",
                            kDefaultNsMode);
#endif
    }
    if (ns->Enable(kDefaultNsState) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set ns state: %d",
                            kDefaultNsState);
#endif
    }

    audioFrame = new AudioFrame;
    inputResampler = NULL;
    outputResampler = NULL;
}

AudioProcessingProxy::~AudioProcessingProxy() {
    if (inputResampler != NULL) {
        free(inputBuffer);
        free(outputBuffer);
        delete inputResampler;
        delete outputResampler;
    }
    delete (audioFrame);
    delete (apm);

}

int AudioProcessingProxy::setAgcState(bool enable) {
    GainControl *agc = apm->gain_control();
    if (agc->Enable(enable) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set agc state: %d",
                            enable);

#endif
        return -1;
    }
    return 0;
}

int AudioProcessingProxy::setAgcMode(GainControl::Mode mode) {
    GainControl *agc = apm->gain_control();
    if (agc->set_mode(mode) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set mode: %d", mode);
#endif
        return -1;
    }
    return 0;
}

int AudioProcessingProxy::setNsState(bool enable) {
    NoiseSuppression *ns = apm->noise_suppression();
    if (ns->Enable(enable) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set ns state: %d",
                            enable);
#endif
        return -1;
    }
    return 0;
}

int AudioProcessingProxy::setNsLevel(NoiseSuppression::Level level) {
    NoiseSuppression *ns = apm->noise_suppression();
    if (ns->set_level(level) != 0) {
#if defined(WEBRTC_ANDROID) && defined(APP_LOG_DEBUG)
        __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG_KTV_DEMO, "Failed to set ns level: %d",
                            level);
#endif
        return -1;
    }
    return 0;
}

int AudioProcessingProxy::process(short int *input, short int *output, int numberOfSamples,
                                  int samplerate, size_t num_channels,
                                  AudioFrame::SpeechType speech_type,
                                  AudioFrame::VADActivity vad_activity, uint32_t energy) {
    if (inputNumFrames != numberOfSamples) {

        inputNumFrames = numberOfSamples;
        //输入采样率变化时, 需要重新初始化inputResampler和outputResampler
        if (inputResampler != NULL) {
            delete inputResampler;
            delete outputResampler;
            free(inputBuffer);
            free(outputBuffer);
        }
        procNumFrames = calCurProcNumFrame(numberOfSamples);
#if defined(WEBRTC_IOS)
        posix_memalign((void **)&inputBuffer, 16, procNumFrames * sizeof(short)*num_channels);
        posix_memalign((void **)&outputBuffer, 16, inputNumFrames * sizeof(short)*num_channels);
#endif
#if defined(WEBRTC_ANDROID)
        inputBuffer = static_cast<short *>(memalign(16, procNumFrames * sizeof(short) *
                                                        num_channels));
        outputBuffer = static_cast<short *>(memalign(16, inputNumFrames * sizeof(short) *
                                                         num_channels));
#endif
        inputResampler = new PushSincResampler(inputNumFrames*num_channels, procNumFrames*num_channels);
        outputResampler = new PushSincResampler(procNumFrames*num_channels, inputNumFrames*num_channels);

    }

    inputResampler->Resample(input, numberOfSamples * num_channels, inputBuffer,
                             procNumFrames * num_channels);
    audioFrame->UpdateFrame(-1, -1, inputBuffer, procNumFrames, procNumFrames * k10ms_ratio,
                            speech_type, vad_activity, num_channels);
    int ret = apm->ProcessStream(audioFrame);
    outputResampler->Resample(audioFrame->data(), procNumFrames * num_channels, output,
                              numberOfSamples * num_channels);

    return ret;
}

int AudioProcessingProxy::calCurProcNumFrame(int input_num_frames) {
    if (input_num_frames > 0 && input_num_frames <= 80) {
        return AudioProcessing::kSampleRate8kHz / k10ms_ratio;
    } else if (input_num_frames > 80 && input_num_frames <= 160) {
        return AudioProcessing::kSampleRate16kHz / k10ms_ratio;
    } else if (input_num_frames > 160 && input_num_frames <= 320) {
        return AudioProcessing::kSampleRate32kHz / k10ms_ratio;
    } else if (input_num_frames > 320 && input_num_frames <= 480) {
        return AudioProcessing::kSampleRate48kHz / k10ms_ratio;
    }
    return -1;
}
