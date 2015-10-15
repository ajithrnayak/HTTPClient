//
//  AJHTTPClient.h
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.

#import "AFHTTPSessionManager.h"

@class AJConfiguration;

/**
 *  The completion block of all REST(HTTP) requests.
 *
 *  @param responseObject The response object of the request, if any.
 *  @param error          An error that occurred, if any.
 */
typedef void (^AJHTTPRequestCompletionBlock)(id responseObject, NSError *error);

/**
 * Enumeration specifying type of request.
 */
typedef NS_ENUM(NSInteger, AJHTTPRequestType) {
  AJHTTPRequestGET,
  AJHTTPRequestHEAD,
  AJHTTPRequestPOST,
  AJHTTPRequestPUT,
  AJHTTPRequestPATCH,
  AJHTTPRequestDELETE
};

/**
 *  @discussion AJRESTClient class acts as a HTTP Manager layer
 *  @note default request & response serializer is `AFJSONRequestSerializer`
 */
@interface AJHTTPClient : AFHTTPSessionManager

/**
 *  The configuration for networking operations.
 *
 *  @warning The `configuration` must not be `nil`.
 */
@property(nonatomic) AJConfiguration *configuration;

///---------------------
/// @name Initialization
///---------------------

/**
 *   Initializes an `AJHTTPClient` object with the specified configuration.
 *
 *  @param configuration The configuration object to be used
 *
 *  @return Instance of AJHTTPClient class
 */
- (instancetype)initWithConfiguration:(AJConfiguration *)configuration;

/**
 *  Creates and returns an `AJHTTPClient` object with specified configuration.
 *
 *  @param configuration The configuration object to be used
 *
 *  @return `AJHTTPClient` object
 */
+ (instancetype)httpClientWithConfiguration:(AJConfiguration *)configuration;

///---------------------------
/// @name REST Requests
///---------------------------

/**
 *  Performs a request of type `AJHTTPRequestType` for a given path. The
 *completion block's object is a deserialized response JSON.
 *
 *  @param requestType The REST verb a.k.a request type/method of type
 * `AJHTTPRequestType`
 *  @param path        The relative path of the request.
 *  @param parameters  The parameters to be included in the request.
 *  @param completion  The completion block executed when the request finishes.
 */
- (void)request:(AJHTTPRequestType)requestType
           path:(NSString *)path
     parameters:(NSDictionary *)parameters
     completion:(AJHTTPRequestCompletionBlock)completion;

///---------------------------
/// @name GOODIES
///---------------------------

/**
 *  Sets the value for the HTTP header field. If nil, removes the existing value
 *for that header.
 *
 *  @param value The value set as default for the specified header (if any).
 *  @param field The HTTP header to set a default value for.
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  Cancels and invalidates all active operations.
 */
- (void)cancelAllRequests;

@end
