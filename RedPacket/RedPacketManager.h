//
//  RedPacketManager.h
//  RedPacket
//


#import <Foundation/Foundation.h>
#import "RedPackctModel.h"

@interface RedPacketManager : NSObject

+ (instancetype)shareInstance;


/*! @brief  点击次数
 */
- (RedPackctModel *)getClickMoney;


- (void)setAllMoney:(NSString *)money andNumber:(NSString *)number;

@property (nonatomic,strong) NSMutableArray * allArray;

@property (nonatomic,strong) NSMutableArray * getArray;

@property (nonatomic,assign) double allMoney;

@property (nonatomic,assign) double getMoney;

@property (nonatomic,assign) NSInteger allNumber;

@property (nonatomic,assign) NSInteger getNumber;

@end
