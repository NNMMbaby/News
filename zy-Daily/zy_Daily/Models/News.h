//
//  News.h
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSString *ga_prefix;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger type;
// tableView上的图片
@property (nonatomic, strong) NSArray *images;
// 详情和热闻的图片
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *image_source;
@property (nonatomic, strong) NSArray *css;
@property (nonatomic, assign) bool multipic;
@property (nonatomic, strong) NSString *date;



@end
