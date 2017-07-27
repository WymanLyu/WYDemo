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
#import <FXAudio/FxConstants.h>
#import <FXAudio/FXHeader.h>

#import "WYMeteorLightView.h"
#import "VGGradientSwitch.h"

#import <AVFoundation/AVFoundation.h>

#import "FXReverbView.h"
#import "FXFlangerView.h"
#import "FXEchoView.h"
#import "FXLimiterView.h"

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

#pragma mark - 效果器
@property (nonatomic, weak) UIScrollView *fxScrollView;

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
    _control = [AMRecorderPlayerControl controlWithRecordFileURL:nil playFileURL:_selectedBgFileURL];
    _manager = [[AudioManager alloc] initWithDelegate:_control];
    _manager.openFX = YES;
    
    // 设置效果器
    [self.manager.fxArrayM addObject:[[FXReverbItem alloc] initWithFXId:FX_TYPE_REVERB]];
    [self.manager.fxArrayM addObject:[[FXFlangerItem alloc] initWithFXId:FX_TYPE_FLANGER]];
    [self.manager.fxArrayM addObject:[[FXEchoItem alloc] initWithFXId:FX_TYPE_ECHO]];
    [self.manager.fxArrayM addObject:[[FXLimiterItem alloc] initWithFXId:FX_TYPE_LIMITER]];
    
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
    
    [self setFXUI];
    
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
        NSLog(@"device cannot set input gain");
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
    self.control.playFileURL = self.selectedBgFileURL;
//    _control = [AMRecorderPlayerControl controlWithRecordFileURL:nil playFileURL:self.selectedBgFileURL];
//    self.manager.delegate = _control;
}

#pragma mark - 效果器
- (FXItem *)checkFXFromFXArr:(NSArray <FXItem *>*)fxArray fxId:(long)fxId {
    for (FXItem *item in self.manager.fxArrayM) {
        if (item.fxId == fxId) {
            return item;
        }
    }
    return nil;
}

- (void)dismissFXView:(UIButton *)maskBtn {
    CGRect tempR = self.bgFilePickView.frame;
    tempR.origin.y += tempR.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.fxScrollView.frame = tempR;
    } completion:^(BOOL finished) {
        [maskBtn removeFromSuperview];
    }];

}

- (IBAction)fxBtnClick:(id)sender {
    CGRect tempR = self.bgFilePickView.frame;
    tempR.origin.y -= tempR.size.height;
    UIButton *makBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    makBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
    [makBtn addTarget:self action:@selector(dismissFXView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:makBtn belowSubview:self.bgFilePickView];
    [UIView animateWithDuration:0.25 animations:^{
        self.fxScrollView.frame = tempR;
    }];
}

- (void)setFXUI {
    UIScrollView *fxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
    fxScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fxScrollView];
    _fxScrollView = fxScrollView;
    _fxScrollView.pagingEnabled = YES;

    CGFloat contentSizeW = 0.0;
    CGFloat sizeW = [UIScreen mainScreen].bounds.size.width;
    CGFloat sizeH = 200;
    for (int i=0; i<self.manager.fxArrayM.count; i++) {
        FXItem *item = self.manager.fxArrayM[i];
        switch (item.fxId) {
            case FX_TYPE_FILTER:
            {
                
            }
                break;
            case FX_TYPE_REVERB:
            {
                FXReverbItem *realItem = (FXReverbItem *)item;
                FXReverbView *reverbView = [FXReverbView viewFromNibNamed:@"FXReverbView" owner:nil];
                reverbView.frame = CGRectMake(sizeW*i, 0, sizeW, sizeH);
                reverbView.tag = FX_TYPE_REVERB;
                reverbView.item = realItem;
                [_fxScrollView addSubview:reverbView];
                contentSizeW+=sizeW;
            }
                break;
            case FX_TYPE_FLANGER:
            {
                FXFlangerItem *realItem = (FXFlangerItem *)item;
                FXFlangerView *flangerView = [FXFlangerView viewFromNibNamed:@"FXFlangerView" owner:nil];
                flangerView.frame = CGRectMake(sizeW*i, 0, sizeW, sizeH);
                flangerView.tag = FX_TYPE_FLANGER;
                flangerView.item = realItem;
                [_fxScrollView addSubview:flangerView];
                 contentSizeW+=sizeW;
            }
                break;
            case FX_TYPE_3_BAND_EQ:
            {
                
            }
                break;
            case FX_TYPE_GATE:
            {
                
            }
                break;
            case FX_TYPE_ROLL:
            {
                
            }
                break;
            case FX_TYPE_ECHO:
            {
                FXEchoItem *realItem = (FXEchoItem *)item;
                FXEchoView *echoView = [FXEchoView viewFromNibNamed:@"FXEchoView" owner:nil];
                echoView.frame = CGRectMake(sizeW*i, 0, sizeW, sizeH);
                echoView.tag = FX_TYPE_FLANGER;
                echoView.item = realItem;
                [_fxScrollView addSubview:echoView];
                contentSizeW+=sizeW;
            }
                break;
            case FX_TYPE_WOOSH:
            {
                
            }
                break;
            case FX_TYPE_LIMITER:
            {
                FXLimiterItem *realItem = (FXLimiterItem *)item;
                FXLimiterView *limiteView = [FXLimiterView viewFromNibNamed:@"FXLimiterView" owner:nil];
                limiteView.frame = CGRectMake(sizeW*i, 0, sizeW, sizeH);
                limiteView.tag = FX_TYPE_FLANGER;
                limiteView.item = realItem;
                [_fxScrollView addSubview:limiteView];
                contentSizeW+=sizeW;
            }
                break;
            default:
                break;
        }
    }
    _fxScrollView.contentSize = CGSizeMake(contentSizeW, sizeH);

}



@end



