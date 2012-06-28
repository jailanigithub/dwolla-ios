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
           latitude:(NSString *)_latitude 
          longitude:(NSString *)_longitude
            address:(NSString *)_address 
             postal:(NSString *)_postal
{
    if (self) 
    {
        userID = _userID;
        name = _name;
        image = _image;
        city = _city;
        state = _state;
        type = _type;
        latitude = _latitude;
        longitude = _longitude;
        address = _address;
        postal = _postal;
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

-(NSString*)getLatitude
{
    return latitude;
}

-(NSString*)getLongitude
{
    return longitude;
}

-(NSString*)getAddress
{
    return address;
}

-(NSString*)getPostal
{
    return postal;
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"Name:%@ ID:%@", name, userID];
}


-(BOOL)isEqualTo:(DwollaContact*)contact2
{
    return ([name isEqualToString:[contact2 getName]] && [userID isEqualToString:[contact2 getUserID]] && 
            [type isEqualToString:[contact2 getType]]);
}

@end
