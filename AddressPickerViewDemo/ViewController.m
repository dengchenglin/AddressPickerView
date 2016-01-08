//
//  ViewController.m
//  AddressPickerViewDemo
//
//  Created by dengchenglin on 16/1/8.
//  Copyright © 2016年 dengchenglin. All rights reserved.
//

#import "ViewController.h"
#import "AddressPickerView.h"
@interface ViewController ()
@property(nonatomic,strong)Address *address;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    __weak typeof(self) _blockSelf = self;
    AddressPickerView *addressPickerView = [AddressPickerView showAddressPickerViewdidClick:^(Address *address) {
        NSLog(@"%@",address.province);
        NSLog(@"%@",address.city);
        NSLog(@"%@",address.area);
        _blockSelf.address = address;
    }];

    if(_address){
      [addressPickerView setAddress:_address];
    }
    
}

@end
