//
//  ViewController.m
//  UserAddressBook
//
//  Created by mac on 15/12/10.
//  Copyright (c) 2015年 dqy. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ABAddressBookRef userAddressBook = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        
        userAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //获得授权
        dispatch_semaphore_t sysphone = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(userAddressBook, ^(bool granted, CFErrorRef error) {
           
            //请求
            dispatch_semaphore_signal(sysphone);
        });
        
        //等待
        dispatch_semaphore_wait(sysphone, DISPATCH_TIME_FOREVER);
        
        
        
    }
    else {
        
        //小于6.0
        
        userAddressBook = ABAddressBookCreate();
        
    }
    
    
    
    //获取所有的人员
    
    CFArrayRef peoples = ABAddressBookCopyArrayOfAllPeople(userAddressBook);
    
    //获得人员的个数
    
    CFIndex peopleNum = ABAddressBookGetPersonCount(userAddressBook);
    
    
    //遍历所有人员
    for (CFIndex i = 0; i < peopleNum; i++) {
        
        //获得单个人员的信息
        ABRecordRef person = CFArrayGetValueAtIndex(peoples, i);
        
        //姓名
        CFTypeRef cfname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        CFTypeRef cflastname = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        NSString * firstname = (__bridge NSString *)cfname;
        
        NSString * lastname = (__bridge NSString *) cflastname;
        
        NSString * fullname = [NSString stringWithFormat:@"%@%@",firstname,lastname];
        
        NSLog(@"%@\n",fullname);
        
        //电话
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phone); i++) {
            
            //电话号码
            NSString * phoneNum = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, i);
            
            //电话类型
            NSString * phoneKind = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, i));
            
            
            NSLog(@"%@   %@",phoneKind,phoneNum);
            
        }
        
        NSLog(@"-------------");
        
        
        
        
        
        
    }
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
