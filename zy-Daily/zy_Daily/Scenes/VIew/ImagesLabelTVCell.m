//
//  ImagesLabelTVCell.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/27.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "ImagesLabelTVCell.h"

@implementation ImagesLabelTVCell

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
        self.mulLab.text = @"多图";
        self.mulLab.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:0.3];
    }
    if (_news.images.lastObject) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:_news.images.lastObject]];
    }
    self.titleLab.text = _news.title;
}

-(void)setTheme:(Theme *)theme{
    _theme = theme;
    if (_theme.thumbnail) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:_theme.thumbnail]];
    }
    self.titleLab.text = _theme.name;
    self.internetLab.text = _theme.desc;
}


@end
