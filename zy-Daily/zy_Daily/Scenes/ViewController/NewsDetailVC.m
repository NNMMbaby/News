//
//  NewsDetailVC.m
//  zy_Daily
//
//  Created by 李艳楠 on 15/11/18.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "NewsDetailVC.h"
#import "News.h"
#import "AppDelegate.h"
#import "NewsManager.h"
#import "HomePageTC.h"
#import "Theme.h"

@interface NewsDetailVC () <UIWebViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIWebView *bodyWV;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *imgSourceLab;

// 放小菊花的view
@property (nonatomic, retain) UIView *backgroundView;
// 系统小菊花
@property (nonatomic, retain) UIActivityIndicatorView *act;
//  系统菊花label
@property (nonatomic, retain) UILabel *actLab;

// 页面是否需要刷新
@property (assign, nonatomic) BOOL refresh;

@end

@implementation NewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bodyWV.delegate = self;
    self.myScrollView.delegate = self;
    self.bodyWV.scrollView.scrollEnabled = NO;
    self.refresh = NO;
    [self oDataAnalyzeWihthId:self.newsId];
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

-(void)oDataAnalyzeWihthId:(NSString *)newsId{
    self.myScrollView.contentOffset = CGPointMake(0, 0);
    [self createAct];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 实际返回文本是HTML格式的,但是数据是json格式的
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"%@", self.newsId);
    NSString *url = [NSString stringWithFormat:@"%@%@", kDownloadUrl, newsId];
    NSLog(@"%@", url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功了");
        News *news = [News new];
        [news setValuesForKeysWithDictionary:responseObject];
        NSLog(@"%@", news);
        if (news.image) {
            [self.img sd_setImageWithURL:[NSURL URLWithString: news.image]];
        }
        self.titleLab.text = news.title;
        self.titleLab.textColor = [UIColor whiteColor];
        self.imgSourceLab.text = news.image_source;
        [self.bodyWV loadHTMLString:news.body baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"------------失败了");
        [self removeAct];
    }];
}

#pragma mark --- 点击事件
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)next:(UIButton *)sender {
    if (self.newsArray.count){
        for (int i = 0; i < self.newsArray.count - 1; i ++) {
            if ([self.newsId integerValue] == [self.newsArray.lastObject Id]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这是最后一篇文章哦~~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:ensure];
                // 添加视图
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }else if ([_newsArray[i] Id] == [self.newsId integerValue]) {
                if ([_newsArray[i + 1] Id]) {
                    self.newsId = [NSString stringWithFormat:@"%ld", [_newsArray[i + 1] Id]];
                    [self oDataAnalyzeWihthId:self.newsId];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求失败::>.<::" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:ensure];
                    // 添加视图
                    [self presentViewController:alert animated:YES completion:nil];
                }
                break;
            }
        }
    }else{
        if ([[NewsManager shareNewsManager] getNextNewsIdWithId:self.newsId] != nil) {
            self.newsId = [[NewsManager shareNewsManager] getNextNewsIdWithId:self.newsId];
            [self oDataAnalyzeWihthId:self.newsId];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求失败::>.<::" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:ensure];
            // 添加视图
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
- (IBAction)up:(UIButton *)sender {
    if (self.newsArray.count) {
        for (int i = 0; i < self.newsArray.count; i ++) {
            if ([self.newsId integerValue] == [self.newsArray[0] Id]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"这是第一篇文章哦~~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:ensure];
                // 添加视图
                [self presentViewController:alert animated:YES completion:nil];
                break;
            }else if ([_newsArray[i] Id] == [self.newsId integerValue]) {
                if ([_newsArray[i - 1] Id]) {
                    self.newsId = [NSString stringWithFormat:@"%ld", [_newsArray[i - 1] Id]];
                    [self oDataAnalyzeWihthId:self.newsId];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求失败::>.<::" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:ensure];
                    // 添加视图
                    [self presentViewController:alert animated:YES completion:nil];
                }
                break;
            }
        }
    }else {
        if ([[NewsManager shareNewsManager] getPreNewsIdWithId:self.newsId] != nil) {
            if ([[[NewsManager shareNewsManager] getPreNewsIdWithId:self.newsId] isEqualToString:@"first"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是第一篇文章了~~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:ensure];
                // 添加视图
                [self presentViewController:alert animated:YES completion:nil];
            }else {
                NSString *str = [[NewsManager shareNewsManager] getPreNewsIdWithId:self.newsId];
                self.newsId = str;
                [self oDataAnalyzeWihthId:self.newsId];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= scrollView.frame.size.height * 0.48) {
        self.bodyWV.scrollView.scrollEnabled = YES;
     }else {
        self.bodyWV.scrollView.scrollEnabled = NO;
     }
}

// 取消当前页面所有点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        static int i = 0;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求打开链接" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            i ++;
        }];
        [alert addAction:ensure];
        // 添加视图
        [self presentViewController:alert animated:YES completion:nil];
        if (i == 1) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat width = self.bodyWV.frame.size.width;
    // 修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = %f;" //缩放系数
     "for(i=0;i < document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth) + 90;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);", width - 10]];

    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    NSLog(@"zouha");
    [self removeAct];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"zou");
}

-(UIWebView *)bodyWV{
    if (!_bodyWV) {
        _bodyWV = [[UIWebView alloc]init];
    }
    return _bodyWV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
