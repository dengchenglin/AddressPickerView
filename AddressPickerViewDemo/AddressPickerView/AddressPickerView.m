//
//  AddressPickerView.m
//  Gaiyun
//
//  Created by chenguangjiang on 16/1/4.
//  Copyright © 2016年 qianmeng. All rights reserved.
//

#import "AddressPickerView.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define autoX  ScreenWidth/320
#define autoY  (ScreenHeight>480 ? ScreenHeight/568 : 1.0)
#define autoFont ((ScreenWidth == 320) ? 1 : (autoX * 0.93))
#define kRGBColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface AddressPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,copy) void(^block)(Address *address);
@end
@implementation AddressPickerView{
    NSArray *provinces,*cities,*areas;
}
+(AddressPickerView *)showAddressPickerViewdidClick:(void(^)(Address *address))block{
    AddressPickerView *pickerView = [[AddressPickerView alloc]init];
    pickerView.block = block;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    return pickerView;
}


-(instancetype)init{
    if(self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]){
        UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelf)];
        [backView addGestureRecognizer:tap];
        [self addSubview:backView];
        
        
        UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 200 *autoY, ScreenWidth, 200 *autoY)];
        showView.backgroundColor = [UIColor whiteColor];
        [self addSubview:showView];
        
        UIView *sureView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40 *autoY)];
        [showView addSubview:sureView];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(0, 0, 60 *autoX, sureView.bounds.size.height)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:cancelBtn];
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setFrame:CGRectMake(ScreenWidth - 60 *autoX, 0, 60 *autoX, sureView.bounds.size.height)];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:sureBtn];
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sureView.frame), ScreenWidth, 160 *autoY)];
        _pickerView.backgroundColor = kRGBColor(248, 248, 248, 1);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [showView addSubview:_pickerView];
        _address = [[Address alloc]init];
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        _address.province = [[provinces objectAtIndex:0] objectForKey:@"state"];
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        _address.city = [[cities objectAtIndex:0] objectForKey:@"city"];
        areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
        if(areas.count > 0){
            _address.area = [areas objectAtIndex:0];
        }
        else{
            _address.area = @"";
        }
    }
    return self;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return provinces.count;
    }
    if(component == 1){
        return cities.count;
    }
    return areas.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if(areas.count > 0){
                return [areas objectAtIndex:row];
                break;
            }
        default:
            return @"";
            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView reloadComponent:1];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            self.address.province = [[provinces objectAtIndex:row] objectForKey:@"state"];
            self.address.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            if ([areas count] > 0) {
                self.address.area = [areas objectAtIndex:0];
            } else{
                self.address.area = @"";
            }
            break;
        case 1:
            areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
            [_pickerView reloadComponent:2];
            
            self.address.city = [[cities objectAtIndex:row] objectForKey:@"city"];
            if ([areas count] > 0) {
                self.address.area = [areas objectAtIndex:0];
            } else{
                self.address.area = @"";
            }
            break;
        case 2:
            if ([areas count] > 0) {
                self.address.area = [areas objectAtIndex:row];
            } else{
                self.address.area = @"";
            }
            break;
        default:
            break;
    }

}
-(void)setAddress:(Address *)address{
    _address = address;
    __block NSInteger provinceIndex = 0;
    __block NSInteger cityIndex = 0;
    __block NSInteger areaIndex = 0;
    [provinces enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *d = (NSDictionary *)obj;
        if([[d objectForKey:@"state"] isEqualToString:address.province]){
            cities = [[provinces objectAtIndex:idx] objectForKey:@"cities"];
            provinceIndex = idx;
            *stop = YES;
        }
    }];
    [cities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *d = (NSDictionary *)obj;
        if([[d objectForKey:@"city"] isEqualToString:address.city]){
            areas = [[cities objectAtIndex:idx] objectForKey:@"areas"];
            cityIndex = idx;
            *stop = YES;
        }
        
    }];
    [areas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:address.area]){
            areaIndex = idx;
            *stop = YES;
        }
    }];

    [_pickerView reloadAllComponents];
    [_pickerView selectRow:provinceIndex inComponent:0 animated:NO];
    [_pickerView selectRow:cityIndex inComponent:1 animated:NO];
    [_pickerView selectRow:areaIndex inComponent:2 animated:NO];
  
}




-(void)cancel{
    [self removeFromSuperview];
}
-(void)sure{
    Address *address = _address;
    if(_block){
        _block(address);
    }
    [self removeFromSuperview];
}
-(void)hiddenSelf{
    [self removeFromSuperview];
}
- (void)dealloc
{
    
}
@end

@implementation Address
@end
