//
//  AddressPickerView.h
//  Gaiyun
//
//  Created by chenguangjiang on 16/1/4.
//  Copyright © 2016年 qianmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Address;
@interface AddressPickerView : UIView
+(AddressPickerView *)showAddressPickerViewdidClick:(void(^)(Address *address))block;
@property (nonatomic,strong) Address *address;
@end
@interface Address : NSObject
@property (nonatomic,copy) NSString * province;
@property (nonatomic,copy) NSString * city;
@property (nonatomic,copy) NSString * area;
@end