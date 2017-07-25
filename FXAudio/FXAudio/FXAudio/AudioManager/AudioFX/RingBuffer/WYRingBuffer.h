//
//  WYRingBuffer.h
//  FXAudioDemo
//
//  Created by wyman on 2017/7/4.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef WYRingBuffer_h
#define WYRingBuffer_h

#ifdef __cplusplus
extern "C" {
#endif
    
#include <stddef.h>  // size_t
    
typedef struct RingBuffer RingBuffer;

// Creates and initializes the buffer. Returns NULL on failure.
RingBuffer* wy_CreateBuffer(size_t element_count, size_t element_size);
void wy_InitBuffer(RingBuffer* handle);
void wy_FreeBuffer(void* handle);

// Reads data from the buffer. The |data_ptr| will point to the address where
// it is located. If all |element_count| data are feasible to read without
// buffer wrap around |data_ptr| will point to the location in the buffer.
// Otherwise, the data will be copied to |data| (memory allocation done by the
// user) and |data_ptr| points to the address of |data|. |data_ptr| is only
// guaranteed to be valid until the next call to wy_WriteBuffer().
//
// To force a copying to |data|, pass a NULL |data_ptr|.
//
// Returns number of elements read.
size_t wy_ReadBuffer(RingBuffer* handle,
                         void** data_ptr,
                         void* data,
                         size_t element_count);

// Writes |data| to buffer and returns the number of elements written.
size_t wy_WriteBuffer(RingBuffer* handle, const void* data,
                          size_t element_count);

// Moves the buffer read position and returns the number of elements moved.
// Positive |element_count| moves the read position towards the write position,
// that is, flushing the buffer. Negative |element_count| moves the read
// position away from the the write position, that is, stuffing the buffer.
// Returns number of elements moved.
int wy_MoveReadPtr(RingBuffer* handle, int element_count);

// Returns number of available elements to read.
size_t wy_available_read(const RingBuffer* handle);

// Returns number of available elements for write.
size_t wy_available_write(const RingBuffer* handle);
    
#ifdef __cplusplus
}
#endif


#endif /* WYRingBuffer_h */
