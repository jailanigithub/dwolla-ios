//
//  HttpRequestHelper.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/19/12.
//
//

#import "HttpRequestHelper.h"
#import <Foundation/NSJSONSerialization.h>

@implementation HttpRequestHelper

-(NSDictionary*)generateDictionaryWithData:(NSData*)data
{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
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

@end
