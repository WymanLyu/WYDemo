//
//  ViewController.m
//  WYCoreImageDemo
//
//  Created by yunyao on 16/9/10.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *inputImgView;
@property (weak, nonatomic) IBOutlet UIImageView *outputImgView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation ViewController

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


- (IBAction)doneClick:(id)sender {
    
    [self.outputImgView resignFirstResponder];
    
    // 1.获取路径
    NSString *imagePath = self.urlTextField.text;
    
    // 2.获取图片url
    NSURL *fileUrl = [NSURL fileURLWithPath:imagePath];
    
    // 3.core image 的上下文
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO}];
    // 转换坐标系
    
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
    CIFilter *filter = [CIFilter filterWithName:@"CIMotionBlur"];
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
        [filter setValue:@40 forKey:@"inputRadius"];
        // 7.获取输出
        CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
        // 回主线程渲染
        dispatch_async(dispatch_get_main_queue(), ^{
            // 8.渲染
            CGImageRef outImageRef = [context createCGImage:outImage fromRect:[outImage extent]];
            self.outputImgView.image = [UIImage imageWithCGImage:outImageRef];
        });
        
    });
    
   
    
    CGImageRelease(inImageRef);
}









@end
