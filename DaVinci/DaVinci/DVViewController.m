//
//  DVViewController.m
//  DaVinci
//
//  Created by 叔 陈 on 16/6/4.
//  Copyright © 2016年 hackbuster. All rights reserved.
//

#import "DVViewController.h"
#import "UIView+ViewFrameGeometry.h"
#import "DVVoiceInputManager.h"

@interface DVViewController () <UIWebViewDelegate>
{
    BOOL isShowingCustomView;
}

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *customView;
@property (strong, nonatomic) UILabel *customViewLabel;

@end

@implementation DVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -50.0f, ScreenWidth, 50.0f)];
    _customView.backgroundColor = self.view.tintColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewTapped:)];
    [_customView addGestureRecognizer:tap];
    
    [self.view addSubview:_customView];
    
    isShowingCustomView = NO;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    
    [self.view addSubview:self.webView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *filePath = [documentpath stringByAppendingString:@"/index.html"] ;
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    self.customViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 25.0f, ScreenWidth, 20.0f)];
    _customViewLabel.font = [UIFont systemFontOfSize:13.0f];
    _customViewLabel.textColor = [UIColor whiteColor];
    _customViewLabel.textAlignment = NSTextAlignmentCenter;
    _customViewLabel.numberOfLines = 0;
    _customViewLabel.userInteractionEnabled = NO;
    [_customView addSubview:_customViewLabel];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    NSLog(@"navigation type %d",navigationType);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self showCustomViewAnimated:YES withTitle:@"Are you fucking kidding me?"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //    [self.progressView setProgress:1 animated:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError? :%@",error.debugDescription);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)reloadWebView
{
    [self.webView reload];
}

- (void)showCustomViewAnimated:(BOOL)animated withTitle:(NSString *)title
{
    if (isShowingCustomView) {
        return;
    }
    
    _customViewLabel.text = title;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    isShowingCustomView = YES;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.customView.top = 0.0f;
        self.webView.top = 50.0f;
        self.webView.height = self.view.height - 50.0f;
    } completion:^(BOOL finished) {
        [self blinkAnimationForTitleLabel];
        //[[DVVoiceInputManager sharedManager] startSpeakText:@"你个贱人"];
        //[[DVVoiceInputManager sharedManager] beginRecording:nil];
    }];
}

- (void)hideCustomViewAnimated:(BOOL)animated
{
    if (!isShowingCustomView) {
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.customView.top = -50.0f;
        self.webView.height = self.view.height;
        self.webView.top = 0.0f;
    } completion:^(BOOL finished) {
        isShowingCustomView = NO;
        [_customViewLabel.layer removeAllAnimations];
    }];
}

- (void)customViewTapped:(UITapGestureRecognizer *)gesture
{
    [self hideCustomViewAnimated:YES];
}

- (void)blinkAnimationForTitleLabel
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CGFloat once_duration = 1.0f;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration=once_duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount=1;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.beginTime = 0.0f;
    
    group.animations = [NSArray arrayWithObjects:animation,nil];
    group.duration= once_duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = HUGE_VALF;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_customViewLabel.layer addAnimation:group forKey:@"fuck"];
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
