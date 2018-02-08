//
//  NoInternetView.h
//  JZB_Enterprise
//
//  Created by 马彦飞 on 2017/11/8.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonClick)(UIButton * button);
@interface NoInternetView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
- (instancetype)initWithFrame:(CGRect)frame RetryClick:(buttonClick) retryClick;
@end
