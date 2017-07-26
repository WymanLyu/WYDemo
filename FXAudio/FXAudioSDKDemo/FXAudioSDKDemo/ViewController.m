//
//  ViewController.m
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

#import <FXAudio/AudioManager.h>
#import <FXAudio/AMRecorderPlayerControl.h>

#import "WYMeteorLightView.h"
#import "VGGradientSwitch.h"

#import <AVFoundation/AVFoundation.h>

#define BLUE_COLOR [UIColor colorWithRed:15/255.0 green:222/255.0 blue:200/255.0 alpha:1]
#define ORIGIN_COLOR [UIColor colorWithRed:237/255.0 green:140/255.0 blue:84/255.0 alpha:1]

@interface ViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) AMRecorderPlayerControl *control;
@property (nonatomic, strong) AudioManager *manager;

#pragma mark - IO
@property (weak, nonatomic) IBOutlet WYMeteorLightView *IOLineView;
@property (weak, nonatomic) IBOutlet UIImageView *micImageView;
@property (weak, nonatomic) IBOutlet UIImageView *speakImageView;
@property (weak, nonatomic) IBOutlet VGGradientSwitch *IOSwitch;
@property (weak, nonatomic) IBOutlet VGGradientSwitch *PreFXSwitch;

#pragma mark - 伴奏
@property (weak, nonatomic) IBOutlet UIImageView *fileImageView;
@property (weak, nonatomic) IBOutlet VGGradientSwitch *filePlayerSwitch;
@property (weak, nonatomic) IBOutlet WYMeteorLightView *fileLineTop1;
@property (weak, nonatomic) IBOutlet WYMeteorLightView *fileLineRight;
@property (weak, nonatomic) IBOutlet WYMeteorLightView *fileLineTop2;
@property (weak, nonatomic) IBOutlet UISlider *volumSlider;

#pragma mark - 返听
@property (weak, nonatomic) IBOutlet VGGradientSwitch *returnVoiceSwitch;
@property (weak, nonatomic) IBOutlet UIView *returnLine;

#pragma mark - 波形
@property (nonatomic, strong) CAGradientLayer *afterFXWaveViewMask;
@property (nonatomic, strong) CAGradientLayer *beforeFXWaveViewMask;

#pragma mark - 数据
@property (nonatomic, strong) NSMutableArray *recordFileListArrM;
@property (nonatomic, strong) NSURL *bgFileURL;
@property (nonatomic, strong) NSURL *selectedBgFileURL;
@property (nonatomic, weak)  UIPickerView *bgFilePickView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];

    [self audioManage];
    [self setupUI];
    [self setupEvent];
}

#pragma mark - 音频
- (void)audioManage {
    _bgFileURL = [[NSBundle mainBundle] URLForResource:@"lycka" withExtension:@"mp3"];
    _selectedBgFileURL = _bgFileURL;
    [self.recordFileListArrM addObject:_bgFileURL];
    _control = [AMRecorderPlayerControl controlWithRecordFileURL:nil playFileURL:_bgFileURL];
    _manager = [[AudioManager alloc] initWithDelegate:_control];
}

#pragma mark - 界面
- (void)setupUI {
    self.IOLineView.meteorLightColor = BLUE_COLOR;
    self.IOLineView.direction = MeteorLightDirectionBottom;
    self.fileLineTop1.direction = MeteorLightDirectionBottom;
    self.fileLineTop2.direction = MeteorLightDirectionBottom;
    self.fileLineRight.direction = MeteorLightDirectionRight;
    
    UIImageView *micMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microphone"]];
    micMask.contentMode = UIViewContentModeScaleAspectFit;
    micMask.frame = self.micImageView.bounds;
    self.micImageView.maskView = micMask;
    UIImageView *speakMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speaker"]];
    speakMask.contentMode = UIViewContentModeScaleAspectFit;
    speakMask.frame = self.speakImageView.bounds;
    self.speakImageView.maskView = speakMask;
    UIImageView *fileMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"file"]];
    fileMask.contentMode = UIViewContentModeScaleAspectFit;
    fileMask.frame = self.fileImageView.bounds;
    self.fileImageView.maskView = fileMask;
    
    UIPickerView *bgFilePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    bgFilePickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgFilePickView];
    _bgFilePickView = bgFilePickView;
    bgFilePickView.dataSource = self;
    bgFilePickView.delegate = self;
    [_bgFilePickView selectedRowInComponent:0];
    
    
}

#pragma mark - 事件
- (void)setupEvent {
    
    self.fileImageView.userInteractionEnabled = YES;
    [self.fileImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fileImageViewClick:)]];
    
    __weak typeof(self)weakSelf = self;
    self.IOSwitch.action =  ^(BOOL isOn){
        if (isOn) { // 关闭
            [weakSelf.IOLineView stop];
            weakSelf.speakImageView.backgroundColor = BLUE_COLOR;
            weakSelf.micImageView.backgroundColor = BLUE_COLOR;
            weakSelf.IOLineView.backgroundColor = BLUE_COLOR;

            [weakSelf.control stopRecorder];
            if (!weakSelf.filePlayerSwitch.isOn) { // 播放中
                [weakSelf.filePlayerSwitch setOn:YES animated:YES];
                weakSelf.filePlayerSwitch.action(YES);
            }
            [weakSelf.manager closeAudioIO];
            
        } else { // 打开
            [weakSelf.IOLineView start];
            weakSelf.speakImageView.backgroundColor = ORIGIN_COLOR;
            weakSelf.micImageView.backgroundColor = ORIGIN_COLOR;
            weakSelf.IOLineView.backgroundColor = ORIGIN_COLOR;
            
            [weakSelf.manager openAudioIO];
            [weakSelf.control startRecorder];
        }
    };
    self.filePlayerSwitch.action = ^(BOOL isOn){
        if (isOn) { // 关闭
            [weakSelf.fileLineRight stop];
            [weakSelf.fileLineTop1 stop];
            [weakSelf.fileLineTop2 stop];
            
            weakSelf.fileImageView.backgroundColor = BLUE_COLOR;
            weakSelf.fileLineRight.backgroundColor = BLUE_COLOR;
            weakSelf.fileLineTop1.backgroundColor = BLUE_COLOR;
            weakSelf.fileLineTop2.backgroundColor = BLUE_COLOR;
            weakSelf.volumSlider.tintColor = BLUE_COLOR;
            
            [weakSelf.control pausePlayer];
            
        } else { // 打开
            
            if (weakSelf.manager.isOpenIO) {
                
                [weakSelf.fileLineRight start];
                [weakSelf.fileLineTop1 start];
                [weakSelf.fileLineTop2 start];
                
                weakSelf.fileImageView.backgroundColor = ORIGIN_COLOR;
                weakSelf.fileLineRight.backgroundColor = ORIGIN_COLOR;
                weakSelf.fileLineTop1.backgroundColor = ORIGIN_COLOR;
                weakSelf.fileLineTop2.backgroundColor = ORIGIN_COLOR;
                weakSelf.volumSlider.tintColor = ORIGIN_COLOR
                ;
                
                [weakSelf.control startPlayer];
            } else {
                NSLog(@"请打开IO");
            }
        }
    };
    
    self.returnVoiceSwitch.action = ^(BOOL isOn){
        if (isOn) { // 关闭
            weakSelf.returnLine.hidden = NO;
            weakSelf.control.openReturnVoice = NO;
        } else { // 打开
            weakSelf.returnLine.hidden = YES;
            weakSelf.control.openReturnVoice = YES
            ;
        }
    };
    
    self.PreFXSwitch.action = ^(BOOL isOn){
        if (isOn) { // 关闭
            weakSelf.manager.openPreFX = NO;
        } else { // 打开
            weakSelf.manager.openPreFX = YES;
        }
    };

}

#pragma mark - 控制

- (IBAction)fileVolum:(UISlider *)sender {
    self.control.volume = sender.value;
}

- (IBAction)agcVolum:(UISlider *)sender {
    NSError* error;
    [AVAudioSession sharedInstance];
    if ([AVAudioSession sharedInstance].isInputGainSettable) {
        BOOL success = [[AVAudioSession sharedInstance] setInputGain:sender.value
                                                               error:&error];
        if (!success){
            NSLog(@"set input gain - error");
        }
    } else {
        NSLog(@"ios6 - cannot set input gain");
    }
}

-(void)dismissPickView:(UIButton *)maskBtn {
    CGRect tempR = self.bgFilePickView.frame;
    tempR.origin.y += tempR.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgFilePickView.frame = tempR;
    } completion:^(BOOL finished) {
        [maskBtn removeFromSuperview];
    }];
}

- (void)fileImageViewClick:(UITapGestureRecognizer *)tap {
    [self.IOSwitch setOn:YES animated:YES];
    self.IOSwitch.action(YES);
    [self scanRecordFileURL];
    [self.bgFilePickView reloadComponent:0];
    CGRect tempR = self.bgFilePickView.frame;
    tempR.origin.y -= tempR.size.height;
    UIButton *makBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    makBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    [makBtn addTarget:self action:@selector(dismissPickView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:makBtn belowSubview:self.bgFilePickView];
    [UIView animateWithDuration:0.25 animations:^{
        self.bgFilePickView.frame = tempR;
    }];
}

#pragma mark - 扫描录音文件

- (NSMutableArray *)recordFileListArrM {
    if (!_recordFileListArrM) {
        _recordFileListArrM = [NSMutableArray array];
    }
    return _recordFileListArrM;
}

- (void)scanRecordFileURL {
    [self.recordFileListArrM removeAllObjects];
    if (self.bgFileURL) {
         [self.recordFileListArrM addObject:self.bgFileURL];
    }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *recordDirPath = [NSString stringWithFormat:@"%@/FXAudioDemoRecorder", path];
    NSArray *contentsList= [manager contentsOfDirectoryAtPath:recordDirPath error:nil];
    if (!contentsList.count) {
        NSLog(@"扫描结果为空!");
        return;
    }
    for (NSString *fileName in contentsList) {
        if ([fileName hasSuffix:@".wav"]) {
            [self.recordFileListArrM addObject:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", recordDirPath, fileName]]];
        }
    }
}

#pragma mark - UIPickView

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.recordFileListArrM.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component  {
    return 44;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *path = [[self.recordFileListArrM objectAtIndex:row] absoluteString];
    NSString *fileName = [path lastPathComponent];
    return fileName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedBgFileURL = self.recordFileListArrM[row];
//    self.control.playFileURL = self.selectedBgFileURL;
    _control = [AMRecorderPlayerControl controlWithRecordFileURL:nil playFileURL:self.selectedBgFileURL];
    self.manager.delegate = _control;
}


- (IBAction)xxoo:(id)sender {
//    [self scanRecordFileURL];
//    for (int i = 0; i < 3; i++) {
//        [self.IOSwitch setOn:YES animated:YES];
//        self.IOSwitch.action(YES);
//        [self.control stopPlayer];
//        if ([self.recordFileListArrM objectAtIndex:i] == self.selectedBgFileURL) {
//            continue;
//        }
//        self.selectedBgFileURL = [self.recordFileListArrM objectAtIndex:i];
////        _control = nil;
//        _control = [AMRecorderPlayerControl controlWithRecordFileURL:nil playFileURL:self.selectedBgFileURL];
//        self.manager.delegate = _control;
//    }

}


@end



