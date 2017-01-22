//
//  MovieCell.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/25.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "MovieCell.h"
#import <Foundation/Foundation.h>

@interface MovieCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *length;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation MovieCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:nil options:nil] firstObject];
    }
    MovieCell *moviewCell = (MovieCell *)cell;
    return moviewCell;
}

- (void)setItem:(MovieItem *)item {
    _item = item;
    if (_item.img) {
        [self.image setImage:item.img];
    }else {
        
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:item.image] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            item.img = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.image setImage:item.img];
            });
        }] resume];
    }
    
    self.title.text = item.name;
    self.length.text = [NSString stringWithFormat:@"%zd", item.length];
    self.number.text = [NSString stringWithFormat:@"%zd", item.base_id];
}

@end
