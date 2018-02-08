//
//  MYInsertTextField.m
//  jZB_iOS2.0
//
//  Created by 马彦飞 on 2017/2/17.
//  Copyright © 2017年 jzb_iOS. All rights reserved.
//

#import "MYInsertTextField.h"

@implementation MYInsertTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}
@end
