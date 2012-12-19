//
//  AccessTokenRepository.h
//  DwollaOAuth
//
//  Created by James Armstead on 12/18/12.
//
//

#import <Foundation/Foundation.h>

@interface AccessTokenRepository : NSObject
-(BOOL)hasAccessToken;
-(NSString*)getAccessToken;
-(void)setAccessToken:(NSString*) token;
-(void)clearAccessToken;
@end
