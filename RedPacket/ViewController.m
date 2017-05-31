//
//  ViewController.m
//  RedPacket
//



#import "ViewController.h"
#import "SendRedPacket.h"
#import "RedPacketManager.h"
#import "AlertView.h"
#import "BubbleImageView.h"

@interface ViewController () <SendRedPacketDeleagte>

{
    SendRedPacket * _sendView;
    UIView        * _showSendView;
    NSTimer       * _myTimer;
    BOOL            isBig;
    
    BOOL            isSend;
    
    UILabel       * _residueMoneyLabel;     //剩余钱
    UILabel       * _residueNumberLabel;    //剩余红包个数
    double          allMoney;
    int             allNumber;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configUI];
    [self configResidueInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI{
    float R = 100.0;
    _showSendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100.0, 100.0)];
    _showSendView.layer.cornerRadius = R/2.0;
    _showSendView.layer.masksToBounds = true;
    _showSendView.center = CGPointMake(K_WIDTH/2.0, K_HEIGHT/2.0);
    _showSendView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_showSendView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShowSendView)];
    _showSendView.userInteractionEnabled = true;
    [_showSendView addGestureRecognizer:tap];
    
    [self startTimer];
}

- (void)configResidueInfo{
    _residueMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
    [self setLabelType:0 andText:@"0"];
    [self.view addSubview:_residueMoneyLabel];
    
    _residueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
    [self setLabelType:1 andText:@"0"];
    [self.view addSubview:_residueNumberLabel];
}

- (void)setResidueInfoByClick:(RedPackctModel *)model{
    allMoney = allMoney-[model.money doubleValue];
    if (allMoney==0) {
        allMoney=0;
    }
    allNumber = allNumber- 1;
    [self setLabelType:0 andText:[NSString stringWithFormat:@"%.2f",allMoney]];
    [self setLabelType:1 andText:[NSString stringWithFormat:@"%d",allNumber]];
}

- (void)setLabelType:(int)type andText:(NSString *)tips{
    if (type==0) {
        _residueMoneyLabel.text = [NSString stringWithFormat:@"还剩余%@元",tips];
        NSRange range = [_residueMoneyLabel.text rangeOfString:tips];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:_residueMoneyLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _residueMoneyLabel.attributedText = str;
    }else{
        _residueNumberLabel.text = [NSString stringWithFormat:@"还剩余%@个红包",tips];
        NSRange range = [_residueNumberLabel.text rangeOfString:tips];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:_residueNumberLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _residueNumberLabel.attributedText = str;
    }
}


- (void)startTimer{
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(start) userInfo:nil repeats:YES];
    }
}

- (void)start{
    float R = CGRectGetWidth(_showSendView.frame);
    if (R<=150&&!isBig) {
        R++;
    }else{
        R--;
        isBig = true;
        if (R<100) {
            isBig=false;
        }
    }
    _showSendView.bounds=CGRectMake(0, 0, R, R);
    _showSendView.layer.cornerRadius = R/2.0;
}

- (void)stopMyTimer{
    [_myTimer invalidate];
    _myTimer = nil;
}

- (void)hiddenShowSendView{
    if (!isSend) {
        [self stopMyTimer];
        [UIView animateWithDuration:0.5 animations:^{
            _showSendView.transform=CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [self showSendView];
        }];
    }else{
       RedPackctModel * model = [[RedPacketManager shareInstance] getClickMoney];
        if (!model.money) {
            [AlertView showWithTips:@"红包领完了哦"];
            isSend = false;
            _showSendView.backgroundColor = [UIColor grayColor];
            return;
        }
        [self setResidueInfoByClick:model];
        BubbleImageView *bubbleImageView = [[BubbleImageView alloc]initWithMaxHeight:self.view.bounds.size.height / 2.5 maxWidth: self.view.bounds.size.width / 1.5 maxFrame:CGRectMake([self makeRandomNumberFromMin:0 toMax:self.view.bounds.size.width], self.view.center.y, 80, 80) andSuperView:self.view andMoney:model.money];
        NSLog(@"%@ %@",model.number,model.money);
    }
}

- (void)showSendView{
    _sendView = [[SendRedPacket alloc] initWithFrame:CGRectMake(0, 0, K_SNEDWIDTH, K_SNEDHEIGHT)];
    _sendView.delegate = self;
    [_sendView showOnView:self.view];
    _sendView.transform=CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 animations:^{
        _sendView.transform=CGAffineTransformMakeScale(1, 1);
    }];
    
    
}

- (void)reShow:(void(^)(id MyBlock))block{
    _showSendView.backgroundColor = [UIColor redColor];
    isSend = true;
    [UIView animateWithDuration:0.5 animations:^{
        _showSendView.transform=CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        block(@"");
    }];
}

-(void)sendMoney:(NSString *)money andRedPacketNum:(NSString *)number{
    [[RedPacketManager shareInstance] setAllMoney:money andNumber:number];
    [self setLabelType:0 andText:money];
    [self setLabelType:1 andText:number];
    allMoney = [money doubleValue];
    allNumber = [number intValue];
    [self reShow:^(id MyBlock) {
        [self startTimer];
    }];
}


- (CGFloat)makeRandomNumberFromMin:(CGFloat)min toMax: (CGFloat)max
{
    NSInteger precision = 100;
    
    CGFloat subtraction = ABS(max - min);
    
    subtraction *= precision;
    
    CGFloat randomNumber = arc4random() % ((int)subtraction+1);
    
    randomNumber /= precision;
    
    randomNumber += min;
    
    return K_WIDTH/2.0;
    //返回结果
//    return randomNumber;
}


@end
