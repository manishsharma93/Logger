//
//  iConstants.h
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#ifndef iConstants_h
#define iConstants_h

typedef void (^iLoggerStatusBlock)(NSInteger statusCode);
typedef void (^iLoggerResultBlock)(NSInteger statusCode,id result);

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#endif /* iConstants_h */
