//
//  ViewGradient.h
//  签到原型
//
//  Created by 王奥东 on 16/11/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//  首页下方的圆环图

#import <UIKit/UIKit.h>

@interface ViewGradient : UIView
-(instancetype)initWithFrame:(CGRect)frame currentScale:(CGFloat)scale detailText:(NSString *)detail numValue:(NSString *)num imgName:(NSString *)imgName;
@end
