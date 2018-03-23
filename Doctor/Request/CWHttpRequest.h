//
//  CWHttpRequest.h
//  AnyLoan
//
//  Created by cuiw on 11/13/14.
//  Copyright (c) 2014 Creditease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"
@interface CWHttpRequest : NSObject

/**
 *  JSON异步请求
 *
 *  @param url
 *  @param path
 *  @param parameters
 *  @param success
 *  @param fail
 */
- (void)JSONRequestOperationWithURL:(NSString *)urlString
                               path:(NSString *)path
                         parameters:(NSDictionary *)parameters
                       successBlock:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject))success
                          failBlock:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject))fail;
/**
 *  JSON同步请求
 *
 *  @param urlString
 *  @param path
 *  @param parameters
 *
 *  @return 
 */
- (id)JSONRequestOperationWithURL:(NSString *)urlString
                             path:(NSString *)path
                       parameters:(NSDictionary *)parameters;

-(void)imageUploadWithUrl:(NSString*)urlString
                 fillPath:(NSString*)path
               parameters:(NSDictionary *)parameters
                  andData:(NSData*)fileData
                 mimeType:(NSString*)type
                 fileName:(NSString*)fileName
             successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                failBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fail;
/**
 *  关闭队列
 */

- (void)cancelQueen;

+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     image:(UIImage *)image  // IN
                     picFileName: (NSString *)picFileName;
@end
