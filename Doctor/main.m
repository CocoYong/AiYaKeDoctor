//
//  main.m
//  YSProject
//
//  Created by cuiw on 15/5/20.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
         [NBSAppAgent startWithAppID:@"71687df61056468a80285068b44939d5"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
