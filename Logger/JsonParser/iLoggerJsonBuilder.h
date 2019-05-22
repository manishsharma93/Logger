//
//  iLoggerJsonBuilder.h
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iLoggerJsonBuilder : NSObject

+ (id)parseJsonObject:(id)data;

+ (id)createJsonObject:(id)obj;

@end

