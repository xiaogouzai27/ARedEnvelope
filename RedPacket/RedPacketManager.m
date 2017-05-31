//
//  RedPacketManager.m
//  RedPacket
//


#import "RedPacketManager.h"
#define ARC4RANDOM_MAX      0x100000000
#define MAX 200
@implementation RedPacketManager

+ (instancetype)shareInstance{
    static RedPacketManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance setInfo];
    });
    return instance;
}

- (void)setInfo{
    _getNumber = 0;
    _getMoney = _allMoney;
    _getArray = [NSMutableArray array];
    _allArray = [NSMutableArray array];
}

//设置
-(void)setAllMoney:(NSString *)money andNumber:(NSString *)number{
    if (!money||!number) return;
    _allArray = [NSMutableArray array];
    _allNumber = [number integerValue];
    _allMoney = [money doubleValue];    //每人最少一块
    _getMoney = _allMoney-_allNumber*0.01;
    for (int i= 0; i < _allNumber; i++) {
        
        RedPackctModel * model = [[RedPackctModel alloc] init];
        
        //分到的金额
        model.money = [NSString stringWithFormat:@"%lf",0.01 + [self getRandomMoney:(double)_getMoney]];
        
        
        //最后一个红包
        if (i==_allNumber-1) {  //处理最后一个
            model.money = [NSString stringWithFormat:@"%lf",_getMoney+0.01];
        }
        
        if ((_getMoney-[model.money doubleValue])>200*(_allNumber-i)) {
            model.money = [NSString stringWithFormat:@"%lf",_getMoney-200*(_allNumber-1)];
        }
        
        if ([model.money doubleValue]>200) {
            model.money=@"200.00";
        }
        
        if (_getMoney>0 ) {
            //剩余钱数
            _getMoney = _getMoney-[model.money doubleValue]+0.01;
        }else{
            _getMoney = 0;
        }
        
        if (_allNumber*200==_allMoney) {
            model.money = @"200.00";
        }
        [_getArray addObject:model];
    }
    //每一个红包的信息
    for (RedPackctModel * model in _getArray) {
        NSLog(@"每个红包的信息%@",model.money);
    }
}

- (double)getRandomMoney:(double)money{
    //这里进来的钱分为两部分  整数 和  小数
    if (!money) return 0;
    int rNum = (int)money;
    int fNum =(money-(int)money)*100;
    double random = arc4random_uniform(rNum);
    if (random>199.99) {       //最大只有200块
        random=199.99;
        return random;
    }
    int fRandom = arc4random_uniform(fNum);
    
    random=random+fRandom/100.0;
    if (random<199.99&&(_getMoney-random>199.99)) {
        random=_getMoney/2.0;
    }
    return random;
}

- (RedPackctModel *)getClickMoney{
    if (!_allNumber) {
        return [[RedPackctModel alloc] init];
    }
    _getNumber = _allNumber;
    int num = arc4random_uniform((int)_getNumber);
    RedPackctModel * model = [[RedPackctModel alloc] init];
    if (_getNumber==_allNumber-1) {
        model  = _getArray[0];
        model.number = [NSString stringWithFormat:@"%ld",_getArray.count];
        [_getArray removeObject:model];
        return model;
    }
    model = _getArray[num];
    model.number = [NSString stringWithFormat:@"%ld",_getArray.count];
    _allNumber--;
    [_getArray removeObject:model];
    return model;
}


@end
