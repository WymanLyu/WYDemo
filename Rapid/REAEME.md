

// 新启一个下载任务追加到session

// 1.创建下载任务

```
WYDownloadTask *task = [WYDownloadTask download:self.url toDestinationPath:nil progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
	// 进度
} state:^(WYDownloadState state, NSString *file, NSError *error) {
	// 状态
}];
```
// 2.追加到session中

```
[[WYDownloadSession shareSession] appendDownloadTask:task];
```
// 3.开启任务

```
[[WYDownloadSession shareSession] resumeTask:task];
```

// 从session中获取下载任务

// 1.获取下载任务

```
WYDownloadTask *task = [[WYDownloadSession shareSession] download:self.url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
	// 进度
} state:^(WYDownloadState state, NSString *file, NSError *error) {
	// 状态
} autoResume:NO];
```

// 2.开启任务

```
[[WYDownloadSession shareSession] resumeTask:task];
```

// 从session中查找任务

// 1.查找下载任务

```
WYDownloadTask *downTask = [[WYDownloadSession shareSession] selectDownLoadTask:_url];
```

// 2.session开启下载

```
[[WYDownloadSession shareSession] download:self.url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
	// 进度
} state:^(WYDownloadState state, NSString *file, NSError *error) {
	// 状态
}];
```
