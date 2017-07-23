//
//  Hello.cpp
//  7-23MultiTarget
//
//  Created by wyman on 2017/7/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#include "Hello.h"
#include <stdio.h>

//Hello::Hello()
//{
//    int number = TARGET_NUMBER;
//    printf("target 2 -- target_number==%zd\n", number);
//}

extern void Hello_test()
{
    int number = TARGET_NUMBER;
    printf("target 3 -- target_number==%zd\n", number);
}
