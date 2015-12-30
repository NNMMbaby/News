//
//  ImagesLabelTVCell.h
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/27.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "Theme.h"

@interface ImagesLabelTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *mulLab;
@property (strong, nonatomic) IBOutlet UILabel *internetLab;

@property (nonatomic, strong) News *news;

@property (nonatomic, strong) Theme *theme;

@end
