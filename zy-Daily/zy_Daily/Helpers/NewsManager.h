//
//  NewsManager.h
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/19.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>
@class News;

@protocol NewsManagerDelegate <NSObject>

@optional
-(void)reload;

-(void)reloadWith:(NSString *)image Name:(NSString *)name stories:(NSArray *)news;

-(void)reloadWithThemes:(NSArray *)themes Sections:(NSArray *)section;

-(void)failRequest;

@end

@interface NewsManager : NSObject

// 今日日期
@property (nonatomic, strong) NSMutableArray *date;
// 热文(滚动视图上的)
@property (nonatomic, strong) NSMutableArray *hotNews;
// 存放所有新闻，key值为日期
@property (nonatomic, strong) NSMutableDictionary *newsDic;
// 字典所有日期
@property (nonatomic, strong) NSMutableArray *allKeys;
// 轮播图的图片
@property (nonatomic, strong) NSMutableArray *imageNameArray ;
// 轮播图的文字
@property (nonatomic, strong) NSMutableArray * adTitleArray;
// 代理
@property (nonatomic, assign) id<NewsManagerDelegate> delegate;
// 主题
@property (nonatomic, strong) NSMutableArray *theme8;
// 专栏
@property (nonatomic, strong) NSMutableArray *section8;

+(NewsManager *)shareNewsManager;

-(void)reloadNews;

-(void)getOldNews;

-(void)getThemes;

-(void)getSections;

-(void)getThemeDetail:(NSString *)Id;

-(void)getSectionDetail:(NSString *)Id;

-(NSString *)getNextNewsIdWithId:(NSString *)newsId;
-(NSString *)getPreNewsIdWithId:(NSString *)newsId;
-(NSArray *)getAllNews;


@end
