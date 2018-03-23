//
//  UIBlockActionSheet.h
//  AnyLoan
//
//  Created by cuiw on 11/29/14.
//  Copyright (c) 2014 Creditease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBlockActionSheet : UIActionSheet
@property (nonatomic, copy) TouchBlock otherBlock;
@property (nonatomic, copy) TouchBlock cancelBlock;
- (id)initWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSString *)otherButtonTitle
                               delegate:(id)delegate
                            cancelBlock:(TouchBlock)cancelBlock
           otherBlock:(TouchBlock)otherBlock;
@end
