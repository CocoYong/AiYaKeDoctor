//
//  WorkTimeModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "WorkTimeModel.h"

@implementation WorkTimeModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_date1 forKey:@"WorkTimeModel_date1"];
    [enCoder encodeObject:_date2 forKey:@"WorkTimeModel_date2"];
    [enCoder encodeObject:_time forKey:@"WorkTimeModel_time"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.date1 = [deCoder decodeObjectForKey:@"WorkTimeModel_date1"];
        self.date2 = [deCoder decodeObjectForKey:@"WorkTimeModel_date2"];
        self.time = [deCoder decodeObjectForKey:@"WorkTimeModel_time"];
    }
    return self;
}
@end
