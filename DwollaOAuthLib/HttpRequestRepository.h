//
//  RequestRepository.h
//  DwollaOAuth
//
//  Created by James Armstead on 12/18/12.
//
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "HttpRequestHelper.h"

@interface HttpRequestRepository : NSObject
@property (retain) HttpRequestHelper *httpRequestHelper;

-(NSDictionary*)postRequest: (NSString*) url
                   withBody: (NSData *) body;

-(NSDictionary*)getRequest: (NSString*) url;

@end
