//
//  iLoggerWebServiceHandler.h
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iConstants.h"

@interface iLoggerWebServiceHandler : NSObject

+ (instancetype)sharedInstance;

- (void)callPostService:(NSString *)strMethodName Data:(NSMutableDictionary *)requestDict Block:(iLoggerStatusBlock)block;

- (void)callGetService:(NSString *)strRequestUrl Block:(iLoggerResultBlock)block;

- (void)postRequestDataToTheServer:(NSString *)strMethodName RequestParamters:(NSString *)requestParams Block:(iLoggerStatusBlock)block;

@end

