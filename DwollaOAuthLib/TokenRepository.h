//
//  AccessTokenRepository.h
//  DwollaOAuth
//
//  Created by James Armstead on 12/18/12.
//
//

#import <Foundation/Foundation.h>

@interface TokenRepository : NSObject
-(BOOL)hasAccessToken;
-(NSString*)getAccessToken;
-(void)setAccessToken:(NSString*) token;
-(void)clearAccessToken;
-(NSString*)getClientKey;
-(NSString*)getClientSecret;
@end
