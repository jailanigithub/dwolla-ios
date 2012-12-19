//
//  RequestRepository.h
//  DwollaOAuth
//
//  Created by James Armstead on 12/18/12.
//
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface HttpRequestRepository : NSObject

-(NSDictionary*)postRequest: (NSString*) url
                   withBody: (NSData *) body;

-(NSDictionary*)getRequest: (NSString*) url;

-(NSDictionary*)generateDictionaryWithData:(NSData*)data;
@end
