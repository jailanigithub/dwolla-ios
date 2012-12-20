//
//  Constants.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/20/12.
//
//

static NSString *const DWOLLA_API_BASEURL = @"https://www.dwolla.com/oauth/rest";
static NSString *const SEND_URL = @"/transactions/send";
static NSString *const REQUEST_URL = @"/transactions/request";
static NSString *const BALANCE_URL = @"/balance";
static NSString *const CONTACTS_URL = @"/contact";
static NSString *const NEARBY_URL = @"/contacts/nearby";
static NSString *const FUNDING_SOURCES_URL = @"/fundingsources";
static NSString *const USERS_URL = @"/users";

static NSString *const RESPONSE_RESULT_PARAMETER = @"Response";

static NSString *const PIN_ERROR_NAME = @"PIN";
static NSString *const DESTINATION_ID_ERROR_NAME = @"Destination Id";
static NSString *const SOURCE_ID_ERROR_NAME = @"Source Id";
static NSString *const AMOUNT_ERROR_NAME = @"Amount";

static NSString *const PIN_PARAMETER_NAME = @"pin";
static NSString *const DESTINATION_ID_PARAMETER_NAME = @"destinationId";
static NSString *const AMOUNT_PARAMETER_NAME = @"amount";
static NSString *const DESTINATION_TYPE_PARAMETER_NAME = @"destinationType";
static NSString *const FACILITATOR_AMOUNT_PARAMETER_NAME = @"facilitatorAmount";
static NSString *const ASSUME_COSTS_PARAMETER_NAME = @"assumeCosts";
static NSString *const NOTES_PARAMETER_NAME = @"notes";
static NSString *const FUNDING_SOURCE_PARAMETER_NAME = @"fundsSource";
static NSString *const NAME_PARAMETER_NAME = @"name";
static NSString *const TYPES_PARAMETER_NAME = @"types";
static NSString *const LIMIT_PARAMETER_NAME = @"limit";
static NSString *const OAUTH_TOKEN_PARAMETER_NAME = @"oauth_token";
static NSString *const CLIENT_ID_PARAMETER_NAME = @"client_id";
static NSString *const CLIENT_SECRET_PARAMETER_NAME = @"client_secret";
static NSString *const RANGE_PARAMETER_NAME = @"range";
static NSString *const LATITUDE_PARAMETER_NAME = @"latitude";
static NSString *const LONGITUDE_PARAMETER_NAME = @"longitude";