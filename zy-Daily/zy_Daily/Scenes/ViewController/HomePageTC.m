//
//  HomePageTC.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "HomePageTC.h"
#import "News.h"
#import "LabelImageTVCell.h"
#import "ImagesLabelTVCell.h"
#import "AdScrollView.h"
#import "NewsDetailVC.h"
#import "NewsManager.h"


@interface HomePageTC () <NewsManagerDelegate, UIScrollViewDelegate>
// 今日日期
@property (nonatomic, strong) NSString *date;
// 头视图
@property (strong, nonatomic) IBOutlet UIView *scrollViewBackground;
// 滚动视图
@property (strong, nonatomic) AdScrollView *adSV;
// 页面是否需要刷新
@property (assign, nonatomic) BOOL refresh;
// 放小菊花的view
@property (nonatomic, retain) UIView *backgroundView;
// 系统小菊花
@property (nonatomic, retain) UIActivityIndicatorView *act;
//  系统菊花label
@property (nonatomic, retain) UILabel *actLab;
@property (strong, nonatomic) IBOutlet UIButton *section;
@property (strong, nonatomic) IBOutlet UIButton *theme;
@end

@implementation HomePageTC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"LabelImageTVCell" bundle:nil]  forCellReuseIdentifier:@"Cell"];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ImagesLabelTVCell" bundle:nil]  forCellReuseIdentifier:@"Cell2"];
    self.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    self.refresh = NO;
    self.scrollViewBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.4);
    [self createScrollView];
    [self tDataAnalyze];
    [self createAct];
}

-(void)createAct{
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kWidth, kHeight)];
    _backgroundView.backgroundColor = [UIColor lightGrayColor];
    self.act = [[UIActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _act.center = _backgroundView.center;
    self.actLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    _actLab.center = CGPointMake(_act.center.x, _act.center.y + 30);
    _actLab.text = @"加载...";
    _actLab.textColor = [UIColor whiteColor];
    _actLab.font = [UIFont systemFontOfSize:15];
    _actLab.textAlignment = NSTextAlignmentCenter;
    [_backgroundView addSubview:_actLab];
    [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_backgroundView addSubview:_act];
    [self addToView];
}

-(void)removeAct{
    self.section.hidden = NO;
    self.theme.hidden = NO;
    [_act stopAnimating];
    [_backgroundView removeFromSuperview];
}

-(void) addToView{
    self.section.hidden = YES;
    self.theme.hidden = YES;
    [_act startAnimating];
    [self.view addSubview:_backgroundView];
}

-(void)tDataAnalyze{
    [NewsManager shareNewsManager].delegate = self;
}

-(void)reload{
    self.date = [NewsManager shareNewsManager].date.lastObject;
    [self.tableView reloadData];
    [self createScrollView];
}
-(void)failRequest{
    [self removeAct];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示：请查看网络是否连接" message:@"网络请求失败，请再次请求" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self tDataAnalyze];
    }];
    [alert addAction:ensure];
    // 添加视图
    [self presentViewController:alert animated:YES completion:nil];
}

// 创建滚动视图
- (void)createScrollView{
    if ([NewsManager shareNewsManager].imageNameArray.count == 0) {
        return;
    }
    if (self.adSV) {
        self.adSV = nil;
    }
    AdScrollView * scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, -64, self.scrollViewBackground.frame.size.width, self.scrollViewBackground.frame.size.height + 64)];
    NSMutableArray *imageNA = [NSMutableArray array];
    [imageNA addObject:[NewsManager shareNewsManager].imageNameArray.lastObject];
    for (int i = 0; i < [NewsManager shareNewsManager].imageNameArray.count - 1; i ++) {
        [imageNA addObject:[NewsManager shareNewsManager].imageNameArray[i]];
    }
    scrollView.imageNameArray = imageNA;
    scrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
     NSMutableArray *adTA = [NSMutableArray array];
    [adTA addObject:[NewsManager shareNewsManager].adTitleArray.lastObject];
    for (int i = 0; i < [NewsManager shareNewsManager].adTitleArray.count - 1; i ++) {
        [adTA addObject:[NewsManager shareNewsManager].adTitleArray[i]];
    }
    for (NSString *str in adTA) {
        NSLog(@"%@", str);
    }
    [scrollView setAdTitleArray:adTA withShowStyle:AdTitleShowStyleCenter];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.adSV = scrollView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDetail)];
    tap.numberOfTapsRequired = 1;
    [_adSV addGestureRecognizer:tap];
    [self.scrollViewBackground addSubview:_adSV];
    [self removeAct];
}

-(void)gotoDetail{
    NewsDetailVC *detVC = [[NewsDetailVC alloc]init];
    News *news = [NewsManager shareNewsManager].hotNews[self.adSV.currentPage];
//    News *news =  [NewsManager shareNewsManager].hotNews[self.page.currentPage];
    detVC.newsId = [NSString stringWithFormat:@"%ld",(long)news.Id] ;
    [self presentViewController:detVC animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"yyyyyyyyyyyyyyyyyyy%f", scrollView.contentOffset.y);
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
//         self.view.frame.size.width, self.view.frame.size.height * 0.4;
        CGFloat alpha = (65 + offsetY)/(self.view.frame.size.height * 0.4 - 64);
        NSLog(@"aaaaaaaaaaaaaaaa%f", alpha);
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    if ([NewsManager shareNewsManager].newsDic.count) {
        // 拿到当前显示的cell的indexPath
        NSArray *indexArray = [self.tableView indexPathsForVisibleRows];
        if (indexArray.count) {
            NSIndexPath *indexPath = indexArray.lastObject;
            NSIndexPath *firstIndex = indexArray[0];
            NSDictionary *dic = [NewsManager shareNewsManager].newsDic;
            NSMutableArray *keys = [NewsManager shareNewsManager].date;
            NSString *sectionTitle = keys[firstIndex.section];
            if (![sectionTitle isEqualToString:keys[0]]) {
                self.title = sectionTitle;
            }else  if ([sectionTitle isEqualToString:keys[0]]) {
                self.title = @"今日热闻";
            }
            NSString *str = keys[indexPath.section];
            NSArray *value = dic[str];
            News *news = value[indexPath.row];
            if ([[dic[_date] lastObject] isEqual:news]) {
                [[NewsManager shareNewsManager] getOldNews];
            }
        }
    }
    if (offsetY < -64) {
        self.refresh = YES;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.refresh) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求刷新数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self createHUD];
            [self addToView];
            [self createScrollView];
            self.refresh = NO;
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        [alert addAction:ensure];
        // 添加视图
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self tDataAnalyze];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// 分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"=========%ld", (unsigned long)[NewsManager shareNewsManager].date.count);
    return [[NewsManager shareNewsManager].newsDic allKeys].count;
//    return [NewsManager shareNewsManager].date.count;
}
// 每分区的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = [NewsManager shareNewsManager].newsDic;
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[dic allKeys]];
    [keys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    return [dic[keys[section]] count];
}
// 分区header的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
    aLabel.textAlignment = 1;  // NSTextAlignmentCenter
    aLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    NSArray *keys = [NewsManager shareNewsManager].date;
    if (section > 0 ) {
        aLabel.text =keys[section];
        aLabel.font = [UIFont systemFontOfSize:17 weight:1];
    }
    return aLabel;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 24;
}
// 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [NewsManager shareNewsManager].newsDic;
    NSArray *keys = [NewsManager shareNewsManager].date;
    News *news = dic[keys[indexPath.section]][indexPath.row];
    if (news.type == 1) {
        ImagesLabelTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.news = news;
        return cell;
    }else{
        LabelImageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.news = news;
        return cell;
    }
}
// cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailVC *detVC = [[NewsDetailVC alloc]init];
    News *news = [NewsManager shareNewsManager].newsDic[[NewsManager shareNewsManager].date[indexPath.section]][indexPath.row];
    detVC.newsId = [NSString stringWithFormat:@"%ld",(long)news.Id] ;
    [self presentViewController:detVC animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
