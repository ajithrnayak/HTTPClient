//
//  AJOAuthConfiguration.m
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.

#import "AJOAuthConfiguration.h"

@implementation AJOAuthConfiguration

- (instancetype)initWithServerURL:(NSURL *)serverURL
                         clientID:(NSString *)clientID
                     clientSecret:(NSString *)secret
                            scope:(NSString *)scope {
  NSParameterAssert(clientID);

  self = [super initWithServerURL:serverURL];

  if (!self) {
    return nil;
  }

  _clientID = clientID;
  _clientSecret = secret;
  _scope = scope;

  return self;
}

@end
