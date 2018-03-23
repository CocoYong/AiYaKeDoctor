//
//  LicenseModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "LicenseModel.h"

@implementation LicenseModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_lid forKey:@"LicenseModel_lid"];
    [enCoder encodeObject:_pic forKey:@"LicenseModel_pic"];
    [enCoder encodeObject:_picUrl forKey:@"LicenseModel_picUrl"];
    [enCoder encodeObject:_uid forKey:@"LicenseModel_uid"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.lid = [deCoder decodeObjectForKey:@"LicenseModel_lid"];
        self.pic = [deCoder decodeObjectForKey:@"LicenseModel_pic"];
        self.picUrl = [deCoder decodeObjectForKey:@"LicenseModel_picUrl"];
        self.uid = [deCoder decodeObjectForKey:@"LicenseModel_uid"];
    }
    return self;
}
@end
