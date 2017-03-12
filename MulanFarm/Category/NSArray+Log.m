//
//  NSArray+Log.m
//  MulanFarm
//
//  Created by zyl on 17/3/10.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *str = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
        
        [str appendFormat:@"\t%@,\n", obj];
        
    }];
    
    [str appendString:@")"];
    
    return str;
    
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *str = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop) {
        
        [str appendFormat:@"\t%@ = %@;\n", key, obj];
        
    }];
    
    [str appendString:@"}\n"];
    
    return str;
    
}

@end
