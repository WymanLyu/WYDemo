//
//  ViewController.m
//  10-2testNSUserDefaults
//
//  Created by wyman on 2017/10/2.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mylabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"checkIfInitialized"]){
        NSLog(@"setting checkIfInitialized as not exist");
        [[NSUserDefaults standardUserDefaults] setValue:@"test" forKey:@"checkIfInitialized"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.view.backgroundColor=[UIColor redColor];
        self.mylabel.text=@"NSUserDefaults was NOT there, try running again";
    } else {
        NSLog(@"checkIfInitialized exists already");
        self.view.backgroundColor=[UIColor blueColor];
        self.mylabel.text=@"NSUserDefaults was already there this time, try running again";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
