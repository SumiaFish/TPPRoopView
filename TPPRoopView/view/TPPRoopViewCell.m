//
//  TPPRoopViewCell.m
//  TPPRoopView
//
//  Created by Mac on 10/9/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TPPRoopViewCell.h"

@interface TPPRoopViewCell ()

@property (strong, nonatomic) UILabel *lab;

@end

@implementation TPPRoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.lab];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lab.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

- (void)setModel:(TPPRoopViewModel *)model {
    _model = model;
    
    self.lab.text = model.text;
}

- (UILabel *)lab {
    if (!_lab) {
        UILabel *lab = UILabel.new;
        
        _lab = lab;
    }
    
    return _lab;
}

@end
