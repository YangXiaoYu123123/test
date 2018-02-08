//
//  UILabel+StringFrame.h
//  JZBProject
//
//  Created by jzb_iOS on 15/4/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface UILabel (StringFrame)
/**计算lable size 已弃用*/
- (CGSize)boundingRectWithSize:(CGSize)size;
/**计算lable size 已弃用*/
+ (CGFloat)getLabelHigtWithFontSize:(NSInteger)Font yourWidth:(CGFloat)width youText:(NSString *)text;

/**
 显示当前文字需要几行

 @param width 给定一个宽度
 @return 返回行数
 */
- (NSInteger)needLinesWithWidth:(CGFloat)width;
@end
