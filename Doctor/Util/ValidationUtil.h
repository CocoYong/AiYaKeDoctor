
#import <Foundation/Foundation.h>

@interface ValidationUtil : NSObject

+ (BOOL)isFigureNumber:(NSString *)str;

+ (BOOL)validateIDCard:(NSString *)iDCardString;

+ (BOOL)validateEmail:(NSString *)email;

+ (BOOL)validateDigital:(NSString*)digitalString;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)isCompanyNumber:(NSString *)str;

+ (BOOL)chk18PaperId:(NSString *)sPaperId;

+ (BOOL)isValidNumberQQ:(NSString*)value;

+ (BOOL)isBankNumber:(NSString *)value;

+ (BOOL)isNameStr:(NSString *)str;

+ (BOOL)isLinkManName:(NSString *)str;

+ (BOOL)isJobDepartStr:(NSString *)str;

+ (BOOL)isCompanyName:(NSString *)str;

+ (BOOL)isDetailAddressStr:(NSString *)str;

+ (BOOL)isSub_barnchBankStr:(NSString *)str;

+ (BOOL)isCardLimitStr:(NSString *)str;

+ (BOOL)isLoanMoneyStr:(NSString *)str;

+ (BOOL)isChineseName:(NSString *)str;

+ (BOOL)isAnnualIncomeStr:(NSString *)str;

+ (BOOL)chk18PaperIdOnly18:(NSString *)sPaperId;


@end
