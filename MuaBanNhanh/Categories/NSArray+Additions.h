//
//  NSArray+NSArray_Additions.h
//  Aurora
//
//  Created by Seivan Heidari on 1/27/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//


@interface NSArray (Additions)

- (NSArray *)paginatedWithNumberOfObjectsPerPage:(NSUInteger)numberOfObjects;

- (NSArray *)deepCopy;

- (NSArray *)reverse;

- (id)firstObjectOrNil;
- (id)randomObjectOrNil;

/*
 * KVC related addition : find and return the first object in the array whose value for keypath *keypath* is equal to *value*.
 * will return nil if no such object is found.
 */
- (id)firstObjectWithValue:(id)value forKeyPath:(NSString*)keypath;

/*
 * KVC related addition : find and return the objects in the array whose value for keypath *keypath* is equal to *value*.
 * will return an empty array if no such object is found.
 */
- (NSArray*)filteredArrayWithValue:(id)value forKeyPath:(NSString*)keypath;

- (NSArray *)sortByAttribute:(NSString *)attribute ascending:(BOOL)ascending;

- (NSArray *)arrayUniqueByAddingObjectsFromArray:(NSArray *)array;

@end
