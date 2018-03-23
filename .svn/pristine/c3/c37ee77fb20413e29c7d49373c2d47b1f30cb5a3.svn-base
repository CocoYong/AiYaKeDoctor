//
//  LabsSelfModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "LabsSelfModel.h"

@implementation LabsSelfModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_lid forKey:@"LabsSelfModel_lid"];
    [enCoder encodeObject:_name forKey:@"LabsSelfModel_name"];
     [enCoder encodeObject:_name forKey:@"LabsSelfModel_uid"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.lid = [deCoder decodeObjectForKey:@"LabsSelfModel_lid"];
        self.name = [deCoder decodeObjectForKey:@"LabsSelfModel_name"];
        self.name = [deCoder decodeObjectForKey:@"LabsSelfModel_uid"];
    }
    return self;
}
@end
