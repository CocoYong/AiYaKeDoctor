//
//  UIColor+CWColor.m
//  宜人贷借款
//
//  Created by cuiw on 14-7-24.
//
//

#import "UIColor+CWColor.h"

@implementation UIColor (CWColor)
+ (UIColor *)hexColor:(NSString *)hexColor
{
	unsigned int red, green, blue, alpha;
	NSRange range;
	range.length = 2;
	@try {
		if ([hexColor hasPrefix:@"#"]) {
			hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
		}
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
		
		if ([hexColor length] > 6) {
			range.location = 6;
			[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
		} else {
            alpha = 100.0;
        }
    }
    @catch (NSException * e) {
        return [UIColor blackColor];
    }
    
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha/100.0f)];
}
@end
