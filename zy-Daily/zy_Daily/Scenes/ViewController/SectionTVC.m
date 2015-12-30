//
//  SectionTVC.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/23.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "SectionTVC.h"
#import "NewsManager.h"
#import "Theme.h"
#import "ImagesLabelTVCell.h"
#import "DetailTVC.h"

@interface SectionTVC () <NewsManagerDelegate>

@property (nonatomic, strong) NSMutableArray *themes;
// 放小菊花的view
@property (nonatomic, retain) UIView *backgroundView;
// 系统小菊花
@property (nonatomic, retain) UIActivityIndicatorView *act;
//  系统菊花label
@property (nonatomic, retain) UILabel *actLab;

@end

@implementation SectionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ImagesLabelTVCell" bundle:nil]  forCellReuseIdentifier:@"Cell4"];
    [NewsManager shareNewsManager].delegate = self;
    [[NewsManager shareNewsManager] getSections];
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

-(void)reload{
    self.themes = [NewsManager shareNewsManager].section8;
    [self.tableView reloadData];
}
-(void)failRequest{
    [self removeAct];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示：请查看网络是否连接" message:@"网络请求失败，请再次请求" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NewsManager shareNewsManager] getSections];
    }];
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:back];
    [alert addAction:ensure];
    // 添加视图
    [self presentViewController:alert animated:YES completion:nil];
}
-(NSMutableArray *)themes{
    if (!_themes) {
        _themes = [NSMutableArray array];
    }
    return _themes;
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
    if (self.themes.count) {
        [self removeAct];
    }
    return self.themes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagesLabelTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
    Theme *theme = self.themes[indexPath.row];
    cell.theme = theme;
    NSLog(@"%@", theme.thumbnail);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Theme *theme = self.themes[indexPath.row];
    DetailTVC *detail = [[DetailTVC alloc]init];
    detail.Id = [NSString stringWithFormat:@"%ld" ,theme.Id];
    detail.type = @"Section";
    [self.navigationController pushViewController:detail animated:YES];
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
