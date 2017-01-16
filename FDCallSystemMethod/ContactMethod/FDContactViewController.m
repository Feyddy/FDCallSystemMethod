//
//  FDContactViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 16/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDContactViewController.h"
#import <Contacts/Contacts.h>

//iOS10 需要在Info.plist配置NSContactsUsageDescription
//
//<key>NSContactsUsageDescription</key>
//<string>请求访问通讯录</string>
@interface FDContactViewController ()

@end

@implementation FDContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn8 = [[UIButton alloc] initWithFrame:CGRectMake(50, 300,200, 40)];
    btn8.backgroundColor = [UIColor grayColor];
    [btn8 setTitle:@"获取手机通讯录" forState:UIControlStateNormal];
    [self.view addSubview:btn8];
    [btn8 addTarget:self action:@selector(getContactAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)getContactAction {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        NSLog(@"没有授权...");
    }
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            NSString *label = labelValue.label;
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
        }
        
        //    *stop = YES; // 停止循环，相当于break；
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
