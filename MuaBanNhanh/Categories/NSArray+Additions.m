//
//  NSArray+NSArray_Additions.m
//  Aurora
//
//  Created by Seivan Heidari on 1/27/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)paginatedWithNumberOfObjectsPerPage:(NSUInteger)numberOfObjects {
  NSMutableArray *pagedArticles = [NSMutableArray array];
  
  __block NSMutableArray *articlesPerPage = [NSMutableArray array];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    [articlesPerPage addObject:obj];
    BOOL shouldAddArticlesToPage = ( (idx > 0 && ((idx+1) % numberOfObjects) == 0) || (idx == self.count-1));    
    if (shouldAddArticlesToPage) { 
      [pagedArticles addObject:[articlesPerPage copy]];
      articlesPerPage = [NSMutableArray array];
    }
  }];
  
  return [pagedArticles copy];
}

- (NSArray *) deepCopy {
  unsigned int count = [self count];
  NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:count];
  
  for (unsigned int i = 0; i < count; ++i) {
    id obj = [self objectAtIndex:i];
    if ([obj respondsToSelector:@selector(deepCopy)])
      [newArray addObject:[obj deepCopy]];
    else
      [newArray addObject:[obj copy]];
  }
  
  NSArray *returnArray = [newArray copy];
  newArray = nil;
  return returnArray;
}

- (NSArray *)reverse
{
    NSArray *reversedArray = [[self reverseObjectEnumerator] allObjects];
    return reversedArray;
}

- (id)firstObjectOrNil
{
    if ([self count] <= 0)
        return nil;
    
    return [self objectAtIndex:0];
}

- (id)randomObjectOrNil
{
    if ([self count] <= 0)
        return nil;
    
    if ([self count] == 1)
        return [self firstObjectOrNil];
    
    int n = arc4random_uniform([self count]);
    return [self objectAtIndex:n];
}

- (id)firstObjectWithValue:(id)value forKeyPath:(NSString*)key
{
	for (id object in self)
		if ([[object valueForKeyPath:key] isEqual:value])
			return object;

	return nil;
}

- (NSArray*)filteredArrayWithValue:(id)value forKeyPath:(NSString*)key
{
	NSMutableArray * objects = [NSMutableArray arrayWithCapacity:[self count]];
    
	for (id object in self)
		if ([[object valueForKeyPath:key] isEqual:value])
			[objects addObject:object];

	return [NSArray arrayWithArray:objects];
}

- (NSArray *)sortByAttribute:(NSString *)attribute ascending:(BOOL)ascending;{
  NSSortDescriptor *sortDescriptor;
  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute
                                               ascending:ascending];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  NSArray *sortedArray = [self sortedArrayUsingDescriptors:sortDescriptors];
  return sortedArray;
}

- (NSArray *)arrayUniqueByAddingObjectsFromArray:(NSArray *)array{
    NSMutableSet *set = [NSMutableSet setWithArray:self];
    [set addObjectsFromArray:array];
    return [set allObjects];
}

@end
