//
//  NewsDetailVC.h
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/18.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailVC : UIViewController

@property (nonatomic, strong) NSArray *newsArray;

@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) NSString *newsDate;

@end
