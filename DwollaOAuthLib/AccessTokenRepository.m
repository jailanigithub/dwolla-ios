//
//  AccessTokenRepository.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/18/12.
//
//

#import "AccessTokenRepository.h"

@implementation AccessTokenRepository

-(BOOL)hasAccessToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if(token == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(NSString*)getAccessToken
{
    if (![self hasAccessToken])
    {
        @throw [NSException exceptionWithName:@"INVALID_TOKEN_EXCEPTION"
                                       reason:@"oauth_token is invalid" userInfo:nil];
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return token;
}

-(void)setAccessToken:(NSString*) token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)clearAccessToken
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"token"];
}

@end
