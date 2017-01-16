//
//  FDSystemMethod.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 14/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDSystemMethod.h"

@implementation FDSystemMethod


+ (void)fdSystemMethodWithTarget:(id)target Type:(FDSystemMethodType)type phoneNumber:(NSString *)phone emailAddress:(NSString *)email browserUrl:(NSString *)url
{
    switch (type) {
        case FDSystemMethodPhoneCall:
            
            [self fdPhoneCall:phone withTarget:target];
            break;
        case FDSystemMethodMessageSend:
            [self fdMessageSend:phone withTarget:target];
            break;
            
        case FDSystemMethodEmailSend:
            [self fdEmailSend:email withTarget:target];
            break;
        case FDSystemMethodBrowser:
            [self fdPhoneCall:url withTarget:target];
            break;
        default:
            break;
    }
    
}

#pragma mark - 打电话
+ (void)fdPhoneCall:(NSString *)phone withTarget:(id)target{
    //    NSString *url=[NSString stringWithFormat:@"tel://%@",phoneNumber];//这种方式会直接拨打电话
    NSString *url=[NSString stringWithFormat:@"telprompt://%@",phone];//这种方式会提示用户确认是否拨打电话
    [target openUrl:url];
}

#pragma mark - 发短信
+ (void)fdMessageSend:(NSString *)phone withTarget:(id)target {
    NSString *url=[NSString stringWithFormat:@"sms://%@",phone];
    [target openUrl:url];
}
#pragma mark - 发邮件
+ (void)fdEmailSend:(NSString *)email withTarget:(id)target {
    NSString *url=[NSString stringWithFormat:@"mailto://%@",email];
    [target openUrl:url];
}
#pragma mark - 浏览器
+ (void)fdBrowser:(NSString *)url withTarget:(id)target {
     [target openUrl:url];
}


#pragma mark - 私有方法
-(void)openUrl:(NSString *)urlStr{
    //注意url中包含协议名称，iOS根据协议确定调用哪个应用，例如发送邮件是“sms://”其中“//”可以省略写成“sms:”(其他协议也是如此)
    NSURL *url=[NSURL URLWithString:urlStr];
    UIApplication *application=[UIApplication sharedApplication];
    if(![application canOpenURL:url]){
        NSLog(@"无法打开\"%@\"，请确保此应用已经正确安装.",url);
        return;
    }
    [[UIApplication sharedApplication] openURL:url];
}


@end
