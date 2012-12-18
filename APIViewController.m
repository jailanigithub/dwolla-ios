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

@synthesize dwollaAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dwollaAPI = [DwollaAPI sharedInstance];
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
    NSString* balance = [dwollaAPI getBalance];
}

-(IBAction)getContacts
{
    DwollaContacts* contacts = [dwollaAPI getContactsByName:@"" types:@"" limit:@""];
}

-(IBAction)getFundingSources
{
    DwollaFundingSources* sources = [dwollaAPI getFundingSources];
    DwollaFundingSource* person = [[sources getAll] objectAtIndex:0];
}

-(IBAction)getFirstSource
{
    DwollaFundingSources* sources = [dwollaAPI getFundingSources];
    DwollaFundingSource* source = [[sources getAll] objectAtIndex:0];
}

-(IBAction)logout
{
    [dwollaAPI clearAccessToken];
}

-(IBAction)getTransactions
{
    DwollaTransactions* transactions = [dwollaAPI getTransactionsSince:@"04-08-12" limit:@"10" skip:@"0"];
    DwollaTransaction* transaction = [[transactions getAll] objectAtIndex:0];
}

-(IBAction)getTransaction;
{
    DwollaTransactions* transactions = [dwollaAPI getTransactionsSince:@"04-08-12" limit:@"10" skip:@"0"];
    DwollaTransaction* transaction = [[transactions getAll] objectAtIndex:0];
    DwollaTransaction* trans = [dwollaAPI getTransaction:[transaction getTransactionID]];
}

-(IBAction)getTransactionStats
{
    DwollaTransactionStats* stats = [dwollaAPI getTransactionStats:@"" end:@""];
}

-(IBAction)getAccountInfo
{
    DwollaUser* user = [dwollaAPI getAccountInfo];
}

-(IBAction)getBasicInfo
{
    DwollaTransactions* transactions = [dwollaAPI getTransactionsSince:@"04-08-12" limit:@"10" skip:@"0"];
    DwollaTransaction* transaction = [[transactions getAll] objectAtIndex:0];
    DwollaUser* user = [dwollaAPI getBasicInfoWithAccountID:(NSString*)[transaction getDestinationID]];
}

-(IBAction)sendMoney
{
    NSString* request = [dwollaAPI sendMoneyWithPIN:@"" destinationID:@"812-607-7497" destinationType:@"Dwolla" amount:@"0.01" facilitatorAmount:@"0" assumeCosts:@"false" notes:@"api_test" fundingSourceID:@""];
}

-(IBAction)requestMoney
{
    NSString* request = [dwollaAPI requestMoneyWithPIN:@"" sourceID:@"812-525-0238" sourceType:nil amount:@"0.01" facilitatorAmount:@"0.00" notes:nil];
}

-(IBAction)registerUser
{
    DwollaUser* new = [dwollaAPI registerUserWithEmail:@"nicks+3@dwolla.com" password:@"Password123" pin:@"0123" firstName:@"First1" lastName:@"Last" address:@"1234 West End" address2:nil city:@"Des Moines" state:@"IA" zip:@"50301" phone:@"1112223344" birthDate:@"01-02-34" type:nil organization:nil ein:nil acceptTerms:YES];
}

-(IBAction)getNearby
{
    DwollaContacts* contacts = [dwollaAPI getNearbyWithLatitude:@"41.6" Longitude:@"-93.6" Limit:@"5" Range:@"1"];
}

@end
