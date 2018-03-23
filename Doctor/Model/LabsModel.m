//
//  LabsModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "LabsModel.h"

@implementation LabsModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_lid forKey:@"LabsModel_lid"];
    [enCoder encodeObject:_name forKey:@"LabsModel_name"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.lid = [deCoder decodeObjectForKey:@"LabsModel_lid"];
        self.name = [deCoder decodeObjectForKey:@"LabsModel_name"];
    }
    return self;
}
@end
