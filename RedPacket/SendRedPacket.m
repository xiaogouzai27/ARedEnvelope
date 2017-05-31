//
//  SendRedPacket.m
//  RedPacket
//


#import "SendRedPacket.h"
#import "AlertView.h"

#define NUMBER_REGEX @"^[0-9]*[1-9][0-9]*$"
#define kPointString              @"."

@interface SendRedPacket ()<UITextFieldDelegate>

{
    UITextField * _moenyField;
    UITextField * _numberField;
    UILabel     * _titleLabel;
    UIButton    * _sendButton;
}

@end

@implementation SendRedPacket

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.center = CGPointMake( K_WIDTH/2.0, K_HEIGHT/2.0);
    
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor redColor];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, K_SNEDWIDTH, 20)];
    _titleLabel.text = @"请输入红包金额&个数";
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _moenyField = [[UITextField alloc] initWithFrame:_titleLabel.frame];
    _moenyField.center = CGPointMake(_moenyField.center.x, CGRectGetMaxY(_titleLabel.frame)+30);
    _moenyField.placeholder = @"请输入金额";
    _moenyField.delegate = self;
    _moenyField.textAlignment=NSTextAlignmentCenter;
    _moenyField.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:_moenyField];
    
    _numberField = [[UITextField alloc] initWithFrame:_titleLabel.frame];
    _numberField.center = CGPointMake(_moenyField.center.x, CGRectGetMaxY(_moenyField.frame)+30);
    _numberField.placeholder = @"请输入红包个数";
    _numberField.delegate = self;
    _numberField.textAlignment=NSTextAlignmentCenter;
    _numberField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_numberField];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(0, 0, 100, 25);
    _sendButton.center = CGPointMake(CGRectGetMidX(_numberField.frame), K_SNEDHEIGHT-60);
    _sendButton.layer.cornerRadius = 5.0;
    _sendButton.layer.masksToBounds = true;
    _sendButton.backgroundColor = [UIColor orangeColor];
    [_sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [self addSubview:_sendButton];

}

- (void)showOnView:(UIView *)vc{
    [vc addSubview:self];
}

- (void)hidden{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform=CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate sendMoney:_moenyField.text andRedPacketNum:_numberField.text];
    }];
}

- (void)send{
    
    [self endEditing:YES];
    
    //警告类型
    
    /**
     *   提示 单个红包金额不可超过200元
     */
    //1.输入总金额为 1W
    //2.输入总金额为 2K ，红包个数为 1
    //3.输入总金额为 1K ，红包个数为 1
    
    /**
     *   提示 单个红包金额不可低于0.01元,请重新填写金额
     */
    //输入总金额为 0.01 ， 红包个数为 5
    //输入总金额为 0.5 ， 红包个数为 60
    
    
    /**
     *   提示 一次最多发100个红包
     */
    //输入总金额为 1 ， 红包个数为 120
    
    if ([self isNumberOnly:_numberField.text])
    {
        [AlertView showWithTips:@"请输入正确红包个数"];
        return;
    }
    if ([_moenyField.text doubleValue] < 0.01)
    {
        [AlertView showWithTips:@"单个红包金额不能低于0.01元，请重新填写金额"];
        return;
    }
    if ([_numberField.text integerValue] > [_moenyField.text doubleValue] * 100) {
        [AlertView showWithTips:@"单个红包金额不能低于0.01元，请重新填写金额"];
        return;
    }
    if ([_numberField.text integerValue] * 200 < [_moenyField.text doubleValue]) {
        [AlertView showWithTips:@"单个红包金额不能高于200元"];
        return;
    }
    
    if ([_numberField.text intValue] > 100) {
        [AlertView showWithTips:@"一次最多只能发100个红包"];
        return;
    }
    
    [self hidden];
}


-(BOOL)isNumberOnly:(NSString *)str{
    return [self string:str reg:NUMBER_REGEX];
    
}

-(BOOL)string:(NSString *)str reg:(NSString *)reg{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger test = [regex numberOfMatchesInString:str options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [str length])];
    if ([str integerValue]==0) {
        return YES;
    }
    return test==0?YES:NO;
    
}

#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length == 1 && [textField.text isEqualToString:@"."]) {
        textField.text = @"0.";
    }
    // 限制小数点后2位
    const NSInteger limited = 2;
    NSRange pointRange = [textField.text rangeOfString:kPointString];
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    // 判断输入框内是否含有@"."
    if (pointRange.length > 0 && pointRange.location > 0) {
        // 当输入框已经含有@"."时，再次输入时，视为无效
        if ([string isEqualToString:kPointString]) {
            return NO;
        }
        if (strlen > 0 && (strlen - pointRange.location) > limited + 1) {
            return NO;
        }
    }
    return YES;
}

@end
