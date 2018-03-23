//
//  EduModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "EduModel.h"

@implementation EduModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_content forKey:@"EduModel_content"];
    [enCoder encodeObject:_eid forKey:@"EduModel_eid"];
    [enCoder encodeObject:_month1 forKey:@"EduModel_month1"];
    [enCoder encodeObject:_month2 forKey:@"EduModel_month2"];
    [enCoder encodeObject:_name forKey:@"EduModel_name"];
    [enCoder encodeObject:_year1 forKey:@"EduModel_year1"];
    [enCoder encodeObject:_year2 forKey:@"EduModel_year2"];
    [enCoder encodeObject:_uid forKey:@"EduModel_uid"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.content = [deCoder decodeObjectForKey:@"EduModel_content"];
        self.eid = [deCoder decodeObjectForKey:@"EduModel_eid"];
        self.month1 = [deCoder decodeObjectForKey:@"EduModel_month1"];
        self.month2 = [deCoder decodeObjectForKey:@"EduModel_month2"];
        self.name = [deCoder decodeObjectForKey:@"EduModel_name"];
        self.year1 = [deCoder decodeObjectForKey:@"EduModel_year1"];
        self.year2 = [deCoder decodeObjectForKey:@"EduModel_year2"];
        self.uid = [deCoder decodeObjectForKey:@"EduModel_uid"];
    }
    return self;
}
@end
