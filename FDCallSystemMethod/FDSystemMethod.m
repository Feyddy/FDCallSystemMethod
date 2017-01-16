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


/*
 不难发现当openURL:方法只要指定一个URL Schame并且已经安装了对应的应用程序就可以打开此应用。当然，如果是自己开发的应用也可以调用openURL方法来打开。假设你现在开发了一个应用A，如果用户机器上已经安装了此应用，并且在应用B中希望能够直接打开A。那么首先需要确保应用A已经配置了Url Types，具体方法就是在plist文件中添加URL types节点并配置URL Schemas作为具体协议，配置URL identifier作为这个URL的唯一标识
 */
/*
 就像调用系统应用一样，协议后面可以传递一些参数（例如Feyddy:/params的params），这样一来在应用中可以在AppDelegate的-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation代理方法中接收参数并解析。
 
 -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
 NSString *str=[NSString stringWithFormat:@"url:%@,source application:%@,params:%@",url,sourceApplication,[url host]];
 NSLog(@"%@",str);
 return YES;//是否打开
 }
 
 */
+ (void)fdThirdPartyApplicationWithTarget:(id)target url:(NSString *)url {
     [self fdThirdPartyApplication:url withTarget:target];
    
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

#pragma mark - 打开第三方应用
+ (void)fdThirdPartyApplication:(NSString *)url withTarget:(id)target {
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



/*
 2. 系统服务之短信与邮件
 
 调用系统内置的应用来发送短信、邮件相当简单，但是这么操作也存在着一些弊端：当你点击了发送短信（或邮件）操作之后直接启动了系统的短信（或邮件）应用程序，我们的应用其实此时已经处于一种挂起状态，发送完（短信或邮件）之后无法自动回到应用界面。如果想要在应用程序内部完成这些操作则可以利用iOS中的MessageUI.framework,它提供了关于短信和邮件的UI接口供开发者在应用程序内部调用。从框架名称不难看出这是一套UI接口，提供有现成的短信和邮件的编辑界面，开发人员只需要通过编程的方式给短信和邮件控制器设置对应的参数即可。
 */

/*
 在MessageUI.framework中主要有两个控制器类分别用于发送短信（MFMessageComposeViewController）和邮件（MFMailComposeViewController）,它们均继承于UINavigationController。
 
 
 创建MFMessageComposeViewController对象。
 设置收件人recipients、信息正文body，如果运行商支持主题和附件的话可以设置主题subject、附件attachments（可以通过canSendSubject、canSendAttachments方法判断是否支持）
 设置代理messageComposeDelegate（注意这里不是delegate属性，因为delegate属性已经留给UINavigationController，MFMessageComposeViewController没有覆盖此属性而是重新定义了一个代理），实现代理方法获得发送状态。
 */



@end
