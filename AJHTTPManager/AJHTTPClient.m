//
//  AJHTTPClient.m
//  AJRESTSuite
//
//  Copyright (c) 2015 Ajith R Nayak. All rights reserved.
//

#import "AJHTTPClient.h"
#import "AJConfiguration.h"

typedef void (^AJHTTPRequestRetryBlock)(AJHTTPRequestCompletionBlock block);


@implementation AJHTTPClient

#pragma mark - Initializer

+ (instancetype)httpClientWithConfiguration:(AJConfiguration *)configuration {
  return [[[self class] alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(AJConfiguration *)configuration {

  if (self = [super initWithBaseURL:nil]) {
    _configuration = configuration;
    [self _configureHttpClient];
  }
  return self;
}

#pragma mark - Private

- (void)_configureHttpClient {
  AFJSONRequestSerializer *requestSerializer =
      [AFJSONRequestSerializer serializer];
  [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  self.requestSerializer = requestSerializer;

  self.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (NSString *)_absoluteURLStringWithPath:(NSString *)path {
  return [self.configuration.baseURL URLByAppendingPathComponent:path]
      .absoluteString;
}

#pragma mark - HTTP Requests

- (void)request:(AJHTTPRequestType)requestType
           path:(NSString *)path
     parameters:(NSDictionary *)parameters
     completion:(AJHTTPRequestCompletionBlock)completion {
    
	switch (requestType) {
		case AJHTTPRequestGET:
			[self GET:path parameters:parameters completion:completion];
			break;

		case AJHTTPRequestHEAD:
			[self HEAD:path parameters:parameters completion:completion];
			break;

		case AJHTTPRequestPOST:
			[self POST:path parameters:parameters completion:completion];
			break;

		case AJHTTPRequestPUT:
			[self PUT:path parameters:parameters completion:completion];
			break;

		case AJHTTPRequestPATCH:
			[self PATCH:path parameters:parameters completion:completion];
			break;

		case AJHTTPRequestDELETE:
			[self DELETE:path parameters:parameters completion:completion];
			break;

		default:
			NSLog(@"WARNING! What on earth was that request?!");
			break;
	}
}

#pragma mark - Helper

- (void)GET:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(AJHTTPRequestCompletionBlock)completion {
    
  __weak typeof(self) weakSelf = self;
  [self executeRetryBlock:^(AJHTTPRequestCompletionBlock retry) {
    NSAssert(self.configuration.baseURL != nil,
             @"Server base URL cannot be nil.");

    NSString *actualPath = [weakSelf _absoluteURLStringWithPath:path];

    [weakSelf GET:actualPath
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
          if (retry != NULL) {
            retry(responseObject, nil);
          }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (retry != NULL) {
            retry(nil, error);
          }
        }];
  } completion:completion];
}

- (void)HEAD:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(AJHTTPRequestCompletionBlock)block {
  // todo : HEAD request from HTTP client
  NSLog(@"WARNING! HEAD isn't implemented yet. Curse me!");
}

- (void)POST:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(AJHTTPRequestCompletionBlock)completion {
    
  __weak typeof(self) weakSelf = self;
  [self executeRetryBlock:^(AJHTTPRequestCompletionBlock retry) {
    NSAssert(self.configuration.baseURL != nil,
             @"Server base URL cannot be nil.");

    NSString *actualPath = [weakSelf _absoluteURLStringWithPath:path];

    [weakSelf POST:actualPath
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
          if (retry != NULL) {
            retry(responseObject, nil);
          }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (retry != NULL) {
            retry(nil, error);
          }
        }];
  } completion:completion];
}

- (void)PUT:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(AJHTTPRequestCompletionBlock)completion {
    
  __weak typeof(self) weakSelf = self;
  [self executeRetryBlock:^(AJHTTPRequestCompletionBlock retry) {
    NSAssert(self.configuration.baseURL != nil,
             @"Server base URL cannot be nil.");

    NSString *actualPath = [weakSelf _absoluteURLStringWithPath:path];

    [weakSelf PUT:actualPath
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
          if (retry != NULL) {
            retry(responseObject, nil);
          }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (retry != NULL) {
            retry(nil, error);
          }
        }];
  } completion:completion];
}

- (void)PATCH:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(AJHTTPRequestCompletionBlock)block {
  // todo : PATCH request from HTTP client
  NSLog(@"WARNING! PATCH isn't implemented yet. Curse me!");
}

- (void)DELETE:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(AJHTTPRequestCompletionBlock)completion {
    
  __weak typeof(self) weakSelf = self;
  [self executeRetryBlock:^(AJHTTPRequestCompletionBlock retry) {
    NSAssert(self.configuration.baseURL != nil,
             @"Server base URL cannot be nil.");

    NSString *actualPath = [weakSelf _absoluteURLStringWithPath:path];

    [weakSelf DELETE:actualPath
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
          if (retry != NULL) {
            retry(responseObject, nil);
          }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (retry != NULL) {
            retry(nil, error);
          }
        }];
  } completion:completion];
}

#pragma mark - Goodies

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
  [self.requestSerializer setValue:value forHTTPHeaderField:field];
}

- (void)cancelAllRequests {
  for (NSURLSessionTask *task in self.tasks) {
    [task cancel];
  }
}

#pragma mark - Minion

- (void)executeRetryBlock:(AJHTTPRequestRetryBlock)retriable
               completion:(AJHTTPRequestCompletionBlock)completion {
    
  static NSUInteger retriesCounter = 0;
  __weak typeof(self) weakSelf = self;
    
  retriable(^(id responseObject, NSError *error) {
    if (error == nil || retriesCounter == self.configuration.numberOfRetries) {
      if (completion != NULL) {
        completion(responseObject, error);
      }
      retriesCounter = 0;
    } else {
      retriesCounter++;
      NSTimeInterval waitDuration = self.configuration.retryDelay;

      dispatch_time_t gcdDuration = dispatch_time(
          DISPATCH_TIME_NOW, (int64_t)(waitDuration * NSEC_PER_SEC));

      dispatch_after(gcdDuration, dispatch_get_main_queue(), ^{
        [weakSelf executeRetryBlock:retriable completion:completion];
      });
    }
  });
}

@end