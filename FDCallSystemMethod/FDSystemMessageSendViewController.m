//
//  FDSystemMessageSendViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 14/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDSystemMessageSendViewController.h"
#import <MessageUI/MessageUI.h>
@interface FDSystemMessageSendViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageGetPersonLabel;//textField
@property (weak, nonatomic) IBOutlet UITextField *MessageContentTextFied;
@property (weak, nonatomic) IBOutlet UITextField *themeTextField;
@property (weak, nonatomic) IBOutlet UITextField *accessoryTextField;

@end

@implementation FDSystemMessageSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


/*
 
 这里需要强调一下：
 
 .1) MFMessageComposeViewController的代理不是通过delegate属性指定的而是通过messageComposeDelegate指定的。
 
 .2) 可以通过几种方式来指定发送的附件，在这个过程中请务必指定文件的后缀，否则在发送后无法正确识别文件类别（例如如果发送的是一张jpg图片，在发送后无法正确查看图片）。
 
 .3) 无论发送成功与否代理方法-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result都会执行，通过代理参数中的result来获得发送状态。
 

 */


//在软件的界面编辑好内容，然后直接跳转到系统界面，自动填写好相应的内容，点击发送
- (IBAction)sendButton:(id)sender {
    
    //如果能发送文本信息
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *messageController=[[MFMessageComposeViewController alloc]init];
        //收件人
        messageController.recipients=[self.messageGetPersonLabel.text componentsSeparatedByString:@","];
        //信息正文
        messageController.body=self.MessageContentTextFied.text;
        //设置代理,注意这里不是delegate而是messageComposeDelegate
        messageController.messageComposeDelegate=self;
        //如果运行商支持主题
        if([MFMessageComposeViewController canSendSubject]){
            messageController.subject=self.themeTextField.text;
        }
//        //如果运行商支持附件
//        if ([MFMessageComposeViewController canSendAttachments]) {
//            /*第一种方法*/
//            //messageController.attachments=...;
//            
//            /*第二种方法*/
//            NSArray *attachments= [self.accessoryTextField.text componentsSeparatedByString:@","];
//            if (attachments.count>0) {
//                [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    NSString *path=[[NSBundle mainBundle]pathForResource:obj ofType:nil];
//                    NSURL *url=[NSURL fileURLWithPath:path];
//                    [messageController addAttachmentURL:url withAlternateFilename:obj];
//                }];
//            }
//            
//            /*第三种方法*/
//            //            NSString *path=[[NSBundle mainBundle]pathForResource:@"photo.jpg" ofType:nil];
//            //            NSURL *url=[NSURL fileURLWithPath:path];
//            //            NSData *data=[NSData dataWithContentsOfURL:url];
//            /**
//             *  attatchData:文件数据
//             *  uti:统一类型标识，标识具体文件类型，详情查看：帮助文档中System-Declared Uniform Type Identifiers
//             *  fileName:展现给用户看的文件名称
//             */
//            //            [messageController addAttachmentData:data typeIdentifier:@"public.image"  filename:@"photo.jpg"];
//        }
        [self presentViewController:messageController animated:YES completion:nil];
    }

    
}

#pragma mark - MFMessageComposeViewController代理方法
//发送完成，不管成功与否
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功.");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"取消发送.");
            break;
        default:
            NSLog(@"发送失败.");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
