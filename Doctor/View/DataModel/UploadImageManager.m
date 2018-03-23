//
//  UploadImageManager.m
//  Running
//
//  Created by chenchao on 14-9-4.
//

#import "UploadImageManager.h"

@implementation UploadImageManager
-(void)creatLoad
{
    allImageObjectArray = [[NSMutableArray alloc] init];
    
}
+(UploadImageManager*)share{
    static UploadImageManager* instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[UploadImageManager alloc]init];
        [instance creatLoad];
        
    });
    return instance;
}
-(void)addImageObject:(UploadImageObject *)object
{
    [allImageObjectArray addObject:object];
}

-(void)removeImageObject:(int)index
{
    if ([allImageObjectArray count]>index) {
        [allImageObjectArray removeObjectAtIndex:index];
    }
}
-(NSMutableArray *)getAllImageObject
{
    return allImageObjectArray;
}
-(void)cleanAllImageObject
{
    if (allImageObjectArray) {
        [allImageObjectArray removeAllObjects];
    }
}


@end
