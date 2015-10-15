//
//  AJOAuthConfiguration.h
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.

#import "AJConfiguration.h"


/**
 *  @note The Base URL is calculated based on Path; just like it's super class
 */

@interface AJOAuthConfiguration : AJConfiguration

/**
 *  The client identifier issued by the authorization server, uniquely
 * representing the registration information provided by the client.
 */
@property(nonatomic, readonly) NSString *clientID;

/**
 *  The client secret.
 */
@property(nonatomic, readonly) NSString *clientSecret;

/**
 *  The score of the request (eg: read write)
 */
@property(nonatomic,readonly)NSString *scope;

/**
 *  Initializes an instance of configuration object.
 *
 *  @warning clientID argument must not be `nil`.
 *
 *  @param serverURL The root URL of the server backend
 *  @param clientID  The client identifier issued by the authorization server,
 *uniquely representing the registration information provided by the client.
 *
 *  @param secret    The client secret.
 *
 *  @return Instance of OAUTH2 configuration
 */
- (instancetype)initWithServerURL:(NSURL *)serverURL
                         clientID:(NSString *)clientID
                     clientSecret:(NSString *)secret
                            scope:(NSString *)scope;

@end
