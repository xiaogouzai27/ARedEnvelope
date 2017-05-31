//
//  BubbleImageView.h
//  BubbleAnimationDemo
//


#import <UIKit/UIKit.h>


//UIButtonType
typedef  NS_ENUM(NSInteger, BubblePathType) {
    BubblePathTypeLeft = 0,     //贝塞尔曲线,先向左弯曲;
    BubblePathTypeRight,   //贝塞尔曲线,先向右弯曲;
};




@interface BubbleImageView : UIImageView

- (instancetype)initWithMaxHeight:(CGFloat) maxHeight maxWidth: (CGFloat)maxWidth maxFrame:(CGRect)frame andSuperView: (UIView *)superView andMoney:(NSString *)money;

@property (nonatomic,strong) UILabel * moneyLabel;

@end
