//
//  ParserCenter.m
//  YSProject
//
//  Created by cuiw on 15/6/8.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#import "ParserCenter.h"
#import "CaseModel.h"
#import "EduModel.h"
#import "LabsModel.h"
#import "LabsSelfModel.h"
#import "LicenseModel.h"
#import "labsSelfListModel.h"
#import "ServiceModel.h"
#import "EvaluateDataModel.h"
#import "WorkTimeModel.h"
#import "TimeModel.h"
@implementation ParserCenter
- (void)parserUser:(NSMutableDictionary *)dic {
    UserManager *userManager = [UserManager currentUserManager];
    userManager.user.order99Num = [dic valueForKeyWithOutNSNull:@"Order99Num"];
    userManager.user.address = [dic valueForKeyWithOutNSNull:@"address"];
    userManager.user.area3 = [dic valueForKeyWithOutNSNull:@"area3"];
    userManager.user.area3Name = [dic valueForKeyWithOutNSNull:@"area3Name"];
    NSArray *caseList = [dic valueForKeyWithOutNSNull:@"caseList"];
    NSMutableArray *caseListArray = [NSMutableArray new];
    for (int i = 0; i < [caseList count]; i++) {
        NSMutableDictionary *dic = caseList[i];
        CaseModel *caseModel = [[CaseModel alloc] init];
        caseModel.content = [dic valueForKeyWithOutNSNull:@"content"];
        caseModel.createTime = [dic valueForKeyWithOutNSNull:@"createTime"];
        caseModel.cid = [dic valueForKeyWithOutNSNull:@"id"];
        caseModel.pic1 = [dic valueForKeyWithOutNSNull:@"pic1"];
        caseModel.pic1Url = [dic valueForKeyWithOutNSNull:@"pic1Url"];
        caseModel.pic2 = [dic valueForKeyWithOutNSNull:@"pic2"];
        caseModel.pic2Url = [dic valueForKeyWithOutNSNull:@"pic2Url"];
        caseModel.pic3 = [dic valueForKeyWithOutNSNull:@"pic3"];
        caseModel.pic3Url = [dic valueForKeyWithOutNSNull:@"pic3Url"];
        caseModel.uid = [dic valueForKeyWithOutNSNull:@"uid"];
        [caseListArray addObject:caseModel];
    }
    userManager.user.caseList = caseListArray;
    userManager.user.certCode = [dic valueForKeyWithOutNSNull:@"certCode"];
    userManager.user.company = [dic valueForKeyWithOutNSNull:@"company"];
    userManager.user.content = [dic valueForKeyWithOutNSNull:@"content"];
    
    NSArray *eduList = [dic valueForKeyWithOutNSNull:@"eduList"];
    NSMutableArray *eduListArray = [NSMutableArray new];
    for (int i = 0; i < [eduList count]; i++) {
        NSMutableDictionary *dic = eduList[i];
        EduModel *eduModel = [[EduModel alloc] init];
        eduModel.content = [dic valueForKeyWithOutNSNull:@"content"];
        eduModel.eid = [dic valueForKeyWithOutNSNull:@"id"];
        eduModel.month1 = [dic valueForKeyWithOutNSNull:@"month1"];
        eduModel.month2 = [dic valueForKeyWithOutNSNull:@"month2"];
        eduModel.name = [dic valueForKeyWithOutNSNull:@"name"];
        eduModel.uid = [dic valueForKeyWithOutNSNull:@"uid"];
        eduModel.year1 = [dic valueForKeyWithOutNSNull:@"year1"];
        eduModel.year2 = [dic valueForKeyWithOutNSNull:@"year2"];
        [eduListArray addObject:eduModel];
    }
    userManager.user.eduList = eduListArray;
    userManager.user.hxPassword = [dic valueForKeyWithOutNSNull:@"hxPassword"];
    userManager.user.isWorkTime = [dic valueForKeyWithOutNSNull:@"isWorkTime"];
    
    NSArray *labs = [dic valueForKeyWithOutNSNull:@"labs"];
    NSMutableArray *labsArray = [NSMutableArray new];
    for (int i = 0; i < [labs count]; i++) {
        NSMutableDictionary *dic = labs[i];
        LabsModel *labsModel = [[LabsModel alloc] init];
        labsModel.lid = [dic valueForKeyWithOutNSNull:@"id"];
        labsModel.name = [dic valueForKeyWithOutNSNull:@"name"];
        [labsArray addObject:labsModel];
    }
    userManager.user.labs = labsArray;
    
    NSArray *labsSelf = [dic valueForKeyWithOutNSNull:@"labsSelf"];
    NSMutableArray *labsSelfArray = [NSMutableArray new];
    for (int i = 0; i < [labsSelf count]; i++) {
        NSMutableDictionary *dic = labsSelf[i];
         LabsSelfModel*labsModel = [[LabsSelfModel alloc] init];
        labsModel.lid = [dic valueForKeyWithOutNSNull:@"id"];
        labsModel.name = [dic valueForKeyWithOutNSNull:@"name"];
        labsModel.uid = [dic valueForKeyWithOutNSNull:@"uid"];
        [labsSelfArray addObject:labsModel];
    }
    userManager.user.labsSelf = labsSelfArray;
    
    NSArray *labsSelfList = [dic valueForKeyWithOutNSNull:@"labsSelfList"];
    NSMutableArray *labsSelfListArray = [NSMutableArray new];
    for (int i = 0; i < [labsSelfList count]; i++) {
        NSMutableDictionary *dic = labsSelfList[i];
        labsSelfListModel *labsModel = [[labsSelfListModel alloc] init];
        labsModel.lsid = [dic valueForKeyWithOutNSNull:@"id"];
        labsModel.name = [dic valueForKeyWithOutNSNull:@"name"];
        labsModel.uid = [dic valueForKeyWithOutNSNull:@"uid"];
        [labsSelfListArray addObject:labsModel];
    }
    userManager.user.labsSelfList = labsSelfListArray;
    
    NSArray *licenseList = [dic valueForKeyWithOutNSNull:@"licenseList"];
    NSMutableArray *licenseListArray = [NSMutableArray new];
    for (int i = 0; i < [licenseList count]; i++) {
        NSMutableDictionary *dic = licenseList[i];
        LicenseModel *licenseModel = [[LicenseModel alloc] init];
        licenseModel.lid = [dic valueForKeyWithOutNSNull:@"id"];
        licenseModel.pic = [dic valueForKeyWithOutNSNull:@"pic"];
        licenseModel.picUrl = [dic valueForKeyWithOutNSNull:@"picUrl"];
        licenseModel.uid = [dic valueForKeyWithOutNSNull:@"uid"];
        [licenseListArray addObject:licenseModel];
    }
    userManager.user.licenseList = licenseListArray;
    
    userManager.user.loginTime = [dic valueForKeyWithOutNSNull:@"loginTime"];
    userManager.user.name = [dic valueForKeyWithOutNSNull:@"name"];
    userManager.user.pic = [dic valueForKeyWithOutNSNull:@"pic"];
    userManager.user.picUrl = [dic valueForKeyWithOutNSNull:@"picUrl"];
    userManager.user.positionLat = [dic valueForKeyWithOutNSNull:@"positionLat"];
    userManager.user.positionLng = [dic valueForKeyWithOutNSNull:@"positionLng"];
    
    NSArray *serviceList = [dic valueForKeyWithOutNSNull:@"serviceList"];
    NSMutableArray *serviceListArray = [NSMutableArray new];
    for (int i = 0; i < [serviceList count]; i++) {
        NSMutableDictionary *dic = serviceList[i];
        ServiceModel *serviceModel = [[ServiceModel alloc] init];
        serviceModel.content = [dic valueForKeyWithOutNSNull:@"content"];
        serviceModel.feeMax = [dic valueForKeyWithOutNSNull:@"feeMax"];
        serviceModel.feeMin = [dic valueForKeyWithOutNSNull:@"feeMin"];
        serviceModel.sid = [dic valueForKeyWithOutNSNull:@"id"];
        serviceModel.type = [dic valueForKeyWithOutNSNull:@"type"];
        serviceModel.typeName = [dic valueForKeyWithOutNSNull:@"typeName"];
        serviceModel.uid = [dic valueForKeyWithOutNSNull:@"uid"];
        [serviceListArray addObject:serviceModel];
    }
    userManager.user.serviceList = serviceListArray;
    
    //可用工作时间列表
    NSArray *workTimeList = [dic valueForKeyWithOutNSNull:@"workTimeList"];
    NSMutableArray *workTimeListArray = [NSMutableArray new];
    for (int i = 0; i < [workTimeList count]; i++) {
        NSMutableDictionary *dic = workTimeList[i];
        WorkTimeModel *workTimeModel = [[WorkTimeModel alloc] init];
        workTimeModel.date1 = [dic valueForKeyWithOutNSNull:@"date1"];
        workTimeModel.date2 = [dic valueForKeyWithOutNSNull:@"date2"];
        NSArray *timeListArray=[dic valueForKeyWithOutNSNull:@"time"];
        NSMutableArray *timeArray = [NSMutableArray new];
        for (int j=0; j<timeListArray.count; j++) {
            NSDictionary *tempDic=timeListArray[j];
            TimeModel *timeModel=[[TimeModel alloc]init];
            timeModel.time1=[tempDic valueForKeyWithOutNSNull:@"time1"];
            timeModel.time2=[tempDic valueForKeyWithOutNSNull:@"time2"];
            [timeArray addObject:timeModel];
        }
        workTimeModel.time = timeArray;
      [workTimeListArray addObject:workTimeModel];
    }
    userManager.user.workTimeList = workTimeListArray;

    
    
    userManager.user.sex = [dic valueForKeyWithOutNSNull:@"sex"];
    userManager.user.status = [dic valueForKeyWithOutNSNull:@"status"];
    userManager.user.tel = [dic valueForKeyWithOutNSNull:@"tel"];
    userManager.user.title = [dic valueForKeyWithOutNSNull:@"title"];
    userManager.user.titleName = [dic valueForKeyWithOutNSNull:@"titleName"];
    userManager.user.totalCommentNum = [dic valueForKeyWithOutNSNull:@"totalCommentNum"];
    userManager.user.totalGrade = [dic valueForKeyWithOutNSNull:@"totalGrade"];
    userManager.user.totalGrade1 = [dic valueForKeyWithOutNSNull:@"totalGrade1"];
    userManager.user.totalGrade2 = [dic valueForKeyWithOutNSNull:@"totalGrade2"];
    userManager.user.totalGrade3 = [dic valueForKeyWithOutNSNull:@"totalGrade3"];
    userManager.user.totalOrderNum = [dic valueForKeyWithOutNSNull:@"totalOrderNum"];
    userManager.user.uid = [dic valueForKeyWithOutNSNull:@"uid"];
    userManager.user.userType = [dic valueForKeyWithOutNSNull:@"userType"];
    userManager.user.username = [dic valueForKeyWithOutNSNull:@"username"];
    [userManager synchronize];
}
-(NSMutableArray*)parserEvaluateData:(NSArray*)dataArray
{
    NSMutableArray *mutableArray=[NSMutableArray array];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *dic=dataArray[i];
        EvaluateDataModel *model=[[EvaluateDataModel alloc]init];
        model.age=[dic valueForKeyWithOutNSNull:@"age"];
        
    }
    
    return dataArray;
}
@end
