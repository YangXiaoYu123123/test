//
//  WelcomeView.h
//  JieXinIphone
//
//  Created by liqiang on 14-5-29.
//  Copyright (c) 2014年 sunboxsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HideWelcomeDelegate

- (void)hideWelcomeView;

@end

@interface WelcomeView : UIView

@property (nonatomic, assign) id <HideWelcomeDelegate> delegate;

@end
