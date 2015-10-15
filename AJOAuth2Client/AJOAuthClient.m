//
//  AJOAuthClient.m
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.
//

#import "AJOAuthClient.h"
#import "AJOAuthConfiguration.h"

@implementation AJOAuthClient

#pragma mark - Initializer

+ (instancetype)oauthClientWithConfiguration:
        (AJOAuthConfiguration *)configuration {
  return [[[self class] alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(AJOAuthConfiguration *)configuration {

  if (self = [super initWithBaseURL:nil
                           clientID:configuration.clientID
                             secret:configuration.clientSecret]) {
    _configuration = configuration;
    [self _configureOAUTHClient];
  }
  return self;
}

#pragma mark - Minions

- (void)_configureOAUTHClient {
  // configure OAUTH 2 client ..
  self.requestSerializer = [AFHTTPRequestSerializer serializer];
  self.responseSerializer = [AFJSONResponseSerializer serializer];
  self.useHTTPBasicAuthentication = NO;
}

- (NSString *)_absoluteURLStringWithPath:(NSString *)path {

  return (path)
             ? [self.configuration.baseURL URLByAppendingPathComponent:path]
                   .absoluteString
             : self.configuration.baseURL.absoluteString;
}

#pragma mark - requests
- (void)authenticateWithPath:(NSString *)path
                    userName:(NSString *)userName
                    password:(NSString *)password
                       scope:(NSString *)scope
                     success:(void (^)(AFOAuthCredential *))success
                     failure:(void (^)(NSError *))failure {

  __weak typeof(self) weakSelf = self;
  NSAssert(self.configuration.baseURL != nil,
           @"Server base URL cannot be nil.");

  NSString *actualPath = [self _absoluteURLStringWithPath:path];

  [self authenticateUsingOAuthWithURLString:actualPath
                                   username:userName
                                   password:password
                                      scope:scope
                                    success:success
                                    failure:failure];
}

@end