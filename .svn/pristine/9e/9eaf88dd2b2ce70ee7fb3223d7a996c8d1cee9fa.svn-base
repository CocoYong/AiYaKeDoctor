
#import "ValidationUtil.h"
#define IS_CH_SYMBOL(chr) (((chr)>=0x4e00&&(chr)<=0x9fff)?YES:NO)

//#define IS_CH_SYMBOL(chr) (((chr)>127)?YES:NO)

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}

BOOL containsChinese (char ch) {
    
        int a = ch;
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
    return NO;
}

@implementation ValidationUtil

+ (BOOL)isFigureNumber:(NSString *)str
{
    const char *cvalue = [str UTF8String];
    unsigned long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return NO;
        }
    }
    return YES;
}

+ (BOOL)validateIDCard:(NSString *)iDCardString {
    NSString *iDCardRegex = @"^[\\d|x|X]+$";
    NSPredicate *iDCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", iDCardRegex];
    return [iDCardPredicate evaluateWithObject:iDCardString];
}

+ (BOOL)validateEmail:(NSString *)emailString {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSString *emailRegex = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:emailString];
}

+ (BOOL)validateDigital:(NSString*)digitalString {
    long length = [digitalString length];
    
    int index = 0;
    for (index = 0; index < length; index++)
    {
        unichar endCharacter = [digitalString characterAtIndex:index];
        if (endCharacter >= '0' && endCharacter <= '9')
            continue;
        else
            return NO;
    }    
    return YES;
    
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString *MOBILE = @"^1(3[0-9]|5[0-9]|4[0-9]|8[0-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString *CT = @"^1((33|81|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
//        return YES;
//    } else {
//        return NO;
//    }
    NSString *MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (BOOL)isCompanyNumber:(NSString *)str
{
//    NSString * PHS = @"^0\\d{2,3}-\\d{7,8}-\\d{3,5}|0\\d{2,3}-\\d{7,8}$";
    NSString * PHS = @"^0\\d{2,3}-\\d{7,8}(-\\d{3,5})?$";
    NSRange range=[str rangeOfString:@"-"];
    if (range.location==NSNotFound) {
        return NO;
    }
    else
    {
        
        NSPredicate *regexTestCall=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
        if ([regexTestCall evaluateWithObject:str]==YES) {
            return YES;
        }
        return NO;
    }
}

/**
 * 功能:验证身份证是否合法 只有18位的通过
 * 参数:输入的身份证号
 */
+ (BOOL)chk18PaperIdOnly18:(NSString *)sPaperId {
    if ([sPaperId length] != 18) {
        return NO;
    }
    return [[self class] chk18PaperId:sPaperId];
}

/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
+ (BOOL)chk18PaperId:(NSString *)sPaperId {
    //判断位数
    if ([sPaperId length] < 15 ||[sPaperId length] > 18) {
        
        return NO;
    }
    
    NSString *carid = sPaperId;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15) {
        
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
        
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![ValidationUtil areaCode:sProvince]) {
        
        return NO;
    }
    
    //判断年月日是否有效
    
    //年份
    int strYear = [[ValidationUtil getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[ValidationUtil getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[ValidationUtil getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        
        return NO;
    }
    
    const char *PaperId  = [[carid uppercaseString] UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger)value2 {
    return [str substringWithRange:NSMakeRange(value1,value2)];
}

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+(BOOL)areaCode:(NSString *)code {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
    }
    return YES;
}

+ (BOOL) isValidNumberQQ:(NSString*)value{
    if (value==nil) {
        return NO;
    }
    const char *cvalue = [value UTF8String];
    unsigned long len = strlen(cvalue);
    if (len>13||len<5) {
        return NO;
    }
    else
    {
        for (int i = 0; i < len; i++) {
            if(!isNumber(cvalue[i])){
                return NO;
            }
        }
        if ([value intValue]==0) {
            return NO;
        }
        return YES;
    }
    
}

+ (BOOL) isBankNumber:(NSString *)value
{
    if (value==nil) {
        return NO;
    }
    if (value.length<15||value.length>19) {
        return NO;
    }
    else
    {
        const char *cvalue = [value UTF8String];
        unsigned long len = strlen(cvalue);
        for (int i = 0; i < len; i++) {
            if(!isNumber(cvalue[i])){
                return NO;
            }
        }
        return YES;
    }
}

+ (BOOL) isNameStr:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    if (str.length<2||str.length>20)
    {
        return NO;
    }
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if(!IS_CH_SYMBOL(a)&&a!=8226)
        {
            NSLog(@"=====%d",a);
            return NO;
        }
        
    }
    return YES;
}
+(BOOL) isChineseName:(NSString *)str
{
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if(!IS_CH_SYMBOL(a)&&a!=8226)
        {
            return NO;
        }
        
    }
    return YES;
}

+ (BOOL) isLinkManName:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    
    NSString *PHS=@"^[A-Za-z0-9\u4E00-\u9FA5]+$";
    NSPredicate *regStr=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([regStr evaluateWithObject:str]!=YES) {
        return NO;
    }
    if (str.length<2||str.length>20) {
        return NO;
    }
    else
        return YES;
}

+ (BOOL) isCompanyName:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    NSString *PHS=@"^[A-Za-z0-9\u4E00-\u9FA5-()（）]+$";
    NSPredicate *regStr=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([regStr evaluateWithObject:str]!=YES) {
        return NO;
    }

    if (str.length<4||str.length>30) {
        return NO;
    }
    return YES;
}

+ (BOOL) isDetailAddressStr:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    NSString *PHS=@"^[A-Za-z0-9\u4E00-\u9FA5-]+$";
    NSPredicate *regStr=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([regStr evaluateWithObject:str]!=YES) {
        return NO;
    }

    if (str.length<4||str.length>60) {
        return NO;
    }
    return YES;
}

+ (BOOL)isJobDepartStr:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    
    NSString *PHS=@"^[A-Za-z0-9\u4E00-\u9FA5]+$";
    NSPredicate *regStr=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([regStr evaluateWithObject:str]!=YES) {
        return NO;
    }
    if (str.length<2||str.length>20) {
        return NO;
    }
    else
        return YES;
}

+ (BOOL) isSub_barnchBankStr:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    if (str.length<4||str.length>30) {
        return NO;
    }
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if(!IS_CH_SYMBOL(a))
            return NO;
    }
    return YES;
}

+ (BOOL) isCardLimitStr:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    if (str.length>6) {
        return NO;
    }
    const char *cvalue = [str UTF8String];
    unsigned long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return NO;
        }
    }
    return YES;
}

+ (BOOL) isLoanMoneyStr:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    if (str.length>6) {
        return NO;
    }
    const char *cvalue = [str UTF8String];
    unsigned long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return NO;
        }
    }
    if ([str intValue]<10000) {
        return NO;
    }
    if ([str intValue]%100!=0)
    {
        return NO;
    }
    else
    {
       return YES;
    }
    
}

+ (BOOL)isAnnualIncomeStr:(NSString *)str
{
    if (str == nil) {
        return NO;
    }
    if (str.length > 7) {
        return NO;
    }
    const char *cvalue = [str UTF8String];
    unsigned long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if (!isNumber(cvalue[i])) {
            return NO;
        }
    }
    return YES;
}

@end
