//
//  AJOAuthClient.h
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.
//

#import "AFOAuth2Manager.h"

@class AJOAuthConfiguration;

/**
 *  @note `AJOAuthClient` class acts as a OAUTH2 Manager Client
 *  OAuth 2.0 provides several grant types, covering several different use
 cases. The following grant type string constants are provided:
 
 `kAFOAuthCodeGrantType`: "authorization_code"
 `kAFOAuthClientCredentialsGrantType`: "client_credentials"
 `kAFOAuthPasswordCredentialsGrantType`: "password"
 `kAFOAuthRefreshGrantType`: "refresh_token"
 */
@interface AJOAuthClient : AFOAuth2Manager

/**
 *  The configuration for authenticating operations.
 *
 *  @warning The `configuration` must not be `nil`.
 */
@property(nonatomic) AJOAuthConfiguration *configuration;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Creates and returns an `AJOAuthClient` object with specified configuration.
 *
 *  @param configuration The configuration object to be used
 *
 *  @return The `AJOAuthClient` object
 */
+(instancetype)oauthClientWithConfiguration:(AJOAuthConfiguration*)configuration;

/**
 *   Initializes an `AJOAuthClient` object with the specified configuration.
 *
 *  @param configuration The configuration object to be used
 *
 *  @return Instance of AJOAuthClient class
 */
-(instancetype)initWithConfiguration:(AJOAuthConfiguration*)configuration;

///---------------------
/// @name Request
///---------------------

/**
 Creates and enqueues an `AFHTTPRequestOperation` to authenticate against the server using a specified username and password, with a designated scope.
 @param path The relative path of the request.
 @param username The username used for authentication
 @param password The password used for authentication
 @param scope The authorization scope
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the OAuth credential returned by the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the error returned from the server.
 */
- (void)authenticateWithPath:(NSString *)path
                    userName:(NSString *)userName
                    password:(NSString *)password
                       scope:(NSString *)scope
                     success:(void (^)(AFOAuthCredential *credential))success
                     failure:(void (^)(NSError *error))failure;
@end