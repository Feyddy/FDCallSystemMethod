//
//  FDContactListViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 14/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDContactListViewController.h"
#import <ContactsUI/ContactsUI.h>
@interface FDContactListViewController ()<CNContactPickerDelegate>

@end

@implementation FDContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CNContactPickerViewController * con = [[CNContactPickerViewController alloc]init];
    con.delegate = self;
    [self presentViewController:con animated:YES completion:nil];
}

// 如果实现该方法当选中联系人时就不会再出现联系人详情界面， 如果需要看到联系人详情界面只能不实现这个方法，
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    NSLog(@"%@,",contact);
    CNPhoneNumber *phoneNumber = contact.phoneNumbers[0].value; // 电话号码
    
    NSString *emailStr = contact.emailAddresses[0].value; // 邮箱
    
    NSString *company = contact.organizationName; // 公司
    
    
    NSLog(@"姓名:%@%@\n电话:%@\n邮箱:%@\n公司:%@",contact.familyName, contact.givenName, phoneNumber.stringValue, emailStr, company);
}

// 同时选中多个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
    for (CNContact *contact in contacts) {
        NSLog(@"================================================");
        [self printContactInfo:contact];
    }
}

- (void)printContactInfo:(CNContact *)contact {
    NSString *givenName = contact.givenName;
    NSString *familyName = contact.familyName;
    NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
    NSArray * phoneNumbers = contact.phoneNumbers;
    for (CNLabeledValue<CNPhoneNumber*>*phone in phoneNumbers) {
        NSString *label = phone.label;
        CNPhoneNumber *phonNumber = (CNPhoneNumber *)phone.value;
        NSLog(@"label=%@, value=%@", label, phonNumber.stringValue);
    }
}
// 注意:如果实现该方法，上面那个方法就不能实现了，这两个方法只能实现一个
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
//  NSLog(@"选中某个联系人的某个属性时调用");
//}

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
