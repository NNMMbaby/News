//
//  LabelImageTVCell.h
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface LabelImageTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *singleImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *mul;

@property (nonatomic, strong) News *news;

@end
