//
//  shareView.m
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/7/26.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "shareView.h"
#import "Masonry.h"
#import "NSString+URL.h"

@interface shareView ()
@property (strong,nonatomic)void(^currentChannelClick)(UIButton *button);
@property (strong,nonatomic)void(^cancelClick)(UIButton *button);
@end
@implementation shareView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}
/**构造方法*/
- (instancetype)initWithTitle:(NSString *)title
                      Message:(NSString *)message
                     Channels:(NSArray *)channels
                 ChannelClick:(void(^)(UIButton *button))channelClick
                  CancelTitle:(NSString *)cancelTitle
                  CancelClick:(void(^)(UIButton *button))cancelClick{
    self = [super init];
    if (self) {
        [self initSelf];
        if (message.length){
            NSString * finalString = [NSString stringWithFormat:@"%@\n\n%@",title,message];
            _titleLabel.attributedText = [finalString changString:message Font:[UIFont systemFontOfSize:13]];
        }
        else{
            _titleLabel.text = title;
        }
        [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        _currentChannelClick = channelClick;
        _cancelClick = cancelClick;
        NSInteger rowCount = 4;//每一排的数量
        CGFloat channelWith = ([UIScreen mainScreen].bounds.size.width - 80)/rowCount;
        UIButton * tmpButton;
        for (int i = 0; i < channels.count; i ++) {
            NSDictionary * info = channels[i];
            NSString * imageName = info[@"image"];
            UIButton * button = [[UIButton alloc]init];
            button.tag = i ;
            if (imageName) {
                [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(channelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_shareView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i %4 == 0) {
                    make.left.equalTo(0);
                    if (i == 0) {
                        make.top.equalTo(0);
                    }
                    else{
                        make.top.equalTo(tmpButton.mas_bottom);
                    }
                }
                else{
                    make.left.equalTo(tmpButton.mas_right);
                    make.topMargin.equalTo(tmpButton);
                }
                make.size.mas_equalTo(CGSizeMake(channelWith, channelWith));
            }];
            tmpButton = button;
        }
        if (tmpButton) {
            [tmpButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(0);
            }];
        }
    }
    return self;
}
- (void)initSelf{
    [[NSBundle mainBundle]loadNibNamed:@"shareView" owner:self options:nil];
    self.grayBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark ---------------- 点击事件
/**分享渠道按钮点击*/
- (void)channelButtonClick:(UIButton *)button{
    if (_currentChannelClick) {
        _currentChannelClick(button);
    }
    [self removeFromSuperview];
}
/**取消按钮点击*/
- (IBAction)cancelButtonClick:(id)sender {
    if (_cancelClick) {
        _cancelClick(sender);
    }
    [self removeFromSuperview];
}
/**背景点击*/
- (IBAction)bg:(id)sender {
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
