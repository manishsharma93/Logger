//
//  iLoggerJsonBuilder.m
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#import "iLoggerJsonBuilder.h"

@implementation iLoggerJsonBuilder

+ (id)parseJsonObject:(id)data {
    
    if([data isKindOfClass:[NSData class]]) {
        NSError *parseJsonError;
        id serviceResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJsonError];
        if(!parseJsonError) {
            return serviceResponse;
        }
        return parseJsonError;
    }
    return nil;
}

#pragma mark create json Object
+ (id)createJsonObject:(id)obj {
    
    NSError *parseJsonError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&parseJsonError];
    if(!parseJsonError) {
        return data;
    }
    return parseJsonError;
}

@end
