//
//  MYCodeView.m
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 16/3/14.
//  Copyright © 2016年 jzb_iOS. All rights reserved.
//

#import "MYCodeView.h"
#import "UIColor+HEX.h"
#import "UIButton+WebCache.h"

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define KMain_Domain @"http://xiaolaoyiguan.com:4011/api"
#define KDeviceID        [[[UIDevice currentDevice] identifierForVendor] UUIDString]

@implementation MYCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}
-(void)initSelf{
    [[NSBundle mainBundle]loadNibNamed:@"MYCodeView" owner:self options:nil];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _pTextField.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    _pTextField.layer.borderWidth = SINGLE_LINE_WIDTH;
    _pCodeButton.layer.borderColor = [UIColor colorWithHexString:@"#dedede"].CGColor;
    _pCodeButton.layer.borderWidth = SINGLE_LINE_WIDTH;
    [self getPcode];
    self.contentView.layer.cornerRadius = 3;
    [_pTextField becomeFirstResponder];
    [self addSubview:self.contentView];
    //不允许AutoresizingMask转换成Autolayout
    //设置左，上，右边距为20.
    [self setEdge:self view:self.contentView attr:NSLayoutAttributeLeft constant:0];
    [self setEdge:self view:self.contentView attr:NSLayoutAttributeTop constant:0];
    [self setEdge:self view:self.contentView attr:NSLayoutAttributeRight constant:0];
    [self setEdge:self view:self.contentView attr:NSLayoutAttributeBottom constant:0];
}
//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr multiplier:1.0 constant:constant]];
}
-(void)getPcode{
    NSString * path = @"pcode";
    NSString * urlStr = [NSString stringWithFormat:@"%@/%@?%@=%@",KMain_Domain,path,@"imei",KDeviceID];
    [[SDImageCache sharedImageCache]removeImageForKey:urlStr fromDisk:YES withCompletion:^{
        
    }];
    //[_pCodeButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal];
    [_pCodeButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHandleCookies|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //[_pCodeButton setImage:image forState:UIControlStateNormal];
    }];
}
- (IBAction)pCodeButtonClick:(UIButton *)sender {
    [self getPcode];
}

@end
