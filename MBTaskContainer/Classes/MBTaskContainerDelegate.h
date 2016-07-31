//
//  MBTaskContainerDelegate.h
//  Pods
//
//  Created by Mert Buran on 7/31/16.
//
//

#import <Foundation/Foundation.h>

@class MBTaskContainer;

@protocol MBTaskContainerDelegate <NSObject>

@optional

- (void)taskContainer:(MBTaskContainer *)taskContainer didAddNewTask:(NSURLSessionTask *)task;
- (void)taskContainer:(MBTaskContainer *)taskContainer didRemoveTask:(NSURLSessionTask *)task;

@end
