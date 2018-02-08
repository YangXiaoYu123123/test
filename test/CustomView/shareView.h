//
//  shareView.h
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/7/26.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shareView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *grayBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *shareView;
/**构造方法*/
- (instancetype)initWithTitle:(NSString *)title
                      Message:(NSString *)message
                     Channels:(NSArray *)channels
                 ChannelClick:(void(^)(UIButton *button))channelClick
                  CancelTitle:(NSString *)cancelTitle
                  CancelClick:(void(^)(UIButton *button))cancelClick;
@end
