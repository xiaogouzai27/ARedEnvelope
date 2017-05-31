//
//  SendRedPacket.h
//  RedPacket
//


#define K_WIDTH         [UIScreen mainScreen].bounds.size.width
#define K_HEIGHT        [UIScreen mainScreen].bounds.size.height
#define K_SNEDWIDTH     210
#define K_SNEDHEIGHT    250

#import <UIKit/UIKit.h>

@protocol SendRedPacketDeleagte <NSObject>

- (void)sendMoney:(NSString *)money andRedPacketNum:(NSString *)number;

@end


@interface SendRedPacket : UIView


- (void)showOnView:(UIView *)vc;


- (void)hidden;


@property (nonatomic,assign) id <SendRedPacketDeleagte> delegate;

@end
