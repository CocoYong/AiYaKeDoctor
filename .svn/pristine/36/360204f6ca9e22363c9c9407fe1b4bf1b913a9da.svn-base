//
//  WorkModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "WorkModel.h"

@implementation WorkModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_content forKey:@"WorkModel_content"];
    [enCoder encodeObject:_wid forKey:@"WorkModel_wid"];
    [enCoder encodeObject:_month1 forKey:@"WorkModel_month1"];
    [enCoder encodeObject:_month2 forKey:@"WorkModel_month2"];
    [enCoder encodeObject:_name forKey:@"WorkModel_name"];
    [enCoder encodeObject:_year1 forKey:@"WorkModel_year1"];
    [enCoder encodeObject:_year2 forKey:@"WorkModel_year2"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.content = [deCoder decodeObjectForKey:@"WorkModel_content"];
        self.wid = [deCoder decodeObjectForKey:@"WorkModel_wid"];
        self.month1 = [deCoder decodeObjectForKey:@"WorkModel_month1"];
        self.month2 = [deCoder decodeObjectForKey:@"WorkModel_month2"];
        self.name = [deCoder decodeObjectForKey:@"WorkModel_name"];
        self.year1 = [deCoder decodeObjectForKey:@"WorkModel_year1"];
        self.year2 = [deCoder decodeObjectForKey:@"WorkModel_year2"];
    }
    return self;
}
@end
