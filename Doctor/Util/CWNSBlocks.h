//
//  CWNSBlocks.h
//  宜人贷借款
//
//  Created by cuiw on 14-8-9.
//
//

#ifndef ______CWNSBlocks_h
#define ______CWNSBlocks_h

typedef void (^NSCompletionBlock) (id result, NSError * error);
typedef void (^NSResultBlock) (id result);
typedef void (^NSErrorBlock) (NSError* error);
typedef void (^NSVoidBlock) (void);
typedef void (^NSObjectIndexBlock) (id object, NSInteger index);
typedef id (^NSObjectTransformBlock) (id object);
typedef void (^TouchBlock) (void);
typedef void (^ActionBlock) (UITextField *textField);
#endif
