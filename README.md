# MBTaskContainer

[![CI Status](http://img.shields.io/travis/Mert Buran/MBTaskContainer.svg?style=flat)](https://travis-ci.org/Mert Buran/MBTaskContainer)
[![Version](https://img.shields.io/cocoapods/v/MBTaskContainer.svg?style=flat)](http://cocoapods.org/pods/MBTaskContainer)
[![License](https://img.shields.io/cocoapods/l/MBTaskContainer.svg?style=flat)](http://cocoapods.org/pods/MBTaskContainer)
[![Platform](https://img.shields.io/cocoapods/p/MBTaskContainer.svg?style=flat)](http://cocoapods.org/pods/MBTaskContainer)

## What is MBTaskContainer?

`MBTaskContainer` is a simple class that lets you add your `NSURLSessionTask`s into it and read active tasks from it safely.

### Example scenario

Let's say your server use `OAuth2` authentication standard, so you need to obtain a token before establishing a connection to access your `API`
And again, let's say your application has an architecture like the following:

`ViewController` -> `DataController` *_where_*

1. `ViewController`
  - Typical `UIViewController` subclass
  - it may have an `UIButton` to cancel ongoing network operations
2. `DataController`
  - `NSObject` subclass
  - responsible for making network calls

In that case, we *_cannot_* return actual ongoing network tasks to `ViewController` from `DataController` immediately as even a simple network request would be like the following:

1. `ViewController` calls `DataController`'s `getItems` method
2. `DataController` makes the request
3. Request returns `401 Unauthorized` responsible
4. `DataController` makes another request to obtain a new token
5. After receiving new token, `DataController` retries `getItems` request

In short, there will be many request that are done asynchronously and some follow the others.
In order to address this problem, you can use `MBTaskContainer`!

### Example solution

1. Returns an `MBTaskContainer` instance from `DataController:getItems`.
2. Whenever a new network task is created, add it to returned instance.
3. `ViewController` can access active network tasks at any time.

### Why can't we do that with NSArray?

1. `MBTaskContainer` lets you add/read tasks from multiple threads in a safe way.
  - Multiple readers and single writer/remover at a time.
2. `MBTaskContainer` takes care of removal. You don't need to remove completed tasks.

### Example Usage

```Objective-C
// DataController.m
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

// ViewController.m
...
self.serialTaskContainer = [self.dataController seriallyGetRepositoriesOrganizationsMembers];
NSArray *activeTasks = [self.serialTaskContainer getTasks];
...
// To cancel ongoing and potential new tasks
self.serialTaskContainer.state = MBTaskContainerStateCancelling;
...
```

### Installation

MBTaskContainer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MBTaskContainer"
```

## Author

Mert Buran, buranmert@gmail.com

## License

MBTaskContainer is available under the MIT license. See the LICENSE file for more info.
