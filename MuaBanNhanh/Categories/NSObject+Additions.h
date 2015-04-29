//
//  NSObject+Additions.h
//
//  Created by Jesper Särnesjö on 2010-05-29.
//  Copyright 2010 Cartomapic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Additions)

- (id)ifKindOfClass:(Class)c;

+ (void)exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel;

- (NSString *)getCurrentSSID;
- (BOOL)use3g;

@end
