//
//  UploadImageObject.h
//  Running
//
//  Created by chenchao on 14-9-4.
//

#import <Foundation/Foundation.h>
@protocol uploadImageFinishDelegate;
@interface UploadImageObject : NSObject
{
    UIImage *smallImage;
    UIImage *originalImage;
    NSString *imageName;
    NSString *type;
    NSString *fileName;
}
@property (strong,nonatomic)UIImage *smallImage;
@property (strong,nonatomic)UIImage *originalImage;
@property (strong,nonatomic)NSString *imageName;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *fileName;
@end

