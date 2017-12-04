//
//  MainViewController.m
//  HealthBeijing
//
//  Created by  on 2017/12/1.
//  Copyright © 2017年 XMYTX. All rights reserved.
//

#import "MainViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MainViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)UIProgressView *progressView;
@property (nonatomic, assign) CGFloat plusWidth;  // 进度条每次增加的长度
@property(nonatomic,strong)NSTimer *timer;
@end
#define DEFAULT [NSUserDefaults standardUserDefaults]
#define TOKEN @"token"
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor whiteColor];
    self.urlStr=@"https://www.baidu.com";
    self.webView=[[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.delegate=self;
    self.webView.backgroundColor=[UIColor clearColor];
    NSURLRequest *urlReq=[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:urlReq];
    [self.view addSubview:self.webView];
    
    self.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 1)];
    self.progressView.trackTintColor=[UIColor whiteColor];
    self.progressView.progressTintColor=[UIColor greenColor];
    self.progressView.progress=0;
    _plusWidth = 0.005;
    [self.view addSubview:self.progressView];
   
    
}

//返回首页
-(void)backHome:(int )type
{
    
}
//定时器
- (void)timerAction:(NSTimer *)timer
{
    self.progressView.progress += _plusWidth;
    
    if (self.progressView.progress > 0.60) {
        _plusWidth = 0.002;
    }
    
    if (self.progressView.progress > 0.85) {
        _plusWidth = 0.0007;
    }
    
    if (self.progressView.progress > 0.90) {
        _plusWidth = 0;
    }
}
- (NSTimer *)timer
{
    if (!_timer) {
       _timer=[NSTimer scheduledTimerWithTimeInterval:0.03
                                         target:self
                                       selector:@selector(timerAction:)
                                       userInfo:self.progressView
                                        repeats:YES];
    }
    return _timer;
}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    NSLog(@"开始加载");
    [self timer];//启动定时器
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSLog(@"加载完成");
    [self.progressView setProgress:1 animated:NO];
    [self timerInvalue];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.2f];

//oc调用js
 
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        NSString *alertJS = @"alert('Hello JS!')"; //准备执行的JS代码
        // 通过evaluateScript:方法调用JS的alert
       // [context evaluateScript:alertJS];
    [context evaluateScript:@"var arr = [3, 4, 'abc'];"];

//js调用oc
    context[@"appLogin"] = ^() {
      NSArray *args = [JSContext currentArguments];
        for (int i=0; i<args.count; i++) {
            NSString *orderNo = [args[i] toString];
            NSLog(@"获取数据%@",orderNo);
            
        }
        // 调登录保存数据
        NSLog(@"我调oc");
       
    };
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    NSLog(@"错误信息%@",error);
    [self timerInvalue];
    self.progressView.hidden=YES;

    
}
-(void)delayMethod
{
    self.progressView.hidden=YES;
}
- (void)timerInvalue
{
    [_timer invalidate];
    _timer  = nil;
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
