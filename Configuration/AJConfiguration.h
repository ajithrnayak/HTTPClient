//
//  AJConfiguration.h
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.

#import <Foundation/Foundation.h>


/**
 *  @discussion Example URL = https://api.server.com/v1/users/sign-In
 *
 *  Here, server/root URL = https://api.server.com/
 *        base URL (serverURL + apiVersion + resourceName) =
 *        https://api.server.com/v1/users
 *        API version = v1
 *        resourceName = users
 *        path = sign-in
 */

@interface AJConfiguration : NSObject

/**
 *  The root URL of the server backend.
 */
@property(nonatomic, copy) NSURL *serverURL;

/**
 *  The base URL of the server backend, which includes api and resource paths.
 */
@property(nonatomic, readonly) NSURL *baseURL;

/**
 *  The server-side api version. [default: /v1/].
 */
@property(nonatomic, assign) NSUInteger apiVersion;

/**
 *  The server-side resource name [default: nil].
 */
@property(nonatomic) NSString *resourceName;

/**
 *  The server-side authentication token name.
 */
@property(nonatomic) NSString *accessToken;

/**
 *  The number of retries in case of connection issues (default: 0).
 */
@property(nonatomic, assign) NSUInteger numberOfRetries;

/**
 *  The duration (in seconds) after which a next retry happens (default: 0).
 */
@property(nonatomic, assign) NSTimeInterval retryDelay;


///---------------------
/// @name Initialization
///---------------------

/**
 *  Initializes an instance of configuration object.
 *
 *  @param serverURL The root URL of the server backend.
 *  @return Instance of EDCConfiguration
 */
- (instancetype)initWithServerURL:(NSURL *)serverURL NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end
