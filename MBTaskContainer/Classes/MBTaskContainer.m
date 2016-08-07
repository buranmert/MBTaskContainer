//
//  MBTaskContainer.m
//  Pods
//
//  Created by Mert Buran on 7/31/16.
//
//

#import <MBTaskContainer/MBTaskContainer.h>

static char * MBTaskContainerIOQueueIdentifier = "MBTaskContainer.MBTaskContainer.IOQueueIdentifier";

@interface MBTaskContainer ()

@property (atomic, strong) NSMutableArray<NSURLSessionTask*> *tasks;
@property (atomic, strong) dispatch_queue_t IOQueue;

@end

@implementation MBTaskContainer
@synthesize state = _state;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.state = MBTaskContainerStateDefault;
        self.tasks = [NSMutableArray array];
        self.IOQueue = dispatch_queue_create(MBTaskContainerIOQueueIdentifier, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
    for (NSURLSessionTask *task in self.tasks) {
        [task removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    }
}

- (MBTaskContainerState)state {
    @synchronized (self) {
        return _state;
    }
}

- (void)setState:(MBTaskContainerState)state {
    @synchronized (self) {
        _state = state;
        switch (state) {
            case MBTaskContainerStateDefault: {
                break;
            }
            case MBTaskContainerStateSuspending: {
                for (NSURLSessionTask *task in [self getTasks]) {
                    [task suspend];
                }
                break;
            }
            case MBTaskContainerStateCancelling: {
                for (NSURLSessionTask *task in [self getTasks]) {
                    [task cancel];
                }
                break;
            }
        }
    }
}

- (BOOL)addTask:(NSURLSessionTask *)newTask {
    BOOL success = NO;
    switch (self.state) {
        case MBTaskContainerStateDefault: {
            success = [self addUniqueTask:newTask];
            break;
        }
        case MBTaskContainerStateSuspending: {
            [newTask suspend];
            break;
        }
        case MBTaskContainerStateCancelling: {
            [newTask cancel];
            break;
        }
    }
    
    if (success && [self.delegate respondsToSelector:@selector(taskContainer:didAddNewTask:)]) {
        [self.delegate taskContainer:self didAddNewTask:newTask];
    }
    return success;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isKindOfClass:[NSURLSessionTask class]] &&
        [keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
        NSURLSessionTaskState taskNewState = ((NSURLSessionTask *)object).state;
        switch (taskNewState) {
            case NSURLSessionTaskStateCanceling:
            case NSURLSessionTaskStateCompleted: {
                BOOL result = [self removeTaskIfExists:object];
                if (result && [self.delegate respondsToSelector:@selector(taskContainer:didRemoveTask:)]) {
                    [self.delegate taskContainer:self didRemoveTask:object];
                }
                break;
            }
            default: {
                break;
            }
        }
    }
}

#pragma mark - Protected resource section

- (BOOL)addUniqueTask:(NSURLSessionTask *)task {
    __block BOOL success = NO;
    dispatch_barrier_sync(self.IOQueue, ^{
        if ([self.tasks indexOfObject:task] == NSNotFound) {
            success = YES;
            [self.tasks addObject:task];
            [task addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(state))
                      options:NSKeyValueObservingOptionInitial
                      context:NULL];
        }
    });
    return success;
}

- (BOOL)removeTaskIfExists:(NSURLSessionTask *)task {
    __block BOOL success = NO;
    dispatch_barrier_sync(self.IOQueue, ^{
        if ([self.tasks indexOfObject:task] != NSNotFound) {
            success = YES;
            [task removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
            [self.tasks removeObject:task];
        }
    });
    return success;
}

- (NSArray<NSURLSessionTask*> *)getTasks {
    __block NSArray<NSURLSessionTask*> *currentTasks = nil;
    dispatch_sync(self.IOQueue, ^{
        currentTasks = [self.tasks copy];
    });
    return currentTasks;
}

- (void)tasksMayComplete { }

@end
