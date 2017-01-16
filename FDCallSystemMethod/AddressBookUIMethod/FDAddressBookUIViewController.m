//
//  FDAddressBookUIViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 16/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDAddressBookUIViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#define IS_iOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0f
#define IS_iOS6 [[UIDevice currentDevice].systemVersion floatValue] >= 6.0f
@interface FDAddressBookUIViewController ()<ABPeoplePickerNavigationControllerDelegate>{

    ABPeoplePickerNavigationController *_abPeoplePickerVc;
}

@property (nonatomic,strong) NSMutableDictionary *infoDictionary;

@end

@implementation FDAddressBookUIViewController


- (NSMutableDictionary *)infoDictionary
{
    if (_infoDictionary == nil) {
        _infoDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [_infoDictionary setObject:@"张三" forKey:@"name"];
        [_infoDictionary setObject:@"13000000000" forKey:@"phone"];
        [_infoDictionary setObject:@"1000000000@qq.com" forKey:@"email"];
     }
    return _infoDictionary;

}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.打开通讯录
    UIButton *openAddressBook = [UIButton buttonWithType:UIButtonTypeCustom];
    openAddressBook.frame = CGRectMake(100, 50, 100, 50);
    [openAddressBook setTitle:@"打开通讯录" forState:UIControlStateNormal];
    openAddressBook.backgroundColor = [UIColor greenColor];
    [openAddressBook setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [openAddressBook addTarget:self action:@selector(gotoAddressBook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openAddressBook];
    
    //2.添加联系人
    UIButton *addContacts = [UIButton buttonWithType:UIButtonTypeCustom];
    addContacts.frame = CGRectMake(100, 150, 100, 50);
    [addContacts setTitle:@"添加联系人" forState:UIControlStateNormal];
    addContacts.backgroundColor = [UIColor greenColor];
    [addContacts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addContacts addTarget:self action:@selector(gotoAddContacts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addContacts];
    
}

/**
 打开通讯录
 */
- (void)gotoAddressBook{
    
    _abPeoplePickerVc = [[ABPeoplePickerNavigationController alloc] init];
    _abPeoplePickerVc.peoplePickerDelegate = self;
    
    //下面的判断是ios8之后才需要加的，不然会自动返回app内部
    if(IS_iOS8){
        
        //predicateForSelectionOfPerson默认是true （当你点击某个联系人查看详情的时候会返回app），如果你默认为true 但是实现-peoplePickerNavigationController:didSelectPerson:property:identifier:
        //代理方法也是可以的，与此同时不能实现peoplePickerNavigationController: didSelectPerson:不然还是会返回app。
        //总之在ios8之后加上此句比较稳妥
        _abPeoplePickerVc.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        
        //predicateForSelectionOfProperty默认是true （当你点击某个联系人的某个属性的时候会返回app），此方法只要是默认值，无论你代理方法实现与否都会返回app。
        //        _abPeoplePickerVc.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:false];
        
        //predicateForEnablingPerson默认是true，当设置为false时，所有的联系人都不能被点击。
        //        _abPeoplePickerVc.predicateForEnablingPerson = [NSPredicate predicateWithValue:true];
    }
    [self presentViewController:_abPeoplePickerVc animated:YES completion:nil];
    
}


/*
 这里需要注意的是：
 
 　　在iOS8之后需要加_abPeoplePickerVc.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];这句代码，不然当你选择通讯录中的某个联系人的时候会直接返回app内部（类似crash）。predicateForSelectionOfPerson默认是true （当你点击某个联系人查看详情的时候会返回app），如果你默认为true 但是实现-peoplePickerNavigationController:didSelectPerson:property:identifier: 代理方法也是可以的，与此同时不能实现peoplePickerNavigationController: didSelectPerson:不然还是会返回app。
    　_abPeoplePickerVc.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:false];作用同上。但是_abPeoplePickerVc.predicateForEnablingPerson 的断言语句必须为true，否则任何联系人你都不能选择。上面的代码中也有详细描述。
 */



#pragma mark - ABPeoplePickerNavigationController的代理方法

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (phone && phoneNO.length == 11) {
        //TODO：获取电话号码要做的事情
        
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }else{
        if (IS_iOS8){
            UIAlertController *tipVc = [UIAlertController alertControllerWithTitle:nil message:@"请选择正确手机号" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [tipVc addAction:cancleAction];
            [self presentViewController:tipVc animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        //非ARC模式需要释放对象
        //        [alertView release];
    }
}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    
    [peoplePicker pushViewController:personViewController animated:YES];
    //非ARC模式需要释放对象
    //    [personViewController release];
}

/**
 peoplePickerNavigationController点击取消按钮时调用
 */
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

/**
 iOS8被废弃了，iOS8前查看联系人必须实现（点击联系人可以继续操作）
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}

/**
 iOS8被废弃了，iOS8前查看联系人属性必须实现（点击联系人属性可以继续操作）
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && phoneNO.length == 11) {
        //TODO：获取电话号码要做的事情
        
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }else{
        if (IS_iOS8){
            UIAlertController *tipVc = [UIAlertController alertControllerWithTitle:nil message:@"请选择正确手机号" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [tipVc addAction:cancleAction];
            [self presentViewController:tipVc animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
    return YES;
}




/**
 添加联系人,必须真机测试
 */
- (void)gotoAddContacts{
    
    //添加到通讯录,判断通讯录是否存在
    if ([self isExistContactPerson]) {//存在，返回
        //提示
        if (IS_iOS8) {
            UIAlertController *tipVc  = [UIAlertController alertControllerWithTitle:@"提示" message:@"联系人已存在..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [tipVc addAction:cancleAction];
            [self presentViewController:tipVc animated:YES completion:nil];
        }else{
            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:@"提示" message:@"联系人已存在..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [tip show];
            //        [tip release];
        }
        return;
    }else{//不存在  添加
        [self creatNewRecord];
    }
}

- (BOOL)isExistContactPerson{
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    
    BOOL __block isExist = NO;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if (IS_iOS6) {
        //创建通讯簿的引用，第一个参数暂时写NULL，官方文档就是这么说的，后续会有用，第二个参数是error参数
        CFErrorRef error = NULL;
        addBook=ABAddressBookCreateWithOptions(NULL, &error);
        //创建一个初始信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
                
            }else{
                //获取所有联系人的数组
                CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
                //获取联系人总数
                CFIndex number = ABAddressBookGetPersonCount(addBook);
                //进行遍历
                for (NSInteger i=0; i<number; i++) {
                    //获取联系人对象的引用
                    ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
                    //获取当前联系人名字
                    NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
                    
                    if ([firstName isEqualToString:[_infoDictionary objectForKey:@"name"]]) {
                        isExist = YES;
                    }
                    
                    //                    //获取当前联系人姓氏
                    //                    NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
                    
                    //获取当前联系人中间名
                    //                    NSString*middleName=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
                    //                    //获取当前联系人的名字前缀
                    //                    NSString*prefix=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonPrefixProperty));
                    //                    //获取当前联系人的名字后缀
                    //                    NSString*suffix=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonSuffixProperty));
                    //                    //获取当前联系人的昵称
                    //                    NSString*nickName=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonNicknameProperty));
                    //                    //获取当前联系人的名字拼音
                    //                    NSString*firstNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonFirstNamePhoneticProperty));
                    //                    //获取当前联系人的姓氏拼音
                    //                    NSString*lastNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonLastNamePhoneticProperty));
                    //                    //获取当前联系人的中间名拼音
                    //                    NSString*middleNamePhoneic=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonMiddleNamePhoneticProperty));
                    //                    //获取当前联系人的公司
                    //                    NSString*organization=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonOrganizationProperty));
                    //                    //获取当前联系人的职位
                    //                    NSString*job=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonJobTitleProperty));
                    //                    //获取当前联系人的部门
                    //                    NSString*department=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonDepartmentProperty));
                    //                    //获取当前联系人的生日
                    //                    NSString*birthday=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonBirthdayProperty));
                    //                    NSMutableArray * emailArr = [[NSMutableArray alloc]init];
                    //                    //获取当前联系人的邮箱 注意是数组
                    //                    ABMultiValueRef emails= ABRecordCopyValue(people, kABPersonEmailProperty);
                    //                    for (NSInteger j=0; j<ABMultiValueGetCount(emails); j++) {
                    //                        [emailArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, j))];
                    //                    }
                    //                    //获取当前联系人的备注
                    //                    NSString*notes=(__bridge NSString*)(ABRecordCopyValue(people, kABPersonNoteProperty));
                    //                    //获取当前联系人的电话 数组
                    //                    NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
                    //                    ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
                    //                    for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                    //                        [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
                    //                    }
                    //                    //获取创建当前联系人的时间 注意是NSDate
                    //                    NSDate*creatTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonCreationDateProperty));
                    //                    //获取最近修改当前联系人的时间
                    //                    NSDate*alterTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonModificationDateProperty));
                    //                    //获取地址
                    //                    ABMultiValueRef address = ABRecordCopyValue(people, kABPersonAddressProperty);
                    //                    for (int j=0; j<ABMultiValueGetCount(address); j++) {
                    //                        //地址类型
                    //                        NSString * type = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(address, j));
                    //                        NSDictionary * temDic = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(address, j));
                    //                        //地址字符串，可以按需求格式化
                    //                        NSString * adress = [NSString stringWithFormat:@"国家:%@\n省:%@\n市:%@\n街道:%@\n邮编:%@",[temDic valueForKey:(NSString*)kABPersonAddressCountryKey],[temDic valueForKey:(NSString*)kABPersonAddressStateKey],[temDic valueForKey:(NSString*)kABPersonAddressCityKey],[temDic valueForKey:(NSString*)kABPersonAddressStreetKey],[temDic valueForKey:(NSString*)kABPersonAddressZIPKey]];
                    //                    }
                    //                    //获取当前联系人头像图片
                    //                    NSData*userImage=(__bridge NSData*)(ABPersonCopyImageData(people));
                    //                    //获取当前联系人纪念日
                    //                    NSMutableArray * dateArr = [[NSMutableArray alloc]init];
                    //                    ABMultiValueRef dates= ABRecordCopyValue(people, kABPersonDateProperty);
                    //                    for (NSInteger j=0; j<ABMultiValueGetCount(dates); j++) {
                    //                        //获取纪念日日期
                    //                        NSDate * data =(__bridge NSDate*)(ABMultiValueCopyValueAtIndex(dates, j));
                    //                        //获取纪念日名称
                    //                        NSString * str =(__bridge NSString*)(ABMultiValueCopyLabelAtIndex(dates, j));
                    //                        NSDictionary * temDic = [NSDictionary dictionaryWithObject:data forKey:str];
                    //                        [dateArr addObject:temDic];
                    //                    }
                }
                
                
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        
        //IOS6之前
        addBook =ABAddressBookCreate();
        
        //获取所有联系人的数组
        CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
        //获取联系人总数
        CFIndex number = ABAddressBookGetPersonCount(addBook);
        //进行遍历
        for (NSInteger i=0; i<number; i++) {
            //获取联系人对象的引用
            ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
            //获取当前联系人名字
            NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            
            if ([firstName isEqualToString:[_infoDictionary objectForKey:@"name"]]) {
                isExist = YES;
            }
        }
    }
    
    if (tip) {
        //设置提示
        if (IS_iOS8) {
            UIAlertController *tipVc  = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [tipVc addAction:cancleAction];
            [tipVc presentViewController:tipVc animated:YES completion:nil];
        }else{
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            //非ARC
            //            [alart release];
        }
    }
    return isExist;
}

//创建新的联系人
- (void)creatNewRecord
{
    CFErrorRef error = NULL;
    
    //创建一个通讯录操作对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    //创建一条新的联系人纪录
    ABRecordRef newRecord = ABPersonCreate();
    
    //为新联系人记录添加属性值
    ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)[_infoDictionary objectForKey:@"name"], &error);
    
    //创建一个多值属性(电话)
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)[_infoDictionary objectForKey:@"phone"], kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
    
    //添加email
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)([_infoDictionary objectForKey:@"email"]), kABWorkLabel, NULL);
    ABRecordSetValue(newRecord, kABPersonEmailProperty, multiEmail, &error);
    
    
    //添加记录到通讯录操作对象
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    
    //保存通讯录操作对象
    ABAddressBookSave(addressBook, &error);
    
    //通过此接口访问系统通讯录
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            //显示提示
            if (IS_iOS8) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"添加成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                [alertVc addAction:alertAction];
                [self presentViewController:alertVc animated:YES completion:nil];
            }else{
                
                UIAlertView *tipView = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [tipView show];
                //非ARC
                //                [tipView release];
            }
        }
    });
    
    CFRelease(multiEmail);
    CFRelease(multi);
    CFRelease(newRecord);
    CFRelease(addressBook);
}


@end
