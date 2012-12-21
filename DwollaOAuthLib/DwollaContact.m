//
//  DwollaContact.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaContact.h"

@implementation DwollaContact

@synthesize userID, name, image, city, state, type, address, longitude, latitude;

-(id)initWithUserID:(NSString*)_userID 
               name:(NSString*)_name
              image:(NSString*)_image 
               city:(NSString*)_city 
              state:(NSString*)_state 
               type:(NSString*)_type
            address:(NSString*)_address
          longitude:(NSString *)_longitude
           latitude:(NSString *)_latitude
{
    if (self)
    {
        userID = _userID;
        name = _name;
        image = _image;
        city = _city;
        state = _state;
        type = _type;
        address = _address;
        longitude = _longitude;
        latitude = _latitude;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*) dictionary
{
    if (self)
    {
        userID = [dictionary objectForKey:ID_RESPONSE_NAME];
        name = [dictionary objectForKey:NAME_RESPONSE_NAME];
        image = [dictionary objectForKey:IMAGE_RESPONSE_NAME];
        city = [dictionary objectForKey:CITY_RESPONSE_NAME];
        state = [dictionary objectForKey:STATE_RESPONSE_NAME];
        type = [dictionary objectForKey:TYPE_RESPONSE_NAME];
        address = [dictionary objectForKey:ADDRESS_RESPONSE_NAME];
        longitude = [dictionary objectForKey:LONGITUDE_PARAMETER_NAME];
        latitude = [dictionary objectForKey:LATITUDE_RESPONSE_NAME];
    }
    return self;
}

-(BOOL) isEqualTo:(DwollaContact*)_contact
{
    if (![name isEqualToString:[_contact name]] ||
        ![userID isEqualToString:[_contact userID]] ||
        ![type isEqualToString:[_contact type]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
