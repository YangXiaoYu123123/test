//
//  NoInternetView.m
//  JZB_Enterprise
//
//  Created by 马彦飞 on 2017/11/8.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "NoInternetView.h"
#import "Masonry.h"
#import "UIColor+HEX.h"

@interface NoInternetView ()
@property (strong,nonatomic)buttonClick retry;
@end
@implementation NoInternetView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame RetryClick:(buttonClick) retryClick{
    self = [super initWithFrame:frame];
    if (self) {
        if (retryClick) {
            _retry = retryClick;
        }
        [self initSelf];
    }
    return self;
}
- (void)initSelf{
    [[NSBundle mainBundle]loadNibNamed:@"NoInternetView" owner:self options:nil];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _retryButton.layer.cornerRadius = 18;
    _retryButton.layer.borderColor  = [[UIColor colorWithHexString:@"ff6161"]CGColor];
    _retryButton.layer.borderWidth  = 1;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (IBAction)retryButtonClick:(id)sender {
    if (_retry) {
        _retry(sender);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
