//
//  TPPRoopViewCell.h
//  TPPRoopView
//
//  Created by Mac on 10/9/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPPRoopViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPPRoopViewCell : UICollectionViewCell

@property (weak, nonatomic) TPPRoopViewModel *model;

@end

NS_ASSUME_NONNULL_END
