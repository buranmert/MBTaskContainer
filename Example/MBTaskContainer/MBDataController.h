//
//  MBDataController.h
//  MBTaskContainer
//
//  Created by Mert Buran on 7/31/16.
//  Copyright © 2016 Mert Buran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBTaskContainer/MBTaskContainer.h>

@interface MBDataController : NSObject

- (MBTaskContainer *)parallelGetRepositoriesOrganizationsMembers;
- (MBTaskContainer *)seriallyGetRepositoriesOrganizationsMembers;

@end
