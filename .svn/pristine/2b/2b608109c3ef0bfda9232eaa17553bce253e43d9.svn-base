//
//  NSDictionary+CWDictionary.m
//  
//
//  Created by cuiw on 12/10/13.
//
//

#import "NSDictionary+CWDictionary.h"

@implementation NSDictionary (CWDictionary)

- (id)valueForKeyWithOutNSNull:(NSString *)key {
    id value = [self valueForKey:key];
    return [value class] != [NSNull class] ? value : nil;
}

+ (NSMutableDictionary *)parametersDictionary {
    NSMutableDictionary *parametersDictionary = [[NSMutableDictionary alloc] init];
    [parametersDictionary setObject:@"0c5a3e8915871b710c2cc98073748424" forKey:@"AccessKey"];
    [parametersDictionary setObject:@"" forKey:@"SessionID"];
    return parametersDictionary;
}

@end
