//
//  DwollaUser.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaUser.h"

@implementation DwollaUser

@synthesize userID, name, city, state, latitude, longitude, type;

-(id)initWithUserID:(NSString*)_userID name:(NSString*)_name city:(NSString*)_city state:(NSString*)_state 
           latitude:(NSString*)_latitude longitude:(NSString*)_longitude type:(NSString*)_type
{
    if (self) 
    {
        userID = _userID;
        name = _name;
        city = _city;
        state = _state;
        latitude = _latitude;
        longitude = _longitude;
        type = _type;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*) dictionary
{
    if (self)
    {
        userID = [dictionary valueForKey:ID_RESPONSE_NAME];
        name = [dictionary valueForKey:NAME_RESPONSE_NAME];
        city = [dictionary valueForKey:CITY_RESPONSE_NAME];
        state = [dictionary valueForKey:STATE_RESPONSE_NAME];
        latitude = [dictionary valueForKey:LATITUDE_RESPONSE_NAME] ;
        longitude = [dictionary valueForKey:LONGITUDE_RESPONSE_NAME];
        type = [dictionary valueForKey:TYPE_RESPONSE_NAME];
    }
    return self;
}

-(BOOL)isEqualTo:(DwollaUser*)_user
{
    if ([name isEqualToString:[_user name]] || [userID isEqualToString:[_user userID]] || ((type == nil && [_user type] == nil) || [userID isEqualToString:[_user userID]]))
        return YES;

    return NO;
}

@end
