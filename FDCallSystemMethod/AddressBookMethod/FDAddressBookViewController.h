//
//  FDAddressBookViewController.h
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 16/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDAddressBookViewController;
@class ContactModel;
@protocol FDAddressBookViewControllerDelegate <NSObject>

- (void) adddContactListViewController:(FDAddressBookViewController *)controller contactModel:(ContactModel *)model;

@end
@interface FDAddressBookViewController : UIViewController

@property(strong,nonatomic)NSMutableArray *personArray;

@property (nonatomic, assign) NSInteger userType;


@property (nonatomic, weak) id<FDAddressBookViewControllerDelegate> delegate;

@end
