//
//  MYCodeView.h
//  jZB_iOS2.0
//
//  Created by jzb_iOS on 16/3/14.
//  Copyright © 2016年 jzb_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYCodeView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *pTextField;
@property (weak, nonatomic) IBOutlet UIButton *pCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end
