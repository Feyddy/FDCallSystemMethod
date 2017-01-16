//
//  FDAddressBookViewController.m
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 16/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import "FDAddressBookViewController.h"
#import "ContactTableViewCell.h"
#import "ContactDataHelper.h"
#import "ContactModel.h"

#import <AddressBook/AddressBook.h>
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FDAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate>
{
    NSMutableArray *rowArray;//row arr
    NSMutableArray *sectionArray;//section arr
    NSMutableArray *searchResultArray;//搜索结果Arr
    
    ABAddressBookRef addressBookRef;
    UITableView *table;
    UISearchBar *customSearchBar;//搜索框
    UISearchDisplayController *searchDisplayController;//搜索VC
    
    NSString *phoneString;
}

@end

@implementation FDAddressBookViewController

@synthesize personArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机通讯录";
    
    [self createView];
    
    sectionArray=[ContactDataHelper getFriendListDataBy:personArray];
    
    
    rowArray=[ContactDataHelper getFriendListSectionBy:[sectionArray mutableCopy]];
    
    //判断授权
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        
        NSLog(@"没有授权");
        return ;
    }
    [self getBook];
    
    
   
}

-(void)createView
{
    
    customSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    customSearchBar.placeholder=@"搜索";
    customSearchBar.delegate=self;
    [customSearchBar sizeToFit];
    [customSearchBar setKeyboardType:UIKeyboardTypeDefault];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableHeaderView=customSearchBar;
    table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    
    searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:customSearchBar contentsController:self];
    searchDisplayController.delegate=self;
    searchDisplayController.searchResultsDataSource=self;
    searchDisplayController.searchResultsDelegate=self;
    
    searchResultArray=[NSMutableArray array];
}

#pragma mark - 获取手机中的通讯录以及解析联系人

/*
 iOS10 需要在Info.plist配置NSContactsUsageDescription

 <key>NSContactsUsageDescription</key>
 <string>请求访问通讯录</string>
 */
-(NSMutableArray *)getBook
{
    if (personArray == nil) {
        personArray = [NSMutableArray array];
    }
   
    
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreate();
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        ContactModel *addressBook = [[ContactModel alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [personArray addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
        
    }
    
    
    return personArray;
}
#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return sectionArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==searchDisplayController.searchResultsTableView) {
        return searchResultArray.count;
    }else{
        
        return [sectionArray[section] count];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (tableView==searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text=searchResultArray[indexPath.row][@"name"];
        cell.detailTextLabel.text=searchResultArray[indexPath.row][@"tel"];
    }else{
        ContactModel *model=sectionArray[indexPath.section][indexPath.row];
        cell.textLabel.text = model.name;
        
        cell.detailTextLabel.text = model.tel;
    }
    
    return cell;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    return 52.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor blueColor]];
    }
    [label setText:[NSString stringWithFormat:@"  %@",rowArray[section+1]]];
    return label;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView!=searchDisplayController.searchResultsTableView) {
        return rowArray;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==searchDisplayController.searchResultsTableView) {
        return 0;
    }else{
        return 22.0;
    }
}


-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           
                                                                           
                                                                       }];
    
    NSArray *arr = @[rowAction];
    return arr;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {

//        [_rowArr removeObjectAtIndex:[indexPath row]];
//        if (_rowArr.count == 0) {
//            [_sectionArr removeObjectAtIndex:[indexPath section]];
//        }
//
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
//        [tableView reloadData];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactModel *model=sectionArray[indexPath.section][indexPath.row];
    
    
    phoneString = model.tel;
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
            [self.delegate adddContactListViewController:self contactModel:model];
            UIAlertView *alterV = [[UIAlertView alloc] initWithTitle:@"验证信息" message:@"" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterV.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alterV show];
            break;
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


#pragma mark searchBar delegate
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSArray *subViews;
    subViews = [(searchBar.subviews[0]) subviews];
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    searchBar.showsCancelButton = YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

#pragma mark searchDisplayController delegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[customSearchBar scopeButtonTitles][customSearchBar.selectedScopeButtonIndex]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:customSearchBar.text
                               scope:customSearchBar.scopeButtonTitles[searchOption]];
    return YES;
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.personArray.count; i++) {
        NSString *nameString = [(ContactModel *)self.personArray[i] name];
        NSString *telString=[(ContactModel *)self.personArray[i] tel]?[(ContactModel *)self.personArray[i] tel]:@"";
        
        if ([self validateNumber:searchText])
        {
            NSString *telStr = [telString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSRange range = NSMakeRange(0, telStr.length);
            
            NSRange foundRange = [telStr rangeOfString:searchText options:searchOptions range:range];
            if (foundRange.length) {
                NSDictionary *dic=@{@"name":nameString,@"tel":telString};
                [tempResults addObject:dic];
            }
        }else{
            NSString *nameStr = [nameString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange range = NSMakeRange(0, nameStr.length);
            
            NSRange foundRange = [nameStr rangeOfString:searchText options:searchOptions range:range];
            if (foundRange.length) {
                NSDictionary *dic=@{@"name":nameString,@"tel":telString};
                [tempResults addObject:dic];
            }
        }
    }
    if (searchResultArray.count != 0) {
        [searchResultArray removeAllObjects];
    }
    
    [searchResultArray addObjectsFromArray:tempResults];
}

- (BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark - buttonAction
- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)noticeButtonAction
{
    
}
@end
