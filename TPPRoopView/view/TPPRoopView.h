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
/** max rows, default: 2 */
@property (assign, nonatomic) NSInteger maxRows;
/** row height, default: 44 */
@property (assign, nonatomic) CGFloat rowHeight;
/** default: (20, 20, 20, 20) */
@property (assign, nonatomic) UIEdgeInsets insets;
/** line space, default: 8 */
@property (assign, nonatomic) CGFloat lineSpace;

- (void)setData:(NSArray<TPPRoopViewModel *> * _Nullable)data;
- (NSArray<TPPRoopViewModel *> *)data;

- (void)play;
- (void)pause;
- (BOOL)isPause;
- (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
