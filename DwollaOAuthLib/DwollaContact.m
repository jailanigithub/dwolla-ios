//
//  DwollaContact.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaContact.h"

@implementation DwollaContact

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

-(NSString*)getName
{
    return name;
}

-(NSString*)getUserID
{
    return userID;
}

-(NSString*)getImageURL
{
    return image;
}

-(NSString*)getCity
{
    return city;
}

-(NSString*)getState
{
    return state;
}

-(NSString*)getType
{
    return type;
}

-(NSString*) getAddress {
    return address;
}

-(NSString*) getLongitude {
    return longitude;
}

-(NSString*) getLatitude {
    return latitude;
}

-(BOOL) isEqualTo:(DwollaContact*)_contact
{
    if (![name isEqualToString:[_contact getName]] ||
        ![userID isEqualToString:[_contact getUserID]] ||
        ![type isEqualToString:[_contact getType]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
