//
//  redNoticeView.m
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/6/2.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "redNoticeView.h"
#import "Masonry.h"

@implementation redNoticeView
- (instancetype)initWithFrame:(CGRect)frame WithMoney:(float)money{
    self = [super initWithFrame:frame];
    if (self) {
        _VMoneyLabel.text = [NSString stringWithFormat:@"%.0f",money];
        [self initSelf];
    }
    return self;
}
- (void)initSelf{
    [[NSBundle mainBundle]loadNibNamed:@"redNoticeView" owner:self options:nil];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}
/**关闭按钮点击*/
- (IBAction)closeButton:(UIButton *)sender {
    [self removeFromSuperview];
}
/**查看按钮点击*/
- (IBAction)checkButtonClick:(UIButton *)sender {
    if (_checkButtonClick) {
        _checkButtonClick(sender);
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
