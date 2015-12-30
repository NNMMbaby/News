//
//  DetailTVC.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/23.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "DetailTVC.h"
#import "NewsManager.h"
#import "ImagesLabelTVCell.h"
#import "LabelImageTVCell.h"
#import "NewsDetailVC.h"

@interface DetailTVC () <NewsManagerDelegate>

@property (nonatomic, strong) NSMutableArray *array;
// 放小菊花的view
@property (nonatomic, retain) UIView *backgroundView;
// 系统小菊花
@property (nonatomic, retain) UIActivityIndicatorView *act;
//  系统菊花label
@property (nonatomic, retain) UILabel *actLab;

@end

@implementation DetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [NewsManager shareNewsManager].delegate = self;
    NSLog(@"%@++++++++++++++%@", self.type, self.Id);
    [self request];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"LabelImageTVCell" bundle:nil]  forCellReuseIdentifier:@"detailCell1"];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ImagesLabelTVCell" bundle:nil]  forCellReuseIdentifier:@"detailCell2"];
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
    [_act stopAnimating];
    [_backgroundView removeFromSuperview];
}

-(void) addToView{
    [_act startAnimating];
    [self.view addSubview:_backgroundView];
}


-(void)request{
    if ([self.type isEqualToString:@"Theme"]) {
        [[NewsManager shareNewsManager] getThemeDetail:self.Id];
    }else if ([self.type isEqualToString:@"Section"]){
        [[NewsManager shareNewsManager] getSectionDetail:self.Id];
    }
}
-(void)failRequest{
    [self removeAct];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示：请查看网络是否连接" message:@"网络请求失败，请再次请求" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self request];
    }];
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:back];
    [alert addAction:ensure];
    // 添加视图
    [self presentViewController:alert animated:YES completion:nil];
}
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

-(void)reloadWith:(NSString *)image Name:(NSString *)name stories:(NSArray *)news{
    UIImageView *img = [[UIImageView alloc]init];
    [img sd_setImageWithURL:[NSURL URLWithString:image]];
    [self.navigationController.navigationBar setBackgroundImage:img.image forBarMetrics:UIBarMetricsDefault];
    self.title = name;
    [self.array addObjectsFromArray:news];
//    NSLog(@"!!!!!!!!%ld", self.array.count);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.array.count) {
        [self removeAct];
    }
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    News *news = [News new];
    if (indexPath.row < self.array.count) {
        news = self.array[indexPath.row];
    }
    if (news.type == 1) {
        ImagesLabelTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell2" forIndexPath:indexPath];
        cell.news = news;
        return cell;
    }else{
        LabelImageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell1" forIndexPath:indexPath];
        cell.news = news;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailVC *detVC = [[NewsDetailVC alloc]init];
    News *news = self.array[indexPath.row];
    detVC.newsId = [NSString stringWithFormat:@"%ld",(long)news.Id] ;
    detVC.newsArray = self.array;
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
