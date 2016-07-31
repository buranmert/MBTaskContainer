//
//  MBDataController.m
//  MBTaskContainer
//
//  Created by Mert Buran on 7/31/16.
//  Copyright © 2016 Mert Buran. All rights reserved.
//

#import "MBDataController.h"

typedef void(^AsyncCompletion)(NSError *error);

static NSString * const repositoriesURL = @"/repositories";
static NSString * const organizationsURL = @"/organizations";
static NSString * const membersURL = @"/orgs/Augmentedev/public_members";

@interface MBDataController ()

@property (nonatomic, strong) NSURLSession *URLSession;

@end

@implementation MBDataController

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.URLSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (MBTaskContainer *)parallelGetRepositoriesOrganizationsMembers {
    MBTaskContainer *taskContainer = [MBTaskContainer new];
    
    NSURLSessionTask *repositories = [self fetchDataWithRelativeURL:repositoriesURL completion:nil];
    [taskContainer addTask:repositories];
    
    NSURLSessionTask *organizations = [self fetchDataWithRelativeURL:organizationsURL completion:nil];
    [taskContainer addTask:organizations];
    
    NSURLSessionTask *members = [self fetchDataWithRelativeURL:membersURL completion:nil];
    [taskContainer addTask:members];
    
    return taskContainer;
}

- (MBTaskContainer *)seriallyGetRepositoriesOrganizationsMembers {
    MBTaskContainer *taskContainer = [MBTaskContainer new];
    
    NSURLSessionTask *repositories = [self fetchDataWithRelativeURL:repositoriesURL completion:^(NSError *error) {
        if (error == nil) {
            NSURLSessionTask *organizations = nil;
            organizations = [self fetchDataWithRelativeURL:organizationsURL completion:^(NSError *error) {
                if (error == nil) {
                    NSURLSessionTask *members = nil;
                    members = [self fetchDataWithRelativeURL:membersURL completion:nil];
                    
                    [taskContainer addTask:members];
                }
            }];
            
            [taskContainer addTask:organizations];
        }
    }];
    
    [taskContainer addTask:repositories];
    
    return taskContainer;
}

- (NSURLSessionTask *)fetchDataWithRelativeURL:(NSString *)relativeURL completion:(AsyncCompletion)completion {
    NSURLSessionDataTask *dataTask = nil;
    static NSString * const baseURL = @"https://api.github.com";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, relativeURL]];
    dataTask = [self.URLSession dataTaskWithURL:URL
                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                  if (completion != nil) {
                                      completion(error);
                                  }
                              }];
    [dataTask resume];
    return dataTask;
}

@end
