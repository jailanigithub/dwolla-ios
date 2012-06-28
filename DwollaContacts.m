//
//  DwollaContacts.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaContacts.h"

@implementation DwollaContacts

-(id)initWithSuccess:(BOOL)_success 
            contacts:(NSMutableArray*)_contacts
{
    if (self) 
    {
        success = _success;
        contacts = _contacts;
    }
    return self;
}

-(BOOL)getSuccess
{
    return success;
}

-(NSMutableArray*)getAll
{
    return contacts;
}

-(NSMutableArray*)getAlphabetized:(NSString *)direction
{
    if ([direction isEqualToString:@"DESC"]) 
    {
        [contacts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            DwollaContact* one = (DwollaContact*) obj1;
            DwollaContact* two = (DwollaContact*) obj2;
            
            return [[one getName] compare:[two getName]];
        }];
    }
    else
    {
        [contacts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            DwollaContact* one = (DwollaContact*) obj1;
            DwollaContact* two = (DwollaContact*) obj2;
            
            return -1*[[one getName] compare:[two getName]];
        }];     
    }
    
    return contacts;
}

-(int)count
{
    return [contacts count];
}

-(DwollaContact*)getObjectAtIndex:(int)index
{
    return [contacts objectAtIndex:index];
}

-(NSString*)toString
{
    NSString* string = @"Contacts:";
    for (int i = 0; i<[contacts count]; i++) 
    {
        string = [string stringByAppendingString:[[contacts objectAtIndex:i] toString]];
    }
    return string;
}

-(BOOL) isEqualTo:(DwollaContacts*)contacts2
{
    NSMutableArray* contacts2array = [contacts2 getAll];
    for (int i = 0; i< [contacts count]; i++) 
    {
        if (![[contacts objectAtIndex:i] isEqualTo: [contacts2array objectAtIndex:i]]) 
        {
            return NO;
        }
    }
    return YES;
}

@end
