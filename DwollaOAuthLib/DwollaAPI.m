//
//  DwollaAPI.m
//  DwollaSDK
//
//  Created by Nick Schulze on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaAPI.h"
#import "Constants.m"


@implementation DwollaAPI

@synthesize oAuthTokenRepository, httpRequestRepository, httpRequestHelper;

static DwollaAPI* sharedInstance;

-(id) init {
    self = [super self];
    if(self){
        self.oAuthTokenRepository = [[OAuthTokenRepository alloc] init];
        self.httpRequestRepository = [[HttpRequestRepository alloc] init];
        self.httpRequestHelper = [[HttpRequestHelper alloc] init];
    }
    return self;
}

+(id) sharedInstance {
    if(!sharedInstance){
        sharedInstance = [[DwollaAPI alloc] init];
    }
    return sharedInstance;
}

+(void) setSharedInstance:(DwollaAPI *)_instance {
    sharedInstance = _instance;
}

-(NSString*)sendMoneyWithPIN:(NSString*)pin
               destinationID:(NSString*)destinationID
             destinationType:(NSString*)type
                      amount:(NSString*)amount
           facilitatorAmount:(NSString*)facAmount
                 assumeCosts:(NSString*)assumeCosts
                       notes:(NSString*)notes
             fundingSourceID:(NSString*)fundingID
{
    //Setting Up URL
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"%@?oauth_token=%@", SEND_URL, [self.oAuthTokenRepository getAccessToken]];
    
    //Checking Parameters
    [self isParameterNullOrEmpty: pin andThrowErrorWithName: PIN_ERROR_NAME];
    [self isParameterNullOrEmpty: destinationID andThrowErrorWithName: DESTINATION_ID_ERROR_NAME];
    [self isParameterNullOrEmpty: amount andThrowErrorWithName: AMOUNT_ERROR_NAME];
    
    //Creating Parameters Dictionary
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         pin, PIN_PARAMETER_NAME,
                                         destinationID, DESTINATION_ID_PARAMETER_NAME,
                                         amount, AMOUNT_PARAMETER_NAME, nil];
    
    if (type != nil && ![type isEqualToString:@""]) [parameterDictionary setObject:type forKey:DESTINATION_TYPE_PARAMETER_NAME];
    if (facAmount != nil && ![facAmount isEqualToString:@""]) [parameterDictionary setObject:facAmount forKey:FACILITATOR_AMOUNT_PARAMETER_NAME];
    if (assumeCosts != nil && ![assumeCosts isEqualToString:@""]) [parameterDictionary setObject:assumeCosts forKey:ASSUME_COSTS_PARAMETER_NAME];
    if (notes != nil && ![notes isEqualToString:@""]) [parameterDictionary setObject:notes forKey:NOTES_PARAMETER_NAME];
    if (fundingID != nil && ![fundingID isEqualToString:@""]) [parameterDictionary setObject:fundingID forKey:FUNDING_SOURCE_PARAMETER_NAME];
    
    //Making the POST Request && Verifying
    NSDictionary* dictionary = [httpRequestRepository postRequest: url withParameterDictionary:parameterDictionary];
    
    //Parsing and responding
    return [[NSString alloc] initWithFormat:@"%@",[dictionary valueForKey:RESPONSE_RESULT_PARAMETER]];
}

-(NSString*)requestMoneyWithPIN:(NSString*)pin
                 sourceID:(NSString*)sourceID 
               sourceType:(NSString*)type
                   amount:(NSString*)amount
        facilitatorAmount:(NSString*)facAmount
                    notes:(NSString*)notes
{
    NSString* token = [self.oAuthTokenRepository getAccessToken];
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"%@?oauth_token=%@", REQUEST_URL, token];
    
    //Checking Parameters
    [self isParameterNullOrEmpty: pin andThrowErrorWithName: PIN_ERROR_NAME];
    [self isParameterNullOrEmpty: sourceID andThrowErrorWithName: SOURCE_ID_ERROR_NAME];
    [self isParameterNullOrEmpty: amount andThrowErrorWithName: AMOUNT_ERROR_NAME];
    
    //Creating Parameters Dictionary
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                pin, @"pin",
                                                sourceID, @"sourceId",
                                                amount, @"amount", nil];
    
    if (type != nil && ![type isEqualToString:@""]) [parameterDictionary setObject:type forKey:@"sourceType"];
    if (facAmount != nil && ![facAmount isEqualToString:@""]) [parameterDictionary setObject:facAmount forKey:@"facilitatorAmount"];
    if (notes != nil && ![notes isEqualToString:@""]) [parameterDictionary setObject:notes forKey:@"notes"];
    
    //Making the POST Request && Verifying
    NSDictionary* dictionary = [httpRequestRepository postRequest: url withParameterDictionary: parameterDictionary];
    
    //Parsing and responding
    return [[NSString alloc] initWithFormat:@"%@",[dictionary valueForKey:@"Response"]];
}

-(NSString*)getBalance
{
    NSString* token = [self.oAuthTokenRepository getAccessToken];
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"%@?oauth_token=%@", BALANCE_URL, token];
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    return [[NSString alloc]initWithFormat:@"%@", [dictionary objectForKey:@"Response"]];
}

-(NSMutableArray*)getContactsByName:(NSString*)name
                              types:(NSString*)types
                              limit:(NSString*)limit
{
    //Creating Parameters Dictionary
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                [self.oAuthTokenRepository getAccessToken], OAUTH_TOKEN_PARAMETER_NAME, nil];
    
    if (name != nil && ![name isEqualToString:@""]) [parameterDictionary setObject:name forKey:NAME_PARAMETER_NAME];
    if (types != nil && ![types isEqualToString:@""]) [parameterDictionary setObject:types forKey:TYPES_PARAMETER_NAME];
    if (limit != nil && ![limit isEqualToString:@""]) [parameterDictionary setObject:limit forKey:LIMIT_PARAMETER_NAME];
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingString:CONTACTS_URL];
    
    //Make GET Request and Verify
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url withQueryParameterDictionary:parameterDictionary];
    
    NSArray* data =[dictionary valueForKey:@"Response"];
    
    NSMutableArray* contacts = [[NSMutableArray alloc] initWithCapacity:[data count]];
    
    //Setup All of the Contacts
    for (int i = 0; i < [data count]; i++)
        [contacts addObject:[self generateContactWithDictionary:[data objectAtIndex:i]]];
    
    return contacts;
}

-(NSMutableArray*)getNearbyWithLatitude:(NSString*)lat
                            Longitude:(NSString*)lon
                                Limit:(NSString*)limit
                                Range:(NSString*)range
{
    //Creating Parameters Dictionary
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                [self.oAuthTokenRepository getClientKey], CLIENT_ID_PARAMETER_NAME,
                                                [self.oAuthTokenRepository getClientSecret], CLIENT_SECRET_PARAMETER_NAME, nil];
    
    if (lat != nil && ![lat isEqualToString:@""]) [parameterDictionary setObject:lat forKey:LATITUDE_PARAMETER_NAME];
    if (lon != nil && ![lon isEqualToString:@""]) [parameterDictionary setObject:lon forKey:LONGITUDE_PARAMETER_NAME];
    if (limit != nil && ![limit isEqualToString:@""]) [parameterDictionary setObject:limit forKey:LIMIT_PARAMETER_NAME];
    if (range != nil && ![range isEqualToString:@""]) [parameterDictionary setObject:range forKey:RANGE_PARAMETER_NAME];
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingString:NEARBY_URL];
    
    //Make GET Request and Verify
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url withQueryParameterDictionary:parameterDictionary];
    
    NSArray* data =[dictionary valueForKey:@"Response"];
    
    NSMutableArray* contacts = [[NSMutableArray alloc] initWithCapacity:[data count]];
    
    //Setup All of the Contacts
    for (int i = 0; i < [data count]; i++)
        [contacts addObject:[self generateContactWithDictionary:[data objectAtIndex:i]]];
    
    return contacts;
}

-(NSArray*)getFundingSources
{
    
    NSString* token = [self.oAuthTokenRepository getAccessToken];
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"%@?oauth_token=%@", FUNDING_SOURCES_URL, token];
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];

    NSArray* data =[dictionary valueForKey:@"Response"];
    
    NSMutableArray* sources = [[NSMutableArray alloc] initWithCapacity:[data count]];
    for (int i = 0; i < [data count]; i++)
    {
        [sources addObject:[self generateSourceWithDictionary:[data objectAtIndex:i]]];
    }
    
    return sources;
}

-(DwollaFundingSource*)getFundingSource:(NSString*)sourceID
{

    NSString* token = [self.oAuthTokenRepository getAccessToken];
    
    [self isParameterNullOrEmpty: sourceID andThrowErrorWithName: SOURCE_ID_ERROR_NAME];
      
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"%@/%@?oauth_token=%@", FUNDING_SOURCES_URL, [self encodedURLParameterString:sourceID], token];
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    
    return [self generateSourceWithDictionary:[dictionary valueForKey:@"Response"]];
}

-(NSDictionary*)getJSONAccountInfo
{
    if (![self.oAuthTokenRepository hasAccessToken])
    {
        @throw [NSException exceptionWithName:@"INVALID_TOKEN_EXCEPTION" 
                                       reason:@"oauth_token is invalid" userInfo:nil];
    }
    
    NSString* token = [self.oAuthTokenRepository getAccessToken];
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"/users?oauth_token=%@", token];
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    
    return dictionary;
}

-(DwollaUser*)getAccountInfo
{
    NSDictionary* dictionary;
    
    dictionary = [self getJSONAccountInfo];
    
    NSString* data = [[NSString alloc] initWithFormat:@"%@",[dictionary valueForKey:@"Response"]];
    
    NSString* success = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Success"]];
    
    if ([success isEqualToString:@"0"]) 
    {
        NSString* message = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Message"]];
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:message userInfo:dictionary];
    }
    
    NSArray* values = [data componentsSeparatedByString:@"\n"];
    NSString* city = [self findValue:[values objectAtIndex:1]];
    NSString* userID = [self findValue:[values objectAtIndex:2]];
    NSString* latitude = [self findValue:[values objectAtIndex:3]];
    NSString* longitude = [self findValue:[values objectAtIndex:4]];
    NSString* name = [self findValue:[values objectAtIndex:5]];
    NSString* state = [self findValue:[values objectAtIndex:6]];
    NSString* type = [self findValue:[values objectAtIndex:7]];
    
    return [[DwollaUser alloc] initWithUserID:userID name:name city:city state:state 
                                     latitude:latitude longitude:longitude type:type];
}

-(NSDictionary*)getJSONBasicInfoWithAccountID:(NSString*)accountID
{    
    NSString* key = [self.oAuthTokenRepository getClientKey];
    NSString* secret = [self.oAuthTokenRepository getClientSecret];
    
    if (key == nil || secret == nil) 
    {
        @throw [NSException exceptionWithName:@"INVALID_APPLICATION_CREDENTIALS_EXCEPTION" 
                                       reason:@"either your application key or application secret is invalid" 
                                     userInfo:nil];   
    }
    if (accountID == nil || [accountID isEqualToString:@""])
    {
        @throw [NSException exceptionWithName:@"INVALID_PARAMETER_EXCEPTION" 
                                       reason:@"accountID is either nil or empty" userInfo:nil];
    }
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"/users/%@?client_id=%@&client_secret=%@", accountID, key, secret]; 
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    
    return dictionary;
}

-(DwollaUser*)getBasicInfoWithAccountID:(NSString*)accountID
{
    NSDictionary* dictionary;
    
    dictionary = [self getJSONBasicInfoWithAccountID:accountID];

    NSDictionary* values = [dictionary valueForKey:@"Response"];
    
    NSString* success = [self.httpRequestHelper getStringFromDictionary:dictionary ForKey:@"Success"];
    
    if ([success isEqualToString:@"0"]) 
    {
        NSString* message = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Message"]];
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:message userInfo:dictionary];
    }
    
    NSString* userID = [self.httpRequestHelper getStringFromDictionary:values ForKey:@"Id"];
    NSString* latitude = [self.httpRequestHelper getStringFromDictionary:values ForKey:@"Latitude"];
    NSString* longitude = [self.httpRequestHelper getStringFromDictionary:values ForKey:@"Longitude"];
    NSString* name = [self.httpRequestHelper getStringFromDictionary:values ForKey:@"Name"];
    
    return [[DwollaUser alloc] initWithUserID:userID name:name city:nil state:nil 
                                     latitude:latitude longitude:longitude type:nil];

}

-(DwollaUser*)registerUserWithEmail:(NSString*) email
                           password:(NSString*)password 
                                pin:(NSString*)pin
                          firstName:(NSString*)first
                           lastName:(NSString*)last
                            address:(NSString*)address
                           address2:(NSString*)address2
                               city:(NSString*)city
                              state:(NSString*)state
                                zip:(NSString*)zip
                              phone:(NSString*)phone
                          birthDate:(NSString*)dob
                               type:(NSString*)type
                       organization:(NSString*)organization
                                ein:(NSString*)ein
                        acceptTerms:(BOOL)accept
{
    NSString* key = [self.oAuthTokenRepository getClientKey];
    NSString* secret = [self.oAuthTokenRepository getClientSecret];
    
    if (key == nil || secret == nil) 
    {
        @throw [NSException exceptionWithName:@"INVALID_APPLICATION_CREDENTIALS_EXCEPTION" 
                                       reason:@"either your application key or application secret is invalid" 
                                     userInfo:nil];
    }
    
    NSString* acceptTerms = @"false";
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"/register/?client_id=%@&client_secret=%@", key, secret]; 
    
    if(email == nil || password == nil || pin == nil || first == nil || last == nil || address == nil || 
       city == nil || state == nil || zip == nil || phone == nil || dob == nil || [email isEqualToString:@""] || 
       [password isEqualToString:@""] || [pin isEqualToString:@""] || [first isEqualToString:@""] || 
       [last isEqualToString:@""] || [address isEqualToString:@""] || [city isEqualToString:@""] || 
       [state isEqualToString:@""] || [zip isEqualToString:@""] || [phone isEqualToString:@""] ||
       [dob isEqualToString:@""])
    {
        @throw [NSException exceptionWithName:@"INVALID_PARAMETER_EXCEPTION" 
                                       reason:@"either email, password, pin, first, last, address, city, state, zip, phone, or date of birth is nil or empty" userInfo:nil];
    }
    if(type != nil && ![type isEqualToString:@""] && ![type isEqualToString:@"Personal"] && 
       ![type isEqualToString:@"Commercial"] && ![type isEqualToString:@"NonProfit"]) 
    {
        @throw [NSException exceptionWithName:@"INVALID_PARAMETER_EXCEPTION" 
                                       reason:@"type must be either personal, commercial, or nonprofit" userInfo:nil];
    }
    if(([type isEqualToString:@"Commercial"] || [type isEqualToString:@"NonProfit"]) && 
                                                (organization == nil || [organization isEqualToString:@""] || 
                                                      ein == nil || [ein isEqualToString:@""])) 
    {
        @throw [NSException exceptionWithName:@"INVALID_PARAMETER_EXCEPTION" 
                                       reason:@"if account type is commercial or nonprofit then user must input an organization name as well as an ein" userInfo:nil];
    }
    if (!accept) 
    {
        @throw [NSException exceptionWithName:@"INVALID_TERM_ACCEPTANCE_EXCEPTION" 
                                       reason:@"user must accept the terms, acceptTerms is false or empty" userInfo:nil];
    }
    else 
    {
        acceptTerms = @"true";
    }
 
    NSString* json = [NSString stringWithFormat:@"{\"email\":\"%@\", \"password\":\"%@\", \"pin\":\"%@\", \"firstName\":\"%@\", \"lastName\":\"%@\", \"address\":\"%@\", \"city\":\"%@\", \"state\":\"%@\", \"zip\":\"%@\", \"phone\":\"%@\", \"dateOfBirth\":\"%@\", \"acceptTerms\":\"%@\", \"client_id\":\"%@\", \"client_secret\":\"%@\"", email, password, pin, first, last, address, city, state, zip, phone, dob, acceptTerms, key, secret];
    if (type != nil  && ![type isEqualToString:@""]) 
    {
        json = [json stringByAppendingFormat: @", \"Type\":\"%@\"", type];
    }
    if (address2 != nil  && ![address2 isEqualToString:@""]) 
    {
        json = [json stringByAppendingFormat: @", \"address2\":\"%@\"", address2];
    }
    if (organization != nil  && ![organization isEqualToString:@""])
    {
        json = [json stringByAppendingFormat: @", \"organization\":\"%@\"", organization];
    }
    if (ein != nil  && ![ein isEqualToString:@""]) 
    {
        json = [json stringByAppendingFormat: @", \"ein\":\"%@\"", ein];
    } 
    json = [json stringByAppendingFormat: @"}"];
    
    NSData* body = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",json);

    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod: @"POST"];
    
    [request setHTTPBody:body];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSDictionary* dictionary = [self generateDictionaryWithData:result];
    NSLog(@"%@", dictionary);
    
    NSString* data = [[NSString alloc] initWithFormat:@"%@",[dictionary valueForKey:@"Response"]];
    
    NSString* success = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Success"]];
    
    if ([success isEqualToString:@"0"]) 
    {
        NSString* message = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Message"]];
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:message userInfo:dictionary];
    }
    
    NSArray* values = [data componentsSeparatedByString:@"\n"];

    NSString* _city = [self findValue:[values objectAtIndex:1]];
    NSString* _userID = [self findValue:[values objectAtIndex:2]];
    NSString* _latitude = [self findValue:[values objectAtIndex:3]];
    NSString* _longitude = [self findValue:[values objectAtIndex:4]];
    NSString* _name = [self findValue:[values objectAtIndex:5]];
    NSString* _state = [self findValue:[values objectAtIndex:6]];
    NSString* _type = [self findValue:[values objectAtIndex:7]];
    
    return [[DwollaUser alloc] initWithUserID:_userID name:_name city:_city state:_state 
                                     latitude:_latitude longitude:_longitude type:_type];  

}

-(NSDictionary*)getJSONTransactionsSince:(NSString*)date
                                   limit:(NSString*)limit
                                    skip:(NSString*)skip
{
    if (![self.oAuthTokenRepository hasAccessToken]) 
    {
        @throw [NSException exceptionWithName:@"INVALID_TOKEN_EXCEPTION" 
                                       reason:@"oauth_token is invalid" userInfo:nil];
    }
    
    NSMutableArray* parameters = [[NSMutableArray alloc] initWithCapacity:4];
    
    if (date != nil  && ![date isEqualToString:@""]) 
    {
        NSString* param = @"sincedate=";
        [parameters addObject:[param stringByAppendingString:date]];
    }
    if (limit != nil  && ![limit isEqualToString:@""])
    {
        NSString* param = @"limit=";
        [parameters addObject:[param stringByAppendingString:limit]];
    }
    if (skip != nil  && ![skip isEqualToString:@""])
    {
        NSString* param = @"skip=";
        [parameters addObject:[param stringByAppendingString:skip]];
    }
    [parameters addObject:@"oauth_token="];
    
    NSString* url = @"/transactions?";
    
    for (int i = 0; i < [parameters count]; i++) 
    {
        url = [url stringByAppendingString:[parameters objectAtIndex:i]];
        if (i < [parameters count]-1)
        {
            url = [url stringByAppendingString:@"&"];
        }
    }

    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    
    return dictionary;
}

-(DwollaTransactions*)getTransactionsSince:(NSString*)date
                                     limit:(NSString*)limit
                                      skip:(NSString*)skip
{
    NSDictionary* dictionary;
 
    dictionary = [self getJSONTransactionsSince:date limit:limit skip:skip];

    NSArray* data =[dictionary valueForKey:@"Response"];
    
    NSString* success = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Success"]];
    
    if ([success isEqualToString:@"0"]) 
    {
        NSString* message = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Message"]];
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:message userInfo:dictionary];
    }
    
    NSMutableArray* transactions = [[NSMutableArray alloc] initWithCapacity:[data count]];
    for (int i = 0; i < [data count]; i++)
    {
        NSString* info = [[NSString alloc] initWithFormat:@"%@", [data objectAtIndex:i]];
        [transactions addObject:[self generateTransactionWithString:info]];
    }
    
   return [[DwollaTransactions alloc] initWithSuccess:YES transactions:transactions];
}

-(NSDictionary*)getJSONTransaction:(NSString*)transactionID
{
    if (![self.oAuthTokenRepository hasAccessToken]) 
    {
        @throw [NSException exceptionWithName:@"INVALID_TOKEN_EXCEPTION" 
                                       reason:@"oauth_token is invalid" userInfo:nil];
    }
    
    NSString* token = [self.oAuthTokenRepository getAccessToken];
    
    NSString* url = [DWOLLA_API_BASEURL stringByAppendingFormat:@"/transactions/%@?oauth_token=%@", transactionID, token];
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    
    return dictionary; 
}

-(DwollaTransaction*)getTransaction:(NSString*)transactionID
{
    NSDictionary* dictionary;

    dictionary = [self getJSONTransaction:transactionID];

    NSArray* pull =[dictionary valueForKey:@"Response"];
    NSString* data = [[NSString alloc] initWithFormat:@"%@", pull];
    
    NSString* success = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Success"]];
    
    if ([success isEqualToString:@"0"]) 
    {
        NSString* message = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Message"]];
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:message userInfo:dictionary];
    }
    
    DwollaTransaction* transaction = [self generateTransactionWithString:data];
    return transaction;
}

-(NSDictionary*)getJSONTransactionStats:(NSString*)start
                                    end:(NSString*)end
{
    if (![self.oAuthTokenRepository hasAccessToken])
    {
        @throw [NSException exceptionWithName:@"INVALID_TOKEN_EXCEPTION" 
                                       reason:@"oauth_token is invalid" userInfo:nil];
    }
    
    NSMutableArray* parameters = [[NSMutableArray alloc] initWithCapacity:3];
    
    if (start != nil  && ![start isEqualToString:@""]) 
    {
        NSString* param = @"startdate=";
        [parameters addObject:[param stringByAppendingString:start]];
    }
    if (end != nil  && ![end isEqualToString:@""])
    {
        NSString* param = @"enddate=";
        [parameters addObject:[param stringByAppendingString:end]];
    }
    [parameters addObject:@"oauth_token="];
    
    NSString* url = @"/transactions/stats?";
    
    for (int i = 0; i < [parameters count]; i++) 
    {
        url = [url stringByAppendingString:[parameters objectAtIndex:i]];
        if (i < [parameters count]-1)
        {
            url = [url stringByAppendingString:@"&"];
        }
    }
    
    NSDictionary* dictionary = [self.httpRequestRepository getRequest:url];
    
    return dictionary;

}

-(DwollaTransactionStats*)getTransactionStats:(NSString*)start
                                          end:(NSString*)end
{
    NSDictionary* dictionary;
    
    dictionary = [self getJSONTransactionStats:start end:end];
    
    NSArray* pull =[dictionary valueForKey:@"Response"];
    NSString* data = [[NSString alloc] initWithFormat:@"%@", pull];
    
    NSString* success = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Success"]];
    
    if ([success isEqualToString:@"0"]) 
    {
        NSString* message = [[NSString alloc] initWithFormat:@"%@", [dictionary valueForKey:@"Message"]];
        @throw [NSException exceptionWithName:@"REQUEST_FAILED_EXCEPTION" reason:message userInfo:dictionary];
    }
    
    NSArray* values = [data componentsSeparatedByString:@"\n"];
    
    NSString* count = [self findValue:[values objectAtIndex:1]];
    NSString* total = [self findValue:[values objectAtIndex:2]];

    return [[DwollaTransactionStats alloc] initWithSuccess:YES count:count total:total];
}


-(NSURLRequest*)generateURLWithKey:(NSString*)key
                          redirect:(NSString*)redirect
                          response:(NSString*)response
                            scopes:(NSArray*)scopes
{   
    if (key == nil || [key isEqualToString:@""])
    {
        @throw [NSException exceptionWithName:@"INVALID_APPLICATION_CREDENTIALS_EXCEPTION" 
                                       reason:@"your application key is invalid" 
                                     userInfo:nil];
    }
    if(redirect == nil || [redirect isEqualToString:@""] || response == nil || 
        [response isEqualToString:@""] || scopes == nil || [scopes count] == 0) 
    {
        @throw [NSException exceptionWithName:@"INVALID_PARAMETER_EXCEPTION" 
                                       reason:@"either redirect, response, or scopes is nil or empty" userInfo:nil];
    }
    NSString* url = [NSString stringWithFormat:@"https://www.dwolla.com/oauth/v2/authenticate?client_id=%@&response_type=%@&redirect_uri=%@&scope=", key, response, redirect];
    
    for (int i = 0; i < [scopes count]; i++) 
    {
        url = [url stringByAppendingString:[scopes objectAtIndex:i]];
        if([scopes count] > 0 && i < [scopes count]-1)
        {
            url = [url stringByAppendingString:@"%7C"];
        }
    }
    
    NSURL* fullURL = [[NSURL alloc] initWithString:url];
    
    NSURLRequest* returnURL = [[NSURLRequest alloc] initWithURL:fullURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:100];
   
    return returnURL;
}

-(NSDictionary*)generateDictionaryWithData:(NSData*)data
{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]; 
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *dictionary = [parser objectWithString:dataString];
    
    return dictionary;
}

-(DwollaContact*) generateContactWithDictionary:(NSDictionary *)dictionary {
    
    NSString *userId = [dictionary objectForKey:@"Id"];
    NSString *name = [dictionary objectForKey:@"Name"];
    NSString *image = [dictionary objectForKey:@"Image"];
    NSString *city = [dictionary objectForKey:@"City"];
    NSString *state = [dictionary objectForKey:@"State"];
    NSString *type = [dictionary objectForKey:@"Type"];
    NSString *address = [dictionary objectForKey:@"Address"];
    NSString *longitude = [dictionary objectForKey:@"Longitude"];
    NSString *latitude = [dictionary objectForKey:@"Latitude"];
    return [[DwollaContact alloc] initWithUserID:userId name:name image:image city:city state:state type:type address:address longitude:longitude latitude:latitude];
}

-(DwollaFundingSource*)generateSourceWithDictionary:(NSDictionary*)dictionary
{
    
    NSString* sourceID = [dictionary objectForKey:@"Id"];
    NSString* name = [dictionary objectForKey:@"Name"];
    NSString* type = [dictionary objectForKey:@"Type"];
    NSString* verified = [dictionary objectForKey:@"Verified"];
    
    return [[DwollaFundingSource alloc] initWithSourceID:sourceID name:name type:type verified:verified];
}

-(DwollaTransaction*)generateTransactionWithString:(NSString*)string
{
    NSArray* info = [string componentsSeparatedByString:@"\n"];
    
    NSString* amount = [self findValue:[info objectAtIndex:1]];
    NSString* clearingDate = [self findValue:[info objectAtIndex:2]];
    NSString* date = [self findValue:[info objectAtIndex:3]];
    NSString* destinationID = [self findValue:[info objectAtIndex:4]];
    NSString* destinationName = [self findValue:[info objectAtIndex:5]];
    NSString* transactionID =  [self findValue:[info objectAtIndex:6]];
    NSString* notes = [self findValue:[info objectAtIndex:7]];
    NSString* sourceID = [self findValue:[info objectAtIndex:8]];
    NSString* sourceName =  [self findValue:[info objectAtIndex:9]];
    NSString* status =  [self findValue:[info objectAtIndex:10]];
    NSString* type =  [self findValue:[info objectAtIndex:11]];
    NSString* userType =  [self findValue:[info objectAtIndex:12]];

    
    return [[DwollaTransaction alloc] initWithAmount:amount clearingDate:clearingDate date:date destinationID:destinationID destinationName:destinationName transactionID:transactionID notes:notes sourceID:sourceID sourceName:sourceName status:status type:type userType:userType];
}

-(NSString*)findValue:(NSString*)string
{
    NSArray* split = [string componentsSeparatedByString:@"= "];
    NSArray* trimmed = [[split objectAtIndex:1] componentsSeparatedByString:@"\""];
    if ([trimmed count] == 3) 
    {
        return [trimmed objectAtIndex:1];
    }
    else 
    {
        NSArray* removed = [[trimmed objectAtIndex:0] componentsSeparatedByString:@";"];
        return (NSString*)[removed objectAtIndex:0];
    }
}

-(NSString *)encodedURLParameterString:(NSString*)string
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (__bridge_retained CFStringRef)string,
                                                                                             NULL,
                                                                                             CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                             kCFStringEncodingUTF8);
	return result;
}

-(void)setAccessToken:(NSString*) token{
    [self.oAuthTokenRepository setAccessToken:token];
}
-(void)clearAccessToken{
    [self.oAuthTokenRepository clearAccessToken];
}
-(void) setClientKey: (NSString*) token{
    [self.oAuthTokenRepository setClientKey:token];
}
-(void) setClientSecret: (NSString*) token{
    [self.oAuthTokenRepository setClientSecret:token];
}

-(BOOL) isParameterNullOrEmpty: (NSString*) value
andThrowErrorWithName: (NSString*) name
{
    if(value == nil || [value isEqualToString:@""])
    {
        @throw [NSException exceptionWithName:@"INVALID_PARAMETER_EXCEPTION"
                                       reason:[[NSString alloc] initWithFormat:@"%@ is required", name] userInfo:nil];
        return false;
    }
    return true;
}

@end
