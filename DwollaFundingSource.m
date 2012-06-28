//
//  DwollaFundingSource.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaFundingSource.h"

@implementation DwollaFundingSource

-(id)initWithSourceID:(NSString*)_sourceID 
                 name:(NSString*)_name 
                 type:(NSString*)_type 
             verified:(NSString*)_verified
{
    if (self) 
    {
        sourceID = _sourceID;
        name = _name;
        type = _type;
        if ([_verified isEqualToString:@"true"]) 
        {
            verified = YES;
        }
        else
        {
            verified = NO;
        }
    }
    return self;
}

-(NSString*)getSourceID
{
    return sourceID;
}

-(NSString*)getName
{
    return name;
}

-(NSString*)getType
{
    return type;
}

-(BOOL)isVerified
{
    return verified;
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"Name:%@ ID:%@ Type:%@ Verified%i", name,sourceID, type, verified];
}


-(BOOL)isEqualTo:(DwollaFundingSource*)source2
{
    return ([name isEqualToString:[source2 getName]] && [sourceID isEqualToString:[source2 getSourceID]] && 
            [type isEqualToString:[source2 getType]] && verified == [source2 isVerified]);
}

@end
