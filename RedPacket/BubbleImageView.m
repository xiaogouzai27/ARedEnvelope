//
//  BubbleImageView.m
//  BubbleAnimationDemo
//


#import "BubbleImageView.h"

@interface BubbleImageView ()

@property (nonatomic, assign)CGFloat maxHeight; //贝塞尔曲线的最大高度
@property (nonatomic, assign)CGFloat maxWidth; //贝塞尔曲线的最大宽度

@property (nonatomic, assign)BubblePathType pathType;

//每一次动画执行的最大高度和最大宽度
@property (nonatomic, assign)CGFloat nowMaxHeight;

@property (nonatomic, assign)CGFloat nowMaxWidth;

@property (nonatomic, assign)CGPoint originPoint;

@property (nonatomic, assign)CGRect originFrame;

//贝塞尔曲线的渲染layer;
//@property (nonatomic, strong)CAShapeLayer *shapeLayer;

@end



@implementation BubbleImageView




- (instancetype)initWithMaxHeight:(CGFloat) maxHeight maxWidth: (CGFloat)maxWidth maxFrame:(CGRect)frame andSuperView: (UIView *)superView andMoney:(NSString *)money
{
    self = [[BubbleImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bubble" ofType:@"png"]]];
    if (self) {
        
        self.originFrame = frame;
        self.frame = [self getRandomFrameWithFrame:frame];
        
        self.originPoint = self.frame.origin;
        [superView insertSubview:self atIndex:0];
        self.maxHeight = maxHeight;
        
        
        self.maxWidth = maxWidth;
        
        self.alpha = [self makeRandomNumberFromMin:0.5 toMax:1];
        
        [self setMoneyLabelWithMoney:money];
        
        [self getRandomBubbleType];
        
        [self getRandomPathWidthAndHeight];
        
        [self setUpBezierPath];
        
    }
    
    return self;
    
}


- (void)setMoneyLabelWithMoney:(NSString *)money{
    double dMoney = [money doubleValue];
    _moneyLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",dMoney];
    _moneyLabel.textColor = [UIColor redColor];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_moneyLabel];
}

//绘制贝塞尔曲线方法
- (void)setUpBezierPath
{
    //开始绘制泡泡的贝塞尔曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:self.originPoint];
    
    
    if (self.pathType == BubblePathTypeLeft) {
        CGPoint leftControllPoint = CGPointMake(self.originPoint.x - self.nowMaxWidth / 2, self.originPoint.y - self.nowMaxHeight / 4);
        CGPoint rightControllPoint = CGPointMake(self.originPoint.x + self.nowMaxWidth / 2, self.originPoint.y - self.nowMaxHeight *3 / 4);
        CGPoint termalPoint = CGPointMake(self.originPoint.x, self.originPoint.y - self.nowMaxHeight);
        
        [bezierPath addCurveToPoint:termalPoint controlPoint1:leftControllPoint controlPoint2:rightControllPoint];
    }else{
        CGPoint leftControllPoint = CGPointMake(self.originPoint.x - self.nowMaxWidth / 2, self.originPoint.y - self.nowMaxHeight * 3 / 4);
        CGPoint rightControllPoint = CGPointMake(self.originPoint.x + self.nowMaxWidth / 2, self.originPoint.y - self.nowMaxHeight / 4);
        CGPoint termalPoint = CGPointMake(self.originPoint.x, self.originPoint.y - self.nowMaxHeight);
        
        
        [bezierPath addCurveToPoint:termalPoint controlPoint1:rightControllPoint controlPoint2:leftControllPoint];
        
    }
    
//    self.shapeLayer = [CAShapeLayer layer];
//    self.shapeLayer .path = bezierPath.CGPath;
//    [self.shapeLayer  setStrokeColor:[UIColor redColor].CGColor];
//    [self.superview.layer addSublayer:self.shapeLayer ];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyFrameAnimation setDuration:2.0];
    keyFrameAnimation.path = bezierPath.CGPath;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate = self;
    [self.layer addAnimation:keyFrameAnimation forKey:@"movingAnimation"];

    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // transform the image to be 1.3 sizes larger to
        // give the impression that it is popping
        [UIView transitionWithView:self
                          duration:0.1f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                        } completion:^(BOOL finished) {
                            if (finished == YES) {
//                                [self.layer removeAllAnimations];
//                                BubbleImageView *bubbleImageView = [[BubbleImageView alloc]initWithMaxHeight:self.maxHeight maxWidth:self.maxWidth maxFrame:self.originFrame andSuperView:self.superview];
                                
                                [self removeFromSuperview];
                            }
                           

                        }];
    }];
    [CATransaction commit];
}

- (void)getRandomBubbleType
{
    if (arc4random() %2 ==1) {
        self.pathType = BubblePathTypeLeft;
    }else{
      self.pathType = BubblePathTypeRight;
    }
}


- (void)getRandomPathWidthAndHeight {
    self.nowMaxHeight = [self makeRandomNumberFromMin:self.maxHeight / 2 toMax:self.maxHeight];
    self.nowMaxWidth = [self makeRandomNumberFromMin:0 toMax:self.maxWidth];
}



- (CGRect)getRandomFrameWithFrame: (CGRect)frame
{
    CGFloat width = [self makeRandomNumberFromMin:40 toMax:self.originFrame.size.width];
    CGRect randomFrame = CGRectMake(frame.origin.x, frame.origin.y, width , width);
    return randomFrame;
}



- (CGFloat)makeRandomNumberFromMin:(CGFloat)min toMax: (CGFloat)max
{
    NSInteger precision = 100;
    
    CGFloat subtraction = ABS(max - min);
    
    subtraction *= precision;
    
    CGFloat randomNumber = arc4random() % ((int)subtraction+1);
    
    randomNumber /= precision;
    
    randomNumber += min;
    
    //返回结果
    return randomNumber;
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
