//
//  AJConfiguration.m
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.

#import "AJConfiguration.h"

@implementation AJConfiguration

#pragma mark - Initializer

- (instancetype)initWithServerURL:(NSURL *)serverURL {
  if (self = [super init]) {
    _serverURL = serverURL;
    _numberOfRetries = 0;
    _retryDelay = 0;
    _apiVersion = 1;
  }
  return self;
}

#pragma mark - Overrides

- (void)setServerURL:(NSURL *)serverURL {
  if (_serverURL == serverURL) {
    return;
  }
  if (![self _hasValidServerURLSyntax:serverURL]) {
    NSLog(@"|WARNING| : %@",
          [NSString
              stringWithFormat:@"URL \"%@\" has invalid syntax", serverURL]);
    NSParameterAssert(serverURL);
  }
  _serverURL = [serverURL copy];
}

- (NSURL *)baseURL {
  if (!self.serverURL) {
    return nil;
  }
  NSString *versionPath =
      (self.apiVersion == 0)
          ? [NSString string]
          : [NSString stringWithFormat:@"v%lu", (unsigned long)self.apiVersion];
  return [[self.serverURL URLByAppendingPathComponent:versionPath]
      URLByAppendingPathComponent:self.resourceName];
}

#pragma mark - Private

- (BOOL)_hasValidServerURLSyntax:(NSURL *)url {
  return url.scheme && url.host;
}

@end
