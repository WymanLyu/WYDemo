//
//  ViewController.m
//  WYCoreImageDemo
//
//  Created by yunyao on 16/9/10.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "ViewController.h"
#import "TransitionView.h"
#import "BackgroundFilter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *inputImgView;
@property (weak, nonatomic) IBOutlet UIImageView *outputImgView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, strong) CIImage *transionImage;

@end

@implementation ViewController
{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.inputImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.inputImgView.clipsToBounds = YES;
    
    self.outputImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.outputImgView.clipsToBounds = YES;

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)transitionClick:(id)sender {
    
    // 1.换成转场视图
    TransitionView *transitionView = [[TransitionView alloc] initWithFrame: self.inputImgView.bounds];
    [self.inputImgView addSubview:transitionView];
    
}

// 背景色滤镜
- (IBAction)backgroundFilter:(id)sender {
    
    // 1.获取路径
    NSString *imagePath = @"/Users/yunyao/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ/Users/384846187/QQ/Temp.db/BAFC0F69-F9BE-4845-BF34-8C0EF34CAF9D.png";
    
    // 2.获取图片url
    NSURL *fileUrl = [NSURL fileURLWithPath:imagePath];
    
    // 3.core image 的上下文
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO}];
    
    // 4.创建输入图片
    CIImage *inputImage = [CIImage imageWithContentsOfURL:fileUrl];
    
    // 5.渲染
    CGImageRef inImageRef = [context createCGImage:inputImage fromRect:[inputImage extent]];
    if (inImageRef) {
        self.inputImgView.image = [UIImage imageWithCGImage:inImageRef];
    }
    
    // 6.创建滤镜
    BackgroundFilter *backgroundFilter = [[BackgroundFilter alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 设置输入
//        [backgroundFilter setValue:inputImage forKey:@"inputImage"];
        backgroundFilter.inputImage = inputImage;
        // 设置去除颜色最小角度
        [backgroundFilter setValue:@90 forKey:inputMinHueAngle];
        // 设置去除颜色最大角度
        [backgroundFilter setValue:@140 forKey:inputMaxHueAngle];
        // 7.获取输出
        CIImage *outImage = backgroundFilter.outputImage;
        // 回主线程渲染
        dispatch_async(dispatch_get_main_queue(), ^{
            // 8.渲染
            CGImageRef outImageRef = [context createCGImage:outImage fromRect:[outImage extent]];
            self.outputImgView.backgroundColor = [UIColor grayColor];
            self.outputImgView.image = [UIImage imageWithCGImage:outImageRef];
            CGImageRelease(outImageRef);
        });
        
    });

    
    
}


- (IBAction)doneClick:(id)sender {
    
    [self.urlTextField resignFirstResponder];
    
    // 1.获取路径/Users/wyman/Desktop/2C91698D-784C-468D-A6B8-3FA6AE4DD533.png
    NSString *imagePath = self.urlTextField.text;
    
    // 2.获取图片url
    NSURL *fileUrl = [NSURL fileURLWithPath:imagePath];
    
    // 3.core image 的上下文
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO}];
    
    // 4.创建输入图片
    CIImage *inputImage = [CIImage imageWithContentsOfURL:fileUrl];
    
    // 5.渲染
    CGImageRef inImageRef = [context createCGImage:inputImage fromRect:[inputImage extent]];
    if (inImageRef) {
        self.inputImgView.image = [UIImage imageWithCGImage:inImageRef];
    }
    
    // 6.查询模糊滤镜有哪些
    NSArray *arr = [CIFilter filterNamesInCategory:kCICategoryBlur];
    NSLog(@"%@", arr);
    // 获取高斯滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // 查询属性
    NSLog(@"%@", filter.attributes);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 设置默认值
        [filter setDefaults];
        // 设置输入
        [filter setValue:inputImage forKey:@"inputImage"];
        // 设置模糊半径
        [filter setValue:@2 forKey:@"inputRadius"];
        // 设置模糊角度
        [filter setValue:@2 forKey:@"inputRadius"];
        // 7.获取输出
        CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
        // 回主线程渲染
        dispatch_async(dispatch_get_main_queue(), ^{
            // 8.渲染
            CGImageRef outImageRef = [context createCGImage:outImage fromRect:[outImage extent]];
            self.outputImgView.image = [UIImage imageWithCGImage:outImageRef];
            CGImageRelease(outImageRef);
        });

    });


    CGImageRelease(inImageRef);
}









@end
