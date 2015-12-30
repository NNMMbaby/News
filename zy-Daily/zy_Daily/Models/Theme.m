//
//  Theme.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/23.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "Theme.h"

@implementation Theme

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _Id = [value integerValue];
    }
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
}

@end
