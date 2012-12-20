//
//  RequestRepository.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/18/12.
//
//

#import "HttpRequestRepository.h"

@implementation HttpRequestRepository

@synthesize httpRequestHelper, nsURLConnectionRepository;

-(id) init {
    self = [super self];
    if(self){
        self.httpRequestHelper = [[HttpRequestHelper alloc] init];
        self.nsURLConnectionRepository = [[NSURLConnectionRepository alloc] init];
    }
    return self;
}

-(NSDictionary*)postRequest: (NSString*) url
    withParameterDictionary: (NSDictionary*) parameterDictionary
{
    NSData* body = [httpRequestHelper getJSONDataFromNsDictionary:parameterDictionary];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod: @"POST"];
    
    [request setHTTPBody:body];
    
    NSDictionary *resultDictionary = [self.nsURLConnectionRepository sendSynchronousRequest:request];
    
    return [self.httpRequestHelper checkRequestForSuccessAndReturn: resultDictionary];
}

-(NSDictionary*)getRequest: (NSString*) url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];

    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    return [self.httpRequestHelper generateDictionaryWithData:result];
}



@end
