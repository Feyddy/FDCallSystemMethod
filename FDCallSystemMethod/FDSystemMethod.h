//
//  FDSystemMethod.h
//  FDCallSystemMethod
//
//  Created by 徐忠林 on 14/01/2017.
//  Copyright © 2017 Feyddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FDSystemMethodPhoneCall,
    FDSystemMethodMessageSend,
    FDSystemMethodEmailSend,
    FDSystemMethodBrowser,
} FDSystemMethodType;

@interface FDSystemMethod : NSObject


+ (void)fdSystemMethodWithTarget:(id)target Type:(FDSystemMethodType)type phoneNumber:(NSString *)phone emailAddress:(NSString *)email browserUrl:(NSString *)url;


+ (void)fdThirdPartyApplicationWithTarget:(id)target url:(NSString *)url;
@end
