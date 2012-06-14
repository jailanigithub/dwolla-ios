//
//  APIViewController.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APIViewController.h"

@interface APIViewController ()

@end

@implementation APIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) getBalance
{
    NSString* balance = [DwollaAPI getBalance];
}

-(IBAction)getContacts
{
    DwollaContacts* contacts = [DwollaAPI getContactsByName:@"" types:@"" limit:@""];
}

-(IBAction)getFundingSources
{
    DwollaFundingSources* sources = [DwollaAPI getFundingSources];
    DwollaFundingSource* person = [[sources getAll] objectAtIndex:0];
}

-(IBAction)getFirstSource
{
    DwollaFundingSources* sources = [DwollaAPI getFundingSources];
    DwollaFundingSource* source = [[sources getAll] objectAtIndex:0];
}

-(IBAction)logout
{
    [DwollaAPI clearAccessToken];
}

-(IBAction)getTransactions
{
    DwollaTransactions* transactions = [DwollaAPI getTransactionsSince:@"04-08-12" limit:@"10" skip:@"0"];
    DwollaTransaction* transaction = [[transactions getAll] objectAtIndex:0];
}

-(IBAction)getTransaction;
{
    DwollaTransactions* transactions = [DwollaAPI getTransactionsSince:@"04-08-12" limit:@"10" skip:@"0"];
    DwollaTransaction* transaction = [[transactions getAll] objectAtIndex:0];
    DwollaTransaction* trans = [DwollaAPI getTransaction:[transaction getTransactionID]];
}

-(IBAction)getTransactionStats
{
    DwollaTransactionStats* stats = [DwollaAPI getTransactionStats:@"" end:@""];
}

-(IBAction)getAccountInfo
{
    DwollaUser* user = [DwollaAPI getAccountInfo];
}

-(IBAction)getBasicInfo
{
    DwollaTransactions* transactions = [DwollaAPI getTransactionsSince:@"04-08-12" limit:@"10" skip:@"0"];
    DwollaTransaction* transaction = [[transactions getAll] objectAtIndex:0];
    DwollaUser* user = [DwollaAPI getBasicInfoWithAccountID:(NSString*)[transaction getDestinationID]];
}

-(IBAction)sendMoney
{
    NSString* request = [DwollaAPI sendMoneyWithPIN:@"" destinationID:@"812-607-7497" destinationType:@"Dwolla" amount:@"0.01" facilitatorAmount:@"0" assumeCosts:@"false" notes:@"api_test" fundingSourceID:@""];
}

-(IBAction)requestMoney
{
    NSString* request = [DwollaAPI requestMoneyWithPIN:@"" sourceID:@"812-525-0238" sourceType:nil amount:@"0.01" facilitatorAmount:@"0.00" notes:nil];
}

-(IBAction)registerUser
{
    DwollaUser* new = [DwollaAPI registerUserWithEmail:@"nicks+3@dwolla.com" password:@"Password123" pin:@"0123" firstName:@"First1" lastName:@"Last" address:@"1234 West End" address2:nil city:@"Des Moines" state:@"IA" zip:@"50301" phone:@"1112223344" birthDate:@"01-02-34" type:nil organization:nil ein:nil acceptTerms:YES];
}

-(IBAction)getNearby
{
    DwollaContacts* contacts = [DwollaAPI getNearbyWithLatitude:@"41.6" Longitude:@"-93.6" Limit:@"5" Range:@"1"];
}

@end
