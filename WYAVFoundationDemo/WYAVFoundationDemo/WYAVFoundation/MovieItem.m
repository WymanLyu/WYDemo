//
//  MovieItem.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/25.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "MovieItem.h"
#import <UIKit/UIKit.h>

@implementation MovieItem

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    MovieItem *item = [[self alloc] init];
    if (item) {
        item.base_id = [dict[@"id"] integerValue];
        item.name = dict[@"name"];
        item.length = [dict[@"length"] integerValue];
        item.image = [NSString stringWithFormat:@"http://120.25.226.186:32812/%@", dict[@"image"]];
        item.url = [NSString stringWithFormat:@"http://120.25.226.186:32812/%@", dict[@"url"]];
 
    }
    return item;
}


@end
