//
//  ServiceModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_content forKey:@"ServiceModel_content"];
    [enCoder encodeObject:_feeMax forKey:@"ServiceModel_feeMax"];
    [enCoder encodeObject:_feeMin forKey:@"ServiceModel_feeMin"];
    [enCoder encodeObject:_sid forKey:@"ServiceModel_sid"];
    [enCoder encodeObject:_type forKey:@"ServiceModel_type"];
    [enCoder encodeObject:_typeName forKey:@"ServiceModel_typeName"];
    [enCoder encodeObject:_uid forKey:@"ServiceModel_uid"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.content = [deCoder decodeObjectForKey:@"ServiceModel_content"];
        self.feeMax = [deCoder decodeObjectForKey:@"ServiceModel_feeMax"];
        self.feeMin = [deCoder decodeObjectForKey:@"ServiceModel_feeMin"];
        self.sid = [deCoder decodeObjectForKey:@"ServiceModel_sid"];
        self.type = [deCoder decodeObjectForKey:@"ServiceModel_type"];
        self.typeName = [deCoder decodeObjectForKey:@"ServiceModel_typeName"];
        self.uid = [deCoder decodeObjectForKey:@"ServiceModel_uid"];
    }
    return self;
}
@end
