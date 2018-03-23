//
//  labsSelfList.m
//  Doctor
//
//  Created by MrZhang on 15/6/29.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "labsSelfListModel.h"

@implementation labsSelfListModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_lsid forKey:@"LabsSelfListModel_lsid"];
    [enCoder encodeObject:_name forKey:@"LabsSelfListModel_name"];
    [enCoder encodeObject:_name forKey:@"LabsSelfListModel_uid"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.lsid = [deCoder decodeObjectForKey:@"LabsSelfListModel_lsid"];
        self.name = [deCoder decodeObjectForKey:@"LabsSelfListModel_name"];
        self.name = [deCoder decodeObjectForKey:@"LabsSelfListModel_uid"];
    }
    return self;
}
@end
