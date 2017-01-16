//
//  FDSystemMailSendViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 14/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDSystemMailSendViewController.h"
#import <MessageUI/MessageUI.h>

@interface FDSystemMailSendViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *toPersonTextField;
@property (weak, nonatomic) IBOutlet UITextField *toCopyTextField;

@property (weak, nonatomic) IBOutlet UITextField *closeTextField;

@property (weak, nonatomic) IBOutlet UITextField *themeTextField;
@property (weak, nonatomic) IBOutlet UITextField *conteintTextField;

@property (weak, nonatomic) IBOutlet UITextField *accessoryTextField;



@end

@implementation FDSystemMailSendViewController


// 其实只要熟悉了MFMessageComposeViewController之后，那么用于发送邮件的MFMailComposeViewController用法和步骤完全一致，只是功能不同。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sendMailButton:(id)sender {
    
    //判断当前是否能够发送邮件
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc]init];
        //设置代理，注意这里不是delegate，而是mailComposeDelegate
        mailController.mailComposeDelegate=self;
        //设置收件人
        [mailController setToRecipients:[self.toPersonTextField.text componentsSeparatedByString:@","]];
        //设置抄送人
        if (self.toCopyTextField.text.length>0) {
            [mailController setCcRecipients:[self.toCopyTextField.text componentsSeparatedByString:@","]];
        }
        //设置密送人
        if (self.closeTextField.text.length>0) {
            [mailController setBccRecipients:[self.closeTextField.text componentsSeparatedByString:@","]];
        }
        //设置主题
        [mailController setSubject:self.themeTextField.text];
        //设置内容
        [mailController setMessageBody:self.conteintTextField.text isHTML:YES];
//        //添加附件
//        if (self.accessoryTextField.text.length>0) {
//            NSArray *attachments=[self.accessoryTextField.text componentsSeparatedByString:@","] ;
//            [attachments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                NSString *file=[[NSBundle mainBundle] pathForResource:obj ofType:nil];
//                NSData *data=[NSData dataWithContentsOfFile:file];
//                [mailController addAttachmentData:data mimeType:@"image/jpeg" fileName:obj];//第二个参数是mimeType类型，jpg图片对应image/jpeg
//            }];
//        }
        [self presentViewController:mailController animated:YES completion:nil];
        
    }
}

#pragma mark - MFMailComposeViewController代理方法
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"发送成功.");
            break;
        case MFMailComposeResultSaved://如果存储为草稿（点取消会提示是否存储为草稿，存储后可以到系统邮件应用的对应草稿箱找到）
            NSLog(@"邮件已保存.");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送.");
            break;
            
        default:
            NSLog(@"发送失败.");
            break;
    }
    if (error) {
        NSLog(@"发送邮件过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
