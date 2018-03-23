//
//  TimeModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_time1 forKey:@"TimeModel_time1"];
    [enCoder encodeObject:_time2 forKey:@"TimeModel_time2"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.time1 = [deCoder decodeObjectForKey:@"TimeModel_time1"];
        self.time2 = [deCoder decodeObjectForKey:@"TimeModel_time2"];
    }
    return self;
}
@end
