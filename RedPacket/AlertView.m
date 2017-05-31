//
//  AlertView.m
//  RedPacket
//


#import "AlertView.h"

@implementation AlertView

+(void)showWithTips:(NSString *)tips{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * on = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:on];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
}

@end
