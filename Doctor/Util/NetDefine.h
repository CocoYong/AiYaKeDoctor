//
//  NetDefine.h
//  YSProject
//
//  Created by cuiw on 15/6/4.
//  Copyright (c) 2015年 cuiw. All rights reserved.
//

#define SYSTEMERRORSTRING @"系统异常，请稍候再试"
#define SYSTEMBUSYSTRING @"系统繁忙，请稍候再试"
#define NETERRORSTRING @"网络异常，请稍候再试"
#define NETNOTAVAILABLESTRING @"当前网络不可用，请检查你的网络设置"

#define Index_URL @"common/dict/index" // 获取普通字典数据
#define SendCode_URL @"common/sms/sendCode" // 发送手机短信码
#define Sysval_URL @"common/dict/sysval" // 获取系统参数

#define Login_URL @"user/index/login" // 用户登录
#define Verificat_Login @"user/index/smsLogin" //验证码登录
#define Reg_URL @"user/doctor/reg" // 用户注册1
#define Reg2_URL @"user/doctor/reg2" // 用户注册2
#define EditUserInfo @"user/doctor/editInfo"//修改用户基础信息
#define AddLicence @"user/doctor/addLicense"//添加执照图片记录
#define DeletLicence @"user/doctor/delLicense"//删除执照图片记录
#define AddEducationInfo @"user/doctor/edu"//添加、编辑教育经历记录
#define DeletEducationInfo @"user/doctor/delEdu" //删除教育经理
#define AddAndEditWorkInfo @"user/doctor/work"//添加编辑工作经历
#define DeletWorkInfo @"user/doctor/delWork"//删除工作经历
#define AddAndEditService @"user/doctor/service"//添加编辑服务项目记录
#define DeletService @"user/doctor/delService"//删除服务项目记录
#define AddAndEditEcase @"user/doctor/ECase" //添加编辑案例记录
#define DeletCase @"user/doctor/delCase"//删除案例记录
#define AddAndEditlabs @"user/doctor/labs"
#define DeletLabs @"user/doctor/delLabs"
#define SetLabs @"user/doctor/setSCLabs"
#define ReqFriendNewNum @"user/doctor/reqFriendNewNum"
#define GetReqFriend @"user/doctor/getReqFriend"
#define DealFriend @"user/doctor/doFriend"
#define GetFiend @"user/doctor/getFriend"
#define DeletFriend @"user/doctor/delFriend"
#define DealOrder @"user/doctor/doOrder"
#define ResetTime @"user/doctor/resetOrderTime"
#define FinishOrder @"user/doctor/finishOrder"
#define CommentOrder @"user/doctor/commentOrder"
#define SearchOrder @"user/doctor/searchOrder"
#define OrderNewNum @"user/doctor/orderNewNum"
#define SetWorkTime @"user/doctor/setWorkTime"
#define DeletWorkTime @"user/doctor/delWorkTime"
#define IsOnline  @"user/index/isOnline"
#define isOrder @"user/index/isOrder"

//公用接口
#define ChangePassWord @"user/index/password"//修改密码
#define GetSpecialUserInfo @"user/index/userInfo"//获取指定用户信息
#define Post_Interface @"user/index/uploadFile" //上传文件专用接口
#define Update_UserImage @"user/index/avatar"//用户更新图像
#define WorkTimeData @"common/dict/workTime"//工作时间段数据
#define DoctorIsFree @"user/index/isFree" //医生在指定时间段可否预约
#define WorkTimeOrderNum @"user/index/workTimeOrderNum" //查询医生日期段可否预约
#define GetWorkTimeByDay  @"user/index/getWorkTimeByDay"//查询医生工作时间段
#define GetMsg @"user/index/getMsg"//获取系统公告信息
#define UnreadMsgNum @"user/index/unreadMsgNum"//获取未读信息
#define ReadMsg @"user/index/readMsg"//读取公告
