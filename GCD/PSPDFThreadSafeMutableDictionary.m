//
//  PSPDFThreadSafeMutableDictionary.m
//  GCD
//
//  Created by Vikas Kumar Jangir on 04/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//


#import "PSPDFThreadSafeMutableDictionary.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>

#define LOCKED(...) os_unfair_lock_lock(&_lock); \
__VA_ARGS__; \
os_unfair_lock_unlock(&_lock);

//
//#define LOCKED(...) do { \
//os_unfair_lock_lock(&_lock); \
//__VA_ARGS__; \
//os_unfair_lock_unlock(&_lock); \
//} while (NO);


@implementation PSPDFThreadSafeMutableDictionary {
    os_unfair_lock _lock;
    NSMutableDictionary *_dictionary; // Class Cluster!
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject




//- (id)init {
//    return [self initWithCapacity:0];
//}

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    if ((self = [self initWithCapacity:objects.count])) {
        [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self->_dictionary[keys[idx]] = obj;
        }];
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)capacity {
    if ((self = [super init])) {
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
        _lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (id)init {
    return [self initWithCapacity:0];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableDictionary

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    LOCKED(_dictionary[aKey] = anObject)
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    LOCKED([_dictionary addEntriesFromDictionary:otherDictionary]);
}

- (void)setDictionary:(NSDictionary *)otherDictionary {
    LOCKED([_dictionary setDictionary:otherDictionary]);
}

- (void)removeObjectForKey:(id)aKey {
    LOCKED([_dictionary removeObjectForKey:aKey])
}

- (void)removeAllObjects {
    LOCKED([_dictionary removeAllObjects]);
}

- (NSUInteger)count {
    LOCKED(NSUInteger count = _dictionary.count)
    return count;
}

- (NSArray *)allKeys {
    LOCKED(NSArray *allKeys = _dictionary.allKeys)
    return allKeys;
}

- (NSArray *)allValues {
    LOCKED(NSArray *allValues = _dictionary.allValues)
    return allValues;
}

- (id)objectForKey:(id)aKey {
    LOCKED(id obj = _dictionary[aKey])
    return obj;
}

- (NSEnumerator *)keyEnumerator {
    LOCKED(NSEnumerator *keyEnumerator = [_dictionary keyEnumerator])
    return keyEnumerator;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LOCKED(id copiedDictionary = [[self.class allocWithZone:zone] initWithDictionary:_dictionary])
    return copiedDictionary;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])stackbuf
                                    count:(NSUInteger)len {
    LOCKED(NSUInteger count = [[_dictionary copy] countByEnumeratingWithState:state objects:stackbuf count:len]);
    return count;
}

- (void)performLockedWithDictionary:(void (^)(NSDictionary *dictionary))block {
    if (block) LOCKED(block(_dictionary));
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    
    if ([object isKindOfClass:PSPDFThreadSafeMutableDictionary.class]) {
        PSPDFThreadSafeMutableDictionary *other = object;
        __block BOOL isEqual = NO;
        [other performLockedWithDictionary:^(NSDictionary *dictionary) {
            [self performLockedWithDictionary:^(NSDictionary *otherDictionary) {
                isEqual = [dictionary isEqual:otherDictionary];
            }];
        }];
        return isEqual;
    }
    return NO;
}

@end

