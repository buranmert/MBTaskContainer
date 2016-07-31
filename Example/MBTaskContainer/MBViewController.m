//
//  MBViewController.m
//  MBTaskContainer
//
//  Created by Mert Buran on 07/31/2016.
//  Copyright (c) 2016 Mert Buran. All rights reserved.
//

#import "MBViewController.h"
#import "MBDataController.h"

@interface MBViewController () <MBTaskContainerDelegate>

@property (nonatomic, strong) MBDataController *dataController;
@property (nonatomic, strong) MBTaskContainer *serialTaskContainer;
@property (nonatomic, strong) MBTaskContainer *parallelTaskContainer;

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataController = [MBDataController new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.serialTaskContainer = [self.dataController seriallyGetRepositoriesOrganizationsMembers];
    self.serialTaskContainer.delegate = self;
    
    self.parallelTaskContainer = [self.dataController parallelGetRepositoriesOrganizationsMembers];
    self.parallelTaskContainer.delegate = self;
}

- (void)taskContainer:(MBTaskContainer *)taskContainer didAddNewTask:(NSURLSessionTask *)task {
    if ([taskContainer isEqual:self.parallelTaskContainer]) {
        NSLog(@"parallel");
    }
    else if ([taskContainer isEqual:self.serialTaskContainer]) {
        NSLog(@"serial");
    }
    NSLog(@"didAddNewTask: %@", task.originalRequest.URL.absoluteString);
    NSLog(@"didAddNewTask taskCount: %lu", [taskContainer getTasks].count);
}

- (void)taskContainer:(MBTaskContainer *)taskContainer didRemoveTask:(NSURLSessionTask *)task {
    if ([taskContainer isEqual:self.parallelTaskContainer]) {
        NSLog(@"parallel");
    }
    else if ([taskContainer isEqual:self.serialTaskContainer]) {
        NSLog(@"serial");
    }
    NSLog(@"didRemoveTask: %@", task.originalRequest.URL.absoluteString);
    NSLog(@"didRemoveTask taskCount: %lu", [taskContainer getTasks].count);
}

@end
