//
//  iLogger.h
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iConstants.h"

@interface iLogger : NSObject

+ (instancetype)sharedInstance;

- (void)logEvent:(NSInteger)event Block:(iLoggerStatusBlock)block;

- (void)logEventWithPayload:(NSInteger)event Payload:(NSMutableDictionary *)payload Block:(iLoggerStatusBlock)block;

- (void)logEventName:(NSString *)eventName Block:(iLoggerStatusBlock)block;

- (void)logEventNameWithPayload:(NSString *)eventName Payload:(NSMutableDictionary *)payloadDict Block:(iLoggerStatusBlock)block;

@end

