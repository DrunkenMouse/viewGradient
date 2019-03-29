//
//  ViewGradient.m
//  签到原型
//
//  Created by 王奥东 on 16/11/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//



//将数值转化为角度
#define DegreesToRadians(_degrees)      ((M_PI * (_degrees))/180)


#import "ViewGradient.h"
#import "UIColor+Color16ToRgb.h"

@implementation ViewGradient {

    //应绘制的圆环百分比
    CGFloat _currentScale;
    //数字值的Label
    NSString  *_numValueStr;
    //详情描述的Label
    NSString *_detailStr;
    //逐渐递增
    CGFloat _restCuont;
    //计时器
    CADisplayLink *_displayLink;
    //圆心
    CGPoint _centerPoint;
    //显示的layer
    CAShapeLayer *_trackLayer;
    //表示图标的按钮
    UIImageView * _iconImgView;
    //圆环的宽度
    CGFloat  _ringWidth;
    //图标的图片名
    NSString *_imgName;
    //小白圆点
    UIImageView *_whilePointImgView;
}

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame currentScale:(CGFloat)scale detailText:(NSString *)detail numValue:(NSString *)num imgName:(NSString *)imgName{
    
    
    if (self = [super initWithFrame:frame]) {
     
        _currentScale = scale; //应绘制的圆环百分比
        
        _restCuont = 0.001;//递增值,通过递增来画圆
        
        _centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);//圆心
        
        _detailStr = detail;//描述信息
        _numValueStr = num;//数值
        _ringWidth = 15.0f;//圆环的宽度
        _imgName = imgName;
        //初始化设置
        [self firstSetup];
        [self firstDraw];
        //开启帧动画
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countDown)];//计时器
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

    }
    return self;
}

#pragma mark - Label的设置
-(void)firstSetup{
    
    
    //背景图片的设置
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(13.5, 13.5, self.bounds.size.width-28.5, self.bounds.size.height-28.5)];
    backImgView.userInteractionEnabled = YES;
    backImgView.image = [UIImage imageNamed:@"greycircle"];
    [self addSubview:backImgView];
    
    //数值Label
    UILabel *numValueLabel = [[UILabel alloc] initWithFrame:(CGRect){CGPointMake(30, self.frame.size.height/2-25),CGSizeMake(self.frame.size.width - 60, 40)}];
    numValueLabel.textAlignment = NSTextAlignmentCenter;//居中
    numValueLabel.font = [UIFont systemFontOfSize:38];
    numValueLabel.textColor = AB_Color_333333;
    numValueLabel.text = _numValueStr;
    
    [self addSubview:numValueLabel];
    
    //详情Label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:(CGRect){CGPointMake(numValueLabel.frame.origin.x, CGRectGetMaxY(numValueLabel.frame)),CGSizeMake(numValueLabel.frame.size.width, 13)}];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont systemFontOfSize:11];
    detailLabel.textColor = AB_Color_999999;
    detailLabel.text = _detailStr;
    numValueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:detailLabel];
    
    //图标位置
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    iconImgView.image = [UIImage imageNamed:_imgName];
    //皇冠的高度减少一半
    if ([_imgName isEqualToString:@"crown"]) {
        CGRect frame = iconImgView.frame;
        frame.size.width = 30;
        frame.size.height = 20;
        iconImgView.frame = frame;
    }
    _iconImgView = iconImgView;
    [self addSubview:_iconImgView];
   
    //添加一个小白点
    UIImageView *whileRingImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-2, 14, 6, 6)];
    whileRingImg.image = [UIImage imageNamed:@"whitePoint"];
    [self addSubview:whileRingImg];
    _whilePointImgView = whileRingImg;
 
    
}

#pragma mark - 定时器执行
-(void)countDown {
    
    [self setNeedsDisplay];
}


#pragma mark - 框架的绘制
-(void)firstDraw{
    //可先设置梯度色后设置圆环
    
    //可变layer
    CAShapeLayer * trackLayer = [CAShapeLayer layer];
    _trackLayer = trackLayer;
    //设置修改范围
    trackLayer.frame = self.bounds;
    
    [self.layer addSublayer:trackLayer];
    
    //layer填充色，不会修改view的背景色
    trackLayer.fillColor = [[UIColor clearColor] CGColor];
    //边框色
    trackLayer.strokeColor = [[UIColor redColor] CGColor];
    //不透明度
    trackLayer.opacity = 0.8;
    //路径线条交界处为图形的形状
    trackLayer.lineCap = kCALineCapRound;
    // 彩色的边框宽度
    trackLayer.lineWidth = _ringWidth;
    
    //贝兹路径画圆,若要修改，需要连同帧动画里的一块改
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:self.bounds.size.width/2-trackLayer.lineWidth-5 startAngle:DegreesToRadians(270) endAngle:DegreesToRadians(270+_restCuont*360) clockwise:YES];
    
    
    //角度是从 -210到30度，具体可以看如下图所示
    trackLayer.path = [path CGPath];
    
    //可变颜色的Layer
    CALayer * gradinetLayer = [CALayer layer];
    //颜色梯度
    CAGradientLayer * gradLayer1 = [CAGradientLayer layer];
    
    gradLayer1.frame = CGRectMake(0, 0, self.frame.size.width/2, self.bounds.size.height);
    
    //设置梯度颜色
    //colorWithHexString:@"0xfde802"
   
    [gradLayer1 setColors:[NSArray arrayWithObjects:(id)[AB_Color_ff3600 CGColor],(id)[AB_Color_f7ef32 CGColor], nil]];
    /**
     一个可选的NSNumber对象数组，定义每个对象的位置梯度停止作为范围,需是[0,1]中的值。 值必须为单调增加。 如果给出一个nil数组，则停止是假设在[0,1]范围内均匀分布。 当呈现时，在颜色被映射到输出颜色空间之前插值。 默认为nil。
     */
    //越大越接近第一个颜色
    [gradLayer1 setLocations:@[@0.3,@0.8]];
    
    //开始点
    /**
     渐变绘制到图层时的起点和终点坐标空间。 起始点对应于第一梯度停止，终点到最后一个梯度停止。 两点都是在一个单位坐标空间中定义，然后映射到*图层的边界矩形。 （即[0,0]是左下角层的角，[1,1]是右上角。）默认值分别是[.5,0]和[.5,1]。 两者都是动画。
     */
    [gradLayer1 setStartPoint:CGPointMake(0.5, 0)];
    
    //结束点
    [gradLayer1 setEndPoint:CGPointMake(0.5, 1)];
    
    //添加梯度
    [gradinetLayer addSublayer:gradLayer1];
    
    
    //梯度2
    CAGradientLayer * gradLayer2 = [CAGradientLayer layer];
    
    gradLayer2.frame = CGRectMake(self.frame.size.width/2-10, 0, self.frame.size.width/2, self.bounds.size.height);
    //梯度颜色
    [gradLayer2 setColors:[NSArray arrayWithObjects:(id)AB_Color_3ac1a2.CGColor,(id)[AB_Color_f7ef32 CGColor], nil]];
    //开始点
    [gradLayer2 setStartPoint:CGPointMake(0.5, 0)];
    //结束点
    [gradLayer2 setEndPoint:CGPointMake(0.5, 1)];
    //添加layer
    [gradinetLayer addSublayer:gradLayer2];
    
    
    //截取超出圆环的部分
    [gradinetLayer setMask:trackLayer];
    
    //添加梯度
    [self.layer addSublayer:gradinetLayer];
    
 
}

#pragma mark - 定时器绘制圆
- (void)drawRect:(CGRect)rect {
   
   
     [self addSubview:_whilePointImgView];
    if (_restCuont <= _currentScale) {
        _restCuont+=0.025;
    }else {
        
        [_displayLink invalidate];
        _displayLink = nil;
        [self addSubview:_iconImgView];
        
        if (_currentScale>0.96f) {
            if (_iconImgView) {
                [_iconImgView removeFromSuperview];
                _iconImgView = nil;
            }
           
            CGPoint centerPoint = CGPointMake(self.bounds.size.width/2-_ringWidth/2, 20);
            //图标位置
            UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            iconImgView.image = [UIImage imageNamed:_imgName];
            //皇冠的高度减少一半
            if ([_imgName isEqualToString:@"crown"]) {
                CGRect frame = iconImgView.frame;
                frame.size.width = 30;
                frame.size.height = 20;
                iconImgView.frame = frame;
            }
            iconImgView.frame = CGRectMake(centerPoint.x-(iconImgView.frame.size.width/2), centerPoint.y-(iconImgView.frame.size.height/2), iconImgView.frame.size.width, iconImgView.frame.size.height);
            
            _iconImgView = iconImgView;
            
            [self addSubview:_iconImgView];
            [self bringSubviewToFront:_iconImgView];
            return;
        }

    }

    //贝兹路径画圆
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:self.bounds.size.width/2-_trackLayer.lineWidth-5 startAngle:DegreesToRadians(270) endAngle:DegreesToRadians(270+_restCuont*360) clockwise:YES];
    
    //获取坐标点所在象限
    //此时的度数
    CGFloat Angle = DegreesToRadians(_restCuont*360);
    //半径
    CGFloat radius = self.bounds.size.width/2 - 5.f;
    //获取角度所在象限，
    int index = Angle / M_PI_2;
    //需要计算的角度
    CGFloat needAngle = Angle - index * M_PI_2;
    //偏移量
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
    
    
    //x,y坐标
    CGFloat xPoint;
    CGFloat yPoint;
  
    
    switch (index) {
        case 0:
            //第一象限
            //需要切换角度
            needAngle = M_PI_2 - Angle;
            //需要减去圆环的一半
            //圆环的起点往左处有所偏移方能显示出半圆弧，因此需要增加x
            if (_currentScale < 0.015) {
               xPoint = (radius) + cosf(needAngle)*((radius+5)-_ringWidth);
            }else {
                xPoint = (radius) + cosf(needAngle)*((radius)-_ringWidth);
            }
            
            yPoint = self.bounds.size.height/2 - fabs(sinf(needAngle)*(radius-_ringWidth/2));
            
            break;
         
        case 1:
            //第二象限
            //需要减去圆环的一半
            
            xPoint = (radius) + cosf(needAngle)*(radius-_ringWidth);
            yPoint = (radius) + sinf(needAngle)*((radius-5)-_ringWidth);
           
            break;
        case 2:
            //第三象限
            //需要减去圆环的一半
            //需要切换角度
            xPoint = radius - cosf(M_PI_2 - needAngle)*(radius-_ringWidth);
            yPoint = radius + sinf(M_PI_2 - needAngle)*((radius-5)-_ringWidth);
       
            break;
        case 3:
            //第四象限
            xPoint = radius - cosf(needAngle)*(radius-_ringWidth);
            yPoint = radius - sinf(needAngle)*(radius-_ringWidth/2);
            
            break;
            
    }
    
    //用于判断恰好在坐标轴上的点
    NSString *xString = [NSString stringWithFormat:@"%.3f",xPoint];
    NSString *yString = [NSString stringWithFormat:@"%.3f",yPoint];
    
    
    
    //只有第四象限的坐标点会出现X/Y都小于5.f,此时接近360°
    if ([xString doubleValue]<5.f && [yString doubleValue]<5.f) {
        xPoint = 0;
        xOffset = radius;
        yOffset = 15;
    }  else if ([xString doubleValue]<0||[yString doubleValue]<0){//5S出现为负情况
        xOffset = radius;
        yOffset = 15;
    }   else if (([xString doubleValue] >=  radius+radius/2) && [yString doubleValue]<20) {//真机出现右上角的情况
        xPoint = 0;
        xOffset = radius;
        yPoint = 12;
    } else if (([xString doubleValue] < radius/2) && [yString doubleValue]<20) {//真机出现左上角的情况
        xPoint = 0;
        xOffset = radius;
        yPoint = 12;
    }
    //圆环离四周距离为5
    xOffset += 5;
    yOffset += 5;
    //设置按钮的中心点
    CGPoint centerPoint = CGPointMake(xPoint + xOffset, yPoint + yOffset);
    
    _iconImgView.center = centerPoint;
    
    
    
    //画出路径
    _trackLayer.path = [path CGPath];
    
   
}


@end
