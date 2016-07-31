//
//  MBTaskContainer.h
//  Pods
//
//  Created by Mert Buran on 7/31/16.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double MBTaskContainerVersionNumber;
FOUNDATION_EXPORT const unsigned char MBTaskContainerVersionString[];

#import <MBTaskContainer/MBTaskContainerDelegate.h>

typedef NS_ENUM(NSUInteger, MBTaskContainerState) {
    MBTaskContainerStateDefault = 0,
    MBTaskContainerStateSuspending,
    MBTaskContainerStateCancelling,
};

@interface MBTaskContainer : NSObject

@property (atomic) MBTaskContainerState state;
@property (nonatomic, weak) id<MBTaskContainerDelegate> delegate;

- (BOOL)addTask:(NSURLSessionTask *)newTask;
- (NSArray<NSURLSessionTask*> *)getTasks;

@end
