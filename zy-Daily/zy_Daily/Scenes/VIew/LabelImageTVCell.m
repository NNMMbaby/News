//
//  LabelImageTVCell.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "LabelImageTVCell.h"

@implementation LabelImageTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNews:(News *)news{
    _news = news;
    if (news.multipic) {
        self.mul.text = @"多图";
        self.mul.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:0.3];
    }
    if (_news.images.lastObject) {
        [self.singleImg sd_setImageWithURL:[NSURL URLWithString:_news.images.lastObject]];
    }
    self.titleLabel.text = _news.title;
}

@end
