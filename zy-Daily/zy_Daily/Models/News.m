//
//  News.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "News.h"

@implementation News

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _Id = [value integerValue];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@---%ld---%@---%@", _title, _Id, _image_source, _image];
}


@end
