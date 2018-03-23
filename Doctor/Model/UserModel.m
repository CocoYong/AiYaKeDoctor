//
//  UserModel.m
//  YSProject
//
//  Created by cuiw on 15/6/6.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)enCoder {
    [enCoder encodeObject:_order99Num forKey:@"UserModel_order99Num"];
    [enCoder encodeObject:_address forKey:@"UserModel_address"];
    [enCoder encodeObject:_area3 forKey:@"UserModel_area3"];
    [enCoder encodeObject:_area3Name forKey:@"UserModel_area3Name"];
    [enCoder encodeObject:_caseList forKey:@"UserModel_caseList"];
    [enCoder encodeObject:_certCode forKey:@"UserModel_certCode"];
    [enCoder encodeObject:_company forKey:@"UserModel_company"];
    [enCoder encodeObject:_content forKey:@"UserModel_content"];
    [enCoder encodeObject:_createTime forKey:@"UserModel_createTime"];
    [enCoder encodeObject:_eduList forKey:@"UserModel_eduList"];
    [enCoder encodeObject:_hxPassword forKey:@"UserModel_hxPassword"];
    [enCoder encodeObject:_isWorkTime forKey:@"UserModel_isWorkTime"];
    [enCoder encodeObject:_labs forKey:@"UserModel_labs"];
    [enCoder encodeObject:_labsSelf forKey:@"UserModel_labsSelf"];
    [enCoder encodeObject:_labsSelfList forKey:@"UserModel_labsSelfList"];
    [enCoder encodeObject:_licenseList forKey:@"UserModel_licenseList"];
    [enCoder encodeObject:_loginTime forKey:@"UserModel_loginTime"];
    [enCoder encodeObject:_name forKey:@"UserModel_name"];
    [enCoder encodeObject:_pic forKey:@"UserModel_pic"];
    [enCoder encodeObject:_picUrl forKey:@"UserModel_picUrl"];
    [enCoder encodeObject:_positionLat forKey:@"UserModel_positionLat"];
    [enCoder encodeObject:_positionLng forKey:@"UserModel_positionLng"];
    [enCoder encodeObject:_serviceList forKey:@"UserModel_serviceList"];
    [enCoder encodeObject:_sex forKey:@"UserModel_sex"];
    [enCoder encodeObject:_status forKey:@"UserModel_status"];
    [enCoder encodeObject:_tel forKey:@"UserModel_tel"];
    [enCoder encodeObject:_title forKey:@"UserModel_title"];
    [enCoder encodeObject:_titleName forKey:@"UserModel_titleName"];
    [enCoder encodeObject:_totalCommentNum forKey:@"UserModel_totalCommentNum"];
    [enCoder encodeObject:_totalGrade forKey:@"UserModel_totalGrade"];
    [enCoder encodeObject:_totalGrade1 forKey:@"UserModel_totalGrade1"];
    [enCoder encodeObject:_totalGrade2 forKey:@"UserModel_totalGrade2"];
    [enCoder encodeObject:_totalGrade3 forKey:@"UserModel_totalGrade3"];
    [enCoder encodeObject:_totalOrderNum forKey:@"UserModel_totalOrderNum"];
    [enCoder encodeObject:_uid forKey:@"UserModel_uid"];
    [enCoder encodeObject:_userType forKey:@"UserModel_userType"];
    [enCoder encodeObject:_username forKey:@"UserModel_username"];
    [enCoder encodeObject:_workList forKey:@"UserModel_workList"];
    [enCoder encodeObject:_workTimeList forKey:@"UserModel_workTimeList"];
}
- (id)initWithCoder:(NSCoder *)deCoder {
    if (self = [super init]) {
        self.order99Num = [deCoder decodeObjectForKey:@"UserModel_order99Num"];
        self.address = [deCoder decodeObjectForKey:@"UserModel_address"];
        self.area3 = [deCoder decodeObjectForKey:@"UserModel_area3"];
        self.area3Name = [deCoder decodeObjectForKey:@"UserModel_area3Name"];
        self.caseList = [deCoder decodeObjectForKey:@"UserModel_caseList"];
        self.certCode = [deCoder decodeObjectForKey:@"UserModel_certCode"];
        self.company = [deCoder decodeObjectForKey:@"UserModel_company"];
        self.content = [deCoder decodeObjectForKey:@"UserModel_content"];
        self.createTime = [deCoder decodeObjectForKey:@"UserModel_createTime"];
        self.eduList = [deCoder decodeObjectForKey:@"UserModel_eduList"];
        self.hxPassword=[deCoder decodeObjectForKey:@"UserModel_hxPassword"];
        self.isWorkTime = [deCoder decodeObjectForKey:@"UserModel_isWorkTime"];
        self.labs = [deCoder decodeObjectForKey:@"UserModel_labs"];
        self.labsSelf = [deCoder decodeObjectForKey:@"UserModel_labsSelf"];
        self.labsSelfList = [deCoder decodeObjectForKey:@"UserModel_labsSelfList"];
        self.licenseList = [deCoder decodeObjectForKey:@"UserModel_licenseList"];
        self.loginTime = [deCoder decodeObjectForKey:@"UserModel_loginTime"];
        self.name = [deCoder decodeObjectForKey:@"UserModel_name"];
        self.pic = [deCoder decodeObjectForKey:@"UserModel_pic"];
        self.picUrl = [deCoder decodeObjectForKey:@"UserModel_picUrl"];
        self.positionLat = [deCoder decodeObjectForKey:@"UserModel_positionLat"];
        self.positionLng = [deCoder decodeObjectForKey:@"UserModel_positionLng"];
        self.serviceList = [deCoder decodeObjectForKey:@"UserModel_serviceList"];
        self.sex = [deCoder decodeObjectForKey:@"UserModel_sex"];
        self.status = [deCoder decodeObjectForKey:@"UserModel_status"];
        self.tel = [deCoder decodeObjectForKey:@"UserModel_tel"];
        self.title = [deCoder decodeObjectForKey:@"UserModel_title"];
        self.titleName = [deCoder decodeObjectForKey:@"UserModel_titleName"];
        self.totalCommentNum = [deCoder decodeObjectForKey:@"UserModel_totalCommentNum"];
        self.totalGrade = [deCoder decodeObjectForKey:@"UserModel_totalGrade"];
        self.totalGrade1 = [deCoder decodeObjectForKey:@"UserModel_totalGrade1"];
        self.totalGrade2 = [deCoder decodeObjectForKey:@"UserModel_totalGrade2"];
        self.totalGrade3 = [deCoder decodeObjectForKey:@"UserModel_totalGrade3"];
        self.totalOrderNum = [deCoder decodeObjectForKey:@"UserModel_totalOrderNum"];
        self.uid = [deCoder decodeObjectForKey:@"UserModel_uid"];
        self.userType = [deCoder decodeObjectForKey:@"UserModel_userType"];
        self.username = [deCoder decodeObjectForKey:@"UserModel_username"];
        self.workList = [deCoder decodeObjectForKey:@"UserModel_workList"];
        self.workTimeList = [deCoder decodeObjectForKey:@"UserModel_workTimeList"];
    }
    return self;
}
@end
