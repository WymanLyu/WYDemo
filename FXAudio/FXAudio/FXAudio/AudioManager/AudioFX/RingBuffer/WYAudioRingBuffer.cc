//
//  WYAudioRingBuffer.c
//  FXAudioDemo
//
//  Created by wyman on 2017/7/4.
//  Copyright © 2017年 wyman. All rights reserved.
//

#include "WYAudioRingBuffer.h"
#include "WYRingBuffer.h"
#include "webrtc/base/checks.h"

WYAudioRingBuffer::WYAudioRingBuffer(size_t channels, size_t max_frames) {
    buffers_.reserve(channels);
    for (size_t i = 0; i < channels; ++i)
        buffers_.push_back(wy_CreateBuffer(max_frames, sizeof(float)));
}

WYAudioRingBuffer::~WYAudioRingBuffer() {
    for (auto buf : buffers_)
        wy_FreeBuffer(buf);
}

void WYAudioRingBuffer::Write(const float* const* data, size_t channels,
                            size_t frames) {
    RTC_DCHECK_EQ(buffers_.size(), channels);
    for (size_t i = 0; i < channels; ++i) {
        const size_t written = wy_WriteBuffer(buffers_[i], data[i], frames);
        RTC_CHECK_EQ(written, frames);
    }
}

void WYAudioRingBuffer::Read(float* const* data, size_t channels, size_t frames) {
    RTC_DCHECK_EQ(buffers_.size(), channels);
    for (size_t i = 0; i < channels; ++i) {
        const size_t read =
        wy_ReadBuffer(buffers_[i], nullptr, data[i], frames);
        RTC_CHECK_EQ(read, frames);
    }
}

size_t WYAudioRingBuffer::ReadFramesAvailable() const {
    // All buffers have the same amount available.
    return wy_available_read(buffers_[0]);
}

size_t WYAudioRingBuffer::WriteFramesAvailable() const {
    // All buffers have the same amount available.
    return wy_available_write(buffers_[0]);
}

void WYAudioRingBuffer::MoveReadPositionForward(size_t frames) {
    for (auto buf : buffers_) {
        const size_t moved =
        static_cast<size_t>(wy_MoveReadPtr(buf, static_cast<int>(frames)));
        RTC_CHECK_EQ(moved, frames);
    }
}

void WYAudioRingBuffer::MoveReadPositionBackward(size_t frames) {
    for (auto buf : buffers_) {
        const size_t moved = static_cast<size_t>(
                                                 -wy_MoveReadPtr(buf, -static_cast<int>(frames)));
        RTC_CHECK_EQ(moved, frames);
    }
}
