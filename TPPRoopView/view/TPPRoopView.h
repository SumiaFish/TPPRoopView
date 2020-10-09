//
//  TPPRoopView.h
//  TPPRoopView
//
//  Created by Mac on 10/9/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPPRoopViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPPRoopView : UIView

/** default: 1 */
@property (assign, nonatomic) NSTimeInterval duration;
/** default: NO */
@property (assign, nonatomic) BOOL isRepeat;
/** row height, default: 44 */
@property (assign, nonatomic) CGFloat rowHeight;

- (void)setData:(NSArray<TPPRoopViewModel *> * _Nullable)data;

- (void)play;
- (void)pause;
- (BOOL)isPause;

@end

NS_ASSUME_NONNULL_END
