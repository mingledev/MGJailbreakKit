//
//  MGControlCenterHUD.m
//  MGJailbreakKit
//
//  Created by Mingle on 2020/3/7.
//  Copyright © 2020 Mingle. All rights reserved.
//

#import "MGControlCenterHUD.h"
#import "MGControlCenterView.h"

@interface MGControlCenterHUD ()

@property (strong, nonatomic) MGControlCenterView *contentView;
@property (assign, nonatomic) CGPoint beganPoint;

@end

@implementation MGControlCenterHUD

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MGControlCenterHUD *cc;
    dispatch_once(&onceToken, ^{
        cc = [MGControlCenterHUD buttonWithType:UIButtonTypeCustom];
        [cc setupView];
    });
    return cc;
}

+ (void)show {
    if ([[self sharedInstance] superview]) {
        [[self sharedInstance] setAlpha:0.4];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].windows.firstObject addSubview:[self sharedInstance]];
        });
    }
}

+ (void)hide {
    [[self sharedInstance] setAlpha:0];
}

- (void)setupView {
    self.alpha = 0.4;
    self.backgroundColor = UIColor.blackColor;
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 3.0, 50, 50);
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.clipsToBounds = YES;
    [self setTitle:@"ggydm-" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self addTarget:self action:@selector(showContent) forControlEvents:UIControlEventTouchUpInside];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)]];
    
    _contentView = [[MGControlCenterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)showContent {
    [MGControlCenterHUD hide];
    _contentView.frame = self.frame;
    _contentView.alpha = 0;
    [[UIApplication sharedApplication].windows.firstObject addSubview:_contentView];
    _contentView.closeCallback = ^{
        [MGControlCenterHUD show];
    };
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.alpha = 0.7;
        self.contentView.frame = [UIScreen mainScreen].bounds;
    }];
}

- (void)panHandle:(UIPanGestureRecognizer *)sender {
    CGPoint btnPt = [sender translationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        _beganPoint = self.frame.origin;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.frame = CGRectMake(_beganPoint.x + btnPt.x, _beganPoint.y + btnPt.y, self.frame.size.width, self.frame.size.height);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint resetOrigin = self.frame.origin;
        if (self.frame.origin.y < [[UIApplication sharedApplication] statusBarFrame].size.height) {
            resetOrigin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
        } else if (self.frame.origin.y + self.frame.size.height > [UIScreen mainScreen].bounds.size.height) {
            resetOrigin.y = [UIScreen mainScreen].bounds.size.height - self.frame.size.height;
        }
        if (self.center.x < [UIScreen mainScreen].bounds.size.width / 2) {
            resetOrigin.x = 0;
        } else if (self.frame.origin.x > [UIScreen mainScreen].bounds.size.width / 2) {
            resetOrigin.x = [UIScreen mainScreen].bounds.size.width - self.frame.size.width;
        }
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = CGRectMake(resetOrigin.x, resetOrigin.y, self.frame.size.width, self.frame.size.height);
        }];
    }
}

+ (void)setControlCenterItems:(NSArray<MGControlCenterItem *> *)items {
    MGControlCenterHUD *hud = [MGControlCenterHUD sharedInstance];
    [hud.contentView setControlItems:items];
}

+ (void)setMessage:(NSString *)msg {
    MGControlCenterHUD *hud = [MGControlCenterHUD sharedInstance];
    [hud.contentView setMsg:msg];
}

+ (void)setDidLanchCallback:(void (^)(void))block {
    MGControlCenterHUD *hud = [MGControlCenterHUD sharedInstance];
    [hud.contentView setLaunchCallback:block];
}

+ (void)setCloseCallback:(void (^)(void))block {
    MGControlCenterHUD *hud = [MGControlCenterHUD sharedInstance];
    [hud.contentView setCloseCallback:block];
}

@end
