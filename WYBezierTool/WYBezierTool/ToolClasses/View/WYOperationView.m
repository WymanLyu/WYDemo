//
//  WYOperationView.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYOperationView.h"

@implementation WYOperationView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        NSButton *addBtn = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(15, 15, 35, 35))];
        addBtn.title = @"+";
        addBtn.target = self;
        [addBtn setAction:@selector(addBtnClik)];
        [self addSubview:addBtn];
        
        
        NSButton *minusBtn = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(15, 65, 35, 35))];
        minusBtn.title = @"-";
        minusBtn.target = self;
        [minusBtn setAction:@selector(minusBtnClik)];
        [self addSubview:minusBtn];
        
    }
    return self;
}

- (void)addBtnClik {
    if (self.addClik) {
        self.addClik();
    }
}

- (void)minusBtnClik {
    if (self.minusClik) {
        self.minusClik();
    }
    
}

@end
