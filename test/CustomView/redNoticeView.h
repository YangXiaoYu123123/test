//
//  redNoticeView.h
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/6/2.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface redNoticeView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *VMoneyLabel;
@property (strong,nonatomic)void(^checkButtonClick)(UIButton * button);
/**构造方法*/
- (instancetype)initWithFrame:(CGRect)frame WithMoney:(float)money;
@end
