//
//  zy_daily_header.h
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#ifndef zy_daily_header_h
#define zy_daily_header_h

// 今日
#define kHomeUrl @"http://news-at.zhihu.com/api/4/news/latest"
// 过往,拼接日期,格式:20131120,查询的是19日的消息
#define kOldUrl @"http://news.at.zhihu.com/api/4/news/before/"
// 下载,拼接id, 例:3892357
#define kDownloadUrl @"http://news-at.zhihu.com/api/4/news/"
// 主题日报列表
#define kThemesUrl @"http://news-at.zhihu.com/api/4/themes"
// 专栏
#define kSectionsUrl @"http://news-at.zhihu.com/api/3/sections"
// 某个主题详情
#define kOneTheme @"http://news-at.zhihu.com/api/4/theme/"
// 某个专栏详情
#define kOneSection @"http://news-at.zhihu.com/api/3/section/"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight ([UIScreen mainScreen].bounds.size.height + 64)

#endif /* zy_daily_header_h */
