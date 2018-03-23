//
//  CWHttpRequest.m
//  AnyLoan
//
//  Created by cuiw on 11/13/14.
//  Copyright (c) 2014 Creditease. All rights reserved.
//

#import "CWHttpRequest.h"
static NSString * const FORM_FLE_INPUT = @"file";
@interface CWHttpRequest ()
{
    NSOperationQueue *_operationQueen;
}
@end

@implementation CWHttpRequest

- (id)init {
    self = [super init];
    if (self) {
        _operationQueen = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)cancelQueen {
    if (_operationQueen) {
        [_operationQueen cancelAllOperations];
    }
}
- (void)JSONRequestOperationWithURL:(NSString *)urlString
                                                        path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                                            successBlock:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject))success
                                                   failBlock:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject))fail {
        NSURL *url = [NSURL URLWithString:urlString];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableDictionary *paramDictionary = [NSMutableDictionary parametersDictionary];
        for (NSString *key in [parameters allKeys]) {
            [paramDictionary setObject:parameters[key] forKey:key];
        }
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:paramDictionary];
        // 这里要做一个修正，以确保支持text/html格式contenttype的json数据
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        request.timeoutInterval = kTIME_OUT_SEC;
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:fail];
        // 单项SSL认证设置
        operation.allowsInvalidSSLCertificate = YES;
        [_operationQueen addOperation:operation];
}

-(id)JSONRequestOperationWithURL:(NSString *)urlString
                               path:(NSString *)path
                         parameters:(NSDictionary *)parameters {
    NSLog(@"网络指示器显示标记=====%d",  [AFNetworkActivityIndicatorManager sharedManager].isNetworkActivityIndicatorVisible);
    NSURL *url = [NSURL URLWithString:urlString];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableDictionary *paramDictionary = [NSMutableDictionary parametersDictionary];
    for (NSString *key in [parameters allKeys]) {
        [paramDictionary setObject:parameters[key] forKey:key];
    }
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:paramDictionary];
    // 这里要做一个修正，以确保支持text/html格式contenttype的json数据
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    request.timeoutInterval = kTIME_OUT_SEC;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    // 单项SSL认证设置
    operation.allowsInvalidSSLCertificate = YES;
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//         // Success happened here so do what ever you need in a async manner
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         //error occurred here in a async manner
//     }];
    [operation start];
    [operation waitUntilFinished];
    NSError *error = nil;
    id data = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:NSJSONReadingMutableLeaves error:&error];
    return data;
}
-(void)imageUploadWithUrl:(NSString*)urlString
                 fillPath:(NSString*)path
                parameters:(NSDictionary *)parameters
                  andData:(NSData*)fileData
                 mimeType:(NSString*)type
                 fileName:(NSString*)fileName
             successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                failBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fail
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",HOST_URL]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableDictionary *paramDictionary = [NSMutableDictionary parametersDictionary];
    for (NSString *key in [parameters allKeys]){
        [paramDictionary setObject:parameters[key] forKey:key];
    }
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:paramDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:type];
    }];
    request.timeoutInterval = kTIME_OUT_SEC;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
      [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"totalBytesWritten===%lld,totalBytesExpectedToWrite===%lld",totalBytesWritten,totalBytesExpectedToWrite);
    }];
    operation.allowsInvalidSSLCertificate = YES;
    [operation setCompletionBlockWithSuccess:success failure:fail];
    [_operationQueen addOperation:operation];
   

}
-(void)updateUserInfoSuccessBlock:(void(^)(NSInteger code,NSDictionary *data))success failBlock:(void(^)(NSInteger code,NSString *errorString))fail
{

}




+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     image:(UIImage *)image  // IN
                     picFileName: (NSString *)picFileName  // IN
{
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
//    if(picFilePath){
    
//        UIImage *image=image;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
//    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
//    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpg,image/gif, image/jpeg, image/png, image/pjpeg\r\n\r\n"];
//    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
//    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"result=====%@",result);
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        return result;
    }
    return nil;
}
@end
