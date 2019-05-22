//
//  iLogger.m
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#import "iLogger.h"
#import "iLoggerHeader.h"

@implementation iLogger

#pragma mark: sharedInstance
+ (instancetype)sharedInstance{
    //create singleton instance of webService class
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
    
}

- (void)logEvent:(NSInteger)event Block:(iLoggerStatusBlock)block {
    [self logEventWithPayload:event Payload:[[NSMutableDictionary alloc] init] Block:block];
}

- (void)logEventWithPayload:(NSInteger)event Payload:(NSMutableDictionary *)payload Block:(iLoggerStatusBlock)block {
    
    [[iLoggerWebServiceHandler sharedInstance] callPostService:@"ManishWebServiceURL" Data:payload Block:^(NSInteger statusCode) {
    }];
}

- (void)logEventName:(NSString *)eventName Block:(iLoggerStatusBlock)block {
    
    [self logEventNameWithPayload:eventName Payload:[[NSMutableDictionary alloc] init] Block:block];
}

- (void)logEventNameWithPayload:(NSString *)eventName Payload:(NSMutableDictionary *)payloadDict Block:(iLoggerStatusBlock)block {

    [[iLoggerWebServiceHandler sharedInstance] callPostService:@"ManishWebServiceURL" Data:payloadDict Block:block];
}

@end
