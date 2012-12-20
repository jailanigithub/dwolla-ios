//
//  HttpRequestHelper.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/19/12.
//
//

#import "HttpRequestHelper.h"
#import <Foundation/NSJSONSerialization.h>

static NSString *const QUERY_STRING_SEPERATOR = @"&";

@implementation HttpRequestHelper

-(NSDictionary*)generateDictionaryWithData:(NSData*)data
{
    NSError* error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    return dictionary;
}

-(NSDictionary*)generateDictionaryWithString:(NSString*)dataString
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *dictionary = [parser objectWithString:dataString];
    
    return dictionary;
}

-(NSString*) getStringFromDictionary:(NSDictionary*)dictionary
                              ForKey:(NSString*) key
{
    return [[NSString alloc] initWithFormat:@"%@",[dictionary valueForKey:key]];
}

-(NSString*) getJSONStringFromNSDictionary:(NSDictionary*)dictionary
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSData*) getJSONDataFromNsDictionary:(NSDictionary*)dictionary
{
    return [[self getJSONStringFromNSDictionary:dictionary] dataUsingEncoding:NSUTF8StringEncoding];
}

-(NSDictionary*) checkRequestForSuccessAndReturn:(NSDictionary*) dictionary
{
    if ([[[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Success"]] isEqualToString:@"false"])
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:[self getJSONStringFromNSDictionary:dictionary] userInfo:nil];
    return dictionary;
}

-(NSString*) getQueryParametersFroNSDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dictionary) {
        NSString* value = [self encodeString:[dictionary objectForKey: key]];
        [parts addObject: [NSString stringWithFormat: @"%@=%@", key, value]];
    }
    return [parts componentsJoinedByString: QUERY_STRING_SEPERATOR];
}

-(NSString*) encodeString: (NSString*) string
{
    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)string, NULL, (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ", kCFStringEncodingISOLatin1);
}

@end
