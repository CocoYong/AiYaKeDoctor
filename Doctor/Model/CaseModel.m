//
//  CaseModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "CaseModel.h"

@implementation CaseModel
- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_content forKey:@"CaseModel_content"];
    [enCoder encodeObject:_content forKey:@"CaseModel_createTime"];
    [enCoder encodeObject:_cid forKey:@"CaseModel_cid"];
    [enCoder encodeObject:_pic1 forKey:@"CaseModel_pic1"];
    [enCoder encodeObject:_pic1Url forKey:@"CaseModel_pic1Url"];
    [enCoder encodeObject:_pic2 forKey:@"CaseModel_pic2"];
    [enCoder encodeObject:_pic2Url forKey:@"CaseModel_pic2Url"];
    [enCoder encodeObject:_pic3 forKey:@"CaseModel_pic3"];
    [enCoder encodeObject:_pic3Url forKey:@"CaseModel_pic3Url"];
    [enCoder encodeObject:_uid forKey:@"CaseModel_uid"];
}

- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.content = [deCoder decodeObjectForKey:@"CaseModel_content"];
        self.content = [deCoder decodeObjectForKey:@"CaseModel_createTime"];
        self.cid = [deCoder decodeObjectForKey:@"CaseModel_cid"];
        self.pic1 = [deCoder decodeObjectForKey:@"CaseModel_pic1"];
        self.pic1Url = [deCoder decodeObjectForKey:@"CaseModel_pic1Url"];
        self.pic2 = [deCoder decodeObjectForKey:@"CaseModel_pic2"];
        self.pic2Url = [deCoder decodeObjectForKey:@"CaseModel_pic2Url"];
        self.pic3 = [deCoder decodeObjectForKey:@"CaseModel_pic3"];
        self.pic3Url = [deCoder decodeObjectForKey:@"CaseModel_pic3Url"];
        self.uid = [deCoder decodeObjectForKey:@"CaseModel_uid"];
    }
    return self;
}
@end
