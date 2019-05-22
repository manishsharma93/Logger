//
//  iLoggerWebServiceHandler.m
//  Logger
//
//  Created by Manish Kumar on 12/03/19.
//  Copyright © 2019 Manish Kumar. All rights reserved.
//

#import "iLoggerWebServiceHandler.h"
#import "iLoggerJsonBuilder.h"
#import "iConstants.h"

@interface iLoggerWebServiceHandler ()<NSURLSessionDelegate>

- (void)excecuteSessionRequest:(NSMutableURLRequest *)request ResultBlock:(iLoggerResultBlock)block;

enum HttpCodes {
    success_code = 200,
    internalServerError = 500,
    serviceUnavailable = 503
};

@end

@implementation iLoggerWebServiceHandler

+ (instancetype)sharedInstance {
    //create single ton instance of webService class
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark callGetService:Block
- (void)callGetService:(NSString *)strRequestUrl Block:(iLoggerResultBlock)block {
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strRequestUrl]cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [self excecuteSessionRequest:request ResultBlock:^(NSInteger statusCode, id result) {
        
        if (statusCode == success_code) {
            if(result){
                id response = [iLoggerJsonBuilder parseJsonObject:result];
                if (![response isKindOfClass:[NSError class]]) {
                    block(statusCode,response);
                    return;
                }
            }
        }
        block(internalServerError,nil);
    }];
}

#pragma mark callPostService:RequestParamters:Block
- (void)callPostService:(NSString *)strMethodName Data:(NSMutableDictionary *)requestDict Block:(iLoggerStatusBlock)block {

    [self postPreparedDictionaryToServer:requestDict MethodName:strMethodName Block:block];
}

- (void)postPreparedDictionaryToServer:(NSMutableDictionary *)requestDict MethodName:(NSString *)strMethodName Block:(iLoggerStatusBlock)block {
   
    if(requestDict) {
        
        //convert dict to json object
        NSData *jsonDictStr = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:nil];
        
        //convert data to string
        NSString *jsonStr = [[NSString alloc] initWithData:jsonDictStr encoding:NSUTF8StringEncoding];
        
        //storing json string inside dict
        NSDictionary *dictObj = [[NSDictionary alloc]initWithObjectsAndKeys:jsonStr , @"data",nil];
        
        //set up post parameteres
        NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSString *key in dictObj) {
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, dictObj[key]]];
        }
        
        //joined array Objects
        NSString *requestParams = [pairs componentsJoinedByString:@"&"];
        
        [self postRequestDataToTheServer:strMethodName RequestParamters:requestParams Block:^(NSInteger statusCode) {
            if(block != nil)
                block(statusCode);
        }];
    }
}
//----------------------------------------------------------------------------------------

#pragma mark postData:RequestParamters:Block
- (void)postRequestDataToTheServer:(NSString *)strMethodName RequestParamters:(NSString *)requestParams Block:(iLoggerStatusBlock)block {
    //    NSLog(@"Manish postRequestDataToTheServer called ");
    
    //convert paramters to data
    NSData* postData = [requestParams dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *baseStr = [NSString stringWithFormat: @"%@%@", @"ManisWebURL", strMethodName];
    //set up request and time out values
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[baseStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    //get request length
    NSString * postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //set up method type
    [request setHTTPMethod:@"POST"];
    //set up header field
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set http body
    [request setHTTPBody: postData];
    
    [self excecuteSessionRequest:request ResultBlock:^(NSInteger statusCode, id result) {
        
        block(statusCode);
    }];
}
//----------------------------------------------------------------------------------------

#pragma mark excecuteSessionRequest
-(void)excecuteSessionRequest:(NSMutableURLRequest *)request ResultBlock:(iLoggerResultBlock)block {
    //    NSLog(@"Manish excecuteSessionRequest called ");
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //set up NSURLSession configuration
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    //call web service using NSURLSessionDataTask
    __block NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,NSError *error){
        NSInteger statusCode = 0;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)postDataTask.response;
        if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
            statusCode = httpResponse.statusCode;
        }
        //        NSLog(@"Manish Response StatusCode:%ld",(long)statusCode);
        
        block(statusCode,data);
    }];
    [postDataTask resume];
}


- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
        completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential * credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

@end
