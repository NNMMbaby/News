//
//  NewsManager.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/19.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "NewsManager.h"
#import "News.h"
#import "Theme.h"

@implementation NewsManager

static NewsManager *newsM = nil;
+(NewsManager *)shareNewsManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newsM = [NewsManager new];
        [newsM getNews];
    });
    return newsM;
}
// 解析今日数据
-(void)getNews{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    __weak typeof(self) temp = self;
    [manager GET:kHomeUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功了");
//        [self.date addObject:responseObject[@"date"]];
        // 获取今日热闻（即滚动视图上的新闻）
        NSArray *hotNew = responseObject[@"top_stories"];
        if (self.hotNews.count > 0) {
            [self.hotNews removeAllObjects];
            [self.adTitleArray removeAllObjects];
            [self.imageNameArray removeAllObjects];
        }
//        NSLog(@"%ld========%ld??????????%ld", self.hotNews.count, self.adTitleArray.count, self.imageNameArray.count);
        for (NSDictionary *dic in hotNew) {
            News *news = [News new];
            [news setValuesForKeysWithDictionary:dic];
            [self.imageNameArray addObject:news.image];
            [self.adTitleArray addObject:news.title];
            [self.hotNews addObject:news];
//            NSLog(@"+++++++++++++++++%ld", _adTitleArray.count);
        }
        // 获取今日新闻（tableView上的新闻）
        NSArray *todayNew = responseObject[@"stories"];
        NSMutableArray *todayNews = [NSMutableArray array];
        for (NSDictionary *dic in todayNew) {
            News *news = [News new];
            [news setValuesForKeysWithDictionary:dic];
            [todayNews addObject:news];
        }
        [self.newsDic setObject:todayNews forKey:responseObject[@"date"]];  //self.date.lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.delegate reload];
        });
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"失败了");
        [temp.delegate failRequest];
    }];
}
// 刷新数据
-(void)reloadNews{
    [self getNews];
}
// 解析往日数据
-(void)getOldNews{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    __weak typeof(self) temp = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", kOldUrl, self.date.lastObject];
    NSLog(@"%@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功了");
        if (![self.date containsObject:responseObject[@"date"]]) {
//            [self.date addObject:responseObject[@"date"]];
//            [self.date sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                return [obj2 compare:obj1];
//            }];
            // 获取今日新闻（tableView上的新闻）
            NSArray *todayNew = responseObject[@"stories"];
            NSMutableArray *newss = [NSMutableArray array];
            for (NSDictionary *dic in todayNew) {
                News *news = [News new];
                [news setValuesForKeysWithDictionary:dic];
                [newss addObject:news];
            }
//            NSLog(@"++++++++++++%@", self.date.lastObject);
            [self.newsDic setObject:newss forKey:responseObject[@"date"]];   // self.date.lastObject];
//            dispatch_async(dispatch_get_main_queue(), ^{
                [temp.delegate reload];
//            });
        }else{
            NSLog(@"存在");
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------------失败了");
        [temp.delegate failRequest];
    }];
}

-(void)getThemes{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kThemesUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (self.theme8.count) {
            [_theme8 removeAllObjects];
        }
        NSLog(@"成功了");
        NSArray *array = responseObject[@"others"];
        for (NSDictionary *dic in array) {
            Theme *theme = [Theme new];
            [theme setValuesForKeysWithDictionary:dic];
            if (![self.theme8 containsObject:theme]) {
                [self.theme8 addObject:theme];
            }
        }
        [self.delegate reload];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------------失败了");
        [self.delegate failRequest];
    }];
}

-(void)getSections{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kSectionsUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (self.section8.count) {
            [_section8 removeAllObjects];
        }
        NSLog(@"成功了");
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dic in array) {
            Theme *theme = [Theme new];
            [theme setValuesForKeysWithDictionary:dic];
            if (![self.section8 containsObject:theme]) {
                [self.section8 addObject:theme];
            }
        }
        [self.delegate reload];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------------失败了");
        [self.delegate failRequest];
    }];
}

-(void)getThemeDetail:(NSString *)Id{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@%@", kOneTheme, Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功了");
        NSArray *array = responseObject[@"stories"];
        NSMutableArray *mutable = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            News *news = [News new];
            [news setValuesForKeysWithDictionary:dic];
            [mutable addObject:news];
        }
        [self.delegate reloadWith:responseObject[@"image"] Name:responseObject[@"name"] stories:mutable];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------------失败了");
        [self.delegate failRequest];
    }];
}

-(void)getSectionDetail:(NSString *)Id{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@%@", kOneSection, Id];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功了");
        NSArray *array = responseObject[@"stories"];
        NSMutableArray *mutable = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            News *news = [News new];
            [news setValuesForKeysWithDictionary:dic];
            [mutable addObject:news];
        }
        [self.delegate reloadWith:responseObject[@"image"] Name:responseObject[@"name"] stories:mutable];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------------失败了");
        [self.delegate failRequest];
    }];
}

-(NSString *)getNextNewsIdWithId:(NSString *)newsId{
    NSLog(@"BBBBBBBBBBBBBBBBBBBB%@", newsId);
    NSArray *array = [self getAllNews];
    if ([array.lastObject Id] == [newsId integerValue]) {
        [self getOldNews];
         NSArray *array1 = [self getAllNews];
        for (int i = 0; i < array1.count - 1; i ++) {
            News *news = array1[i];
            if (news.Id == [newsId integerValue]) {
                return [NSString stringWithFormat:@"%ld", [array1[i+1] Id]];
            }
        }
    }else{
        for (int i = 0; i < array.count; i ++) {
            News *news = array[i];
            if (news.Id == [newsId integerValue]) {
                return [NSString stringWithFormat:@"%ld", [array[i+1] Id]];
            }
        }                         
    }
    return nil;
}

-(NSString *)getPreNewsIdWithId:(NSString *)newsId{
     NSLog(@"BBBBBBBBBBBBBBBBBBBBBBBB%@", newsId);
    NSArray *array = [self getAllNews];
    if ([array[0] Id] == [newsId integerValue]) {
        return @"first";
    }
    for (int i = 0; i < array.count; i ++) {
        News *news = array[i];
        if (news.Id == [newsId integerValue] && ![news isEqual:array[0]]) {
            return [NSString stringWithFormat:@"%ld", [array[i-1] Id]];
        }
    }
    return nil;
}

-(NSMutableArray *)section8{
    if (!_section8) {
        _section8 = [NSMutableArray array];
    }
    return _section8;
}

-(NSMutableArray *)theme8{
    if (!_theme8) {
        _theme8 = [NSMutableArray array];
    }
    return _theme8;
}

-(NSArray *)getAllNews{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in self.date) {
//        NSLog(@"%@", str);
        NSArray *value = self.newsDic[str];
        for (News *news in value) {
            [array addObject:news];
//            NSLog(@"￥￥￥￥￥￥￥￥￥￥￥￥%@", news.title);
        }
    }
    return array;
}

-(NSMutableArray *)adTitleArray{
    if (!_adTitleArray) {
        _adTitleArray = [NSMutableArray array];
    }
    return _adTitleArray;
}

-(NSMutableArray *)imageNameArray{
    if (!_imageNameArray) {
        _imageNameArray = [NSMutableArray array];
    }
    return _imageNameArray;
}

-(NSMutableArray *)date{
    if (!_date) {
        _date = [NSMutableArray array];
    }
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[self.newsDic allKeys]];
    [keys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    _date = keys;
    return _date;
}

-(NSMutableDictionary *)newsDic{
    if (!_newsDic) {
        _newsDic = [NSMutableDictionary dictionary];
    }
    return _newsDic;
}

-(NSMutableArray *)hotNews{
    if (!_hotNews) {
        _hotNews = [NSMutableArray array];
    }
    return _hotNews;
}


@end
