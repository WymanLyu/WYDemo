//
//  WYAudioRingBuffer.h
//  FXAudioDemo
//
//  Created by wyman on 2017/7/4.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef WYAudioRingBuffer_h
#define WYAudioRingBuffer_h

#include <stddef.h>
#include <vector>

struct RingBuffer;

// A ring buffer tailored for float deinterleaved audio. Any operation that
// cannot be performed as requested will cause a crash (e.g. insufficient data
// in the buffer to fulfill a read request.)
class WYAudioRingBuffer final {
public:
    // Specify the number of channels and maximum number of frames the buffer will
    // contain.
    WYAudioRingBuffer(size_t channels, size_t max_frames);
    ~WYAudioRingBuffer();
    
    // Copies |data| to the buffer and advances the write pointer. |channels| must
    // be the same as at creation time.
    void Write(const float* const* data, size_t channels, size_t frames);
    
    // Copies from the buffer to |data| and advances the read pointer. |channels|
    // must be the same as at creation time.
    void Read(float* const* data, size_t channels, size_t frames);
    
    size_t ReadFramesAvailable() const;
    size_t WriteFramesAvailable() const;
    
    // Moves the read position. The forward version advances the read pointer
    // towards the write pointer and the backward verison withdraws the read
    // pointer away from the write pointer (i.e. flushing and stuffing the buffer
    // respectively.)
    void MoveReadPositionForward(size_t frames);
    void MoveReadPositionBackward(size_t frames);
    
private:
    // We don't use a ScopedVector because it doesn't support a specialized
    // deleter (like scoped_ptr for instance.)
    std::vector<RingBuffer*> buffers_;
};


#endif /* WYAudioRingBuffer_h */
