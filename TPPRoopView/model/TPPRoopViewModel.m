//
//  TPPRoopViewModel.m
//  TPPRoopView
//
//  Created by Mac on 10/9/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TPPRoopViewModel.h"

@implementation TPPRoopViewModel

- (NSString *)id {
    if(!_id) {
        _id = NSUUID.UUID.UUIDString;
    }
    return _id;
}

@end
