//
//  ViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 14/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "ViewController.h"
#import "FDSystemMethod.h"
#import "FDSystemMessageSendViewController.h"
#import "FDSystemMailSendViewController.h"
#import "FDContactListViewController.h"
#import "FDAddressBookViewController.h"
#import "FDAddressBookUIViewController.h"
#import "FDContactViewController.h"

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    


    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, MainScreenWidth - 100, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"系统方法调用" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(sysAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, MainScreenWidth - 100, 40)];
    btn2.backgroundColor = [UIColor grayColor];
    [btn2 setTitle:@"三方软件方法调用" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(thirdPartyAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, MainScreenWidth - 100, 40)];
    btn3.backgroundColor = [UIColor grayColor];
    [btn3 setTitle:@"系统发短信方法调用" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(systemMessageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, MainScreenWidth - 100, 40)];
    btn4.backgroundColor = [UIColor grayColor];
    [btn4 setTitle:@"系统发邮件方法调用" forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(systemsMailAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, MainScreenWidth - 100, 40)];
    btn5.backgroundColor = [UIColor grayColor];
    [btn5 setTitle:@"通过ContactUI获取手机通讯录" forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    [btn5 addTarget:self action:@selector(getContactListAction) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(50, 350, MainScreenWidth - 100, 40)];
    btn6.backgroundColor = [UIColor grayColor];
    [btn6 setTitle:@"通过AddressBook获取手机通讯录" forState:UIControlStateNormal];
    [self.view addSubview:btn6];
    [btn6 addTarget:self action:@selector(addressBookGetContactListAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn7 = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, MainScreenWidth - 100, 40)];
    btn7.backgroundColor = [UIColor grayColor];
    [btn7 setTitle:@"通过AddressBookUI获取手机通讯录" forState:UIControlStateNormal];
    [self.view addSubview:btn7];
    [btn7 addTarget:self action:@selector(addressBookUIGetContactListAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn8 = [[UIButton alloc] initWithFrame:CGRectMake(50, 450, MainScreenWidth - 100, 40)];
    btn8.backgroundColor = [UIColor grayColor];
    [btn8 setTitle:@"通过Contact获取手机通讯录" forState:UIControlStateNormal];
    [self.view addSubview:btn8];
    [btn8 addTarget:self action:@selector(getContactAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//调用系统的打电话等方法
- (void)sysAction {
    [FDSystemMethod fdSystemMethodWithTarget:self Type:FDSystemMethodMessageSend phoneNumber:@"15757166448" emailAddress:nil browserUrl:nil];
}

//调用第三方应用
- (void)thirdPartyAction {
    [FDSystemMethod fdThirdPartyApplicationWithTarget:self url:@"Feyddy://parames"];
    
    /*
     就像调用系统应用一样，协议后面可以传递一些参数（例如上面传递的myparams），这样一来在应用中可以在AppDelegate的-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation代理方法中接收参数并解析。
     
     -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
     NSString *str=[NSString stringWithFormat:@"url:%@,source application:%@,params:%@",url,sourceApplication,[url host]];
     NSLog(@"%@",str);
     return YES;//是否打开
     }

     */
}


- (void)systemMessageAction {
    [self.navigationController pushViewController:[[FDSystemMessageSendViewController alloc] init] animated:YES];
}


- (void)systemsMailAction {
    [self.navigationController pushViewController:[[FDSystemMailSendViewController alloc] init] animated:YES];
}

- (void)getContactListAction {
    [self.navigationController pushViewController:[[FDContactListViewController alloc] init] animated:YES];
}

- (void) addressBookGetContactListAction {
    [self.navigationController pushViewController:[[FDAddressBookViewController alloc] init] animated:YES];
}

- (void)addressBookUIGetContactListAction {
    [self.navigationController pushViewController:[[FDAddressBookUIViewController alloc] init] animated:YES];
}

- (void)getContactAction {
    [self.navigationController pushViewController:[[FDContactViewController alloc] init] animated:YES];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
