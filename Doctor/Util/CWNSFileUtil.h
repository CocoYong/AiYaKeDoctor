//
//  CWNSFileUtil.h
//
//  Created by cuiwei on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSettingFile @"settings.plist"

@interface CWNSFileUtil : NSObject

+ (id)sharedInstance;

- (void)setUserDefaults:(id)object key:(NSString*)key;

- (id)getUserDefaultsForKey:(NSString*)key;

- (id)getUserDefaultsArrayForKey:(NSString*)key;

- (BOOL)setNSModelToUserDefaults:(id)object withKey:(NSString *)key;
- (id)getNSModelFromUserDefaultsWithKey:(NSString *)key;

- (BOOL)setCustomModelToUserDefaults:(id)object withKey:(NSString *)key;
- (id)getCustomModelFromUserDefatulesWithKey:(NSString *)key;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+ (NSData *) image2DataURL: (UIImage *) image;
+(NSString *) md5: (NSString *) inPutText;
@end