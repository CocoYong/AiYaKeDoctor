//
//  UIBlockActionSheet.m
//  AnyLoan
//
//  Created by cuiw on 11/29/14.
//  Copyright (c) 2014 Creditease. All rights reserved.
//

#import "UIBlockActionSheet.h"

@implementation UIBlockActionSheet

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle delegate:(id)delegate cancelBlock:(TouchBlock)cancelBlock otherBlock:(TouchBlock)otherBlock {
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitle, nil];
    if (self) {
        self.cancelBlock = cancelBlock;
        self.otherBlock = otherBlock;
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        self.cancelBlock();
    else if (buttonIndex == 1)
        self.otherBlock();
}
@end
