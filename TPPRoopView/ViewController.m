//
//  ViewController.m
//  TPPRoopView
//
//  Created by Mac on 10/9/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"

#import "TPPRoopView.h"

@interface ViewController ()

@property (strong, nonatomic) TPPRoopView *roopView;

@property (strong, nonatomic) NSMutableArray<TPPRoopViewModel *> *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.roopView];
    
    [self loadData];
    self.roopView.data = self.data;
    self.roopView.duration = 2;
    self.roopView.backgroundColor = UIColor.lightGrayColor;
    [self.roopView play];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.roopView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 300);
}

- (void)loadData {
    [self.data removeAllObjects];
    
    for (NSInteger i = 0; i < 5; i++) {
        TPPRoopViewModel *model = [[TPPRoopViewModel alloc] init];
        model.text = @(i).stringValue;
        [self.data addObject:model];
    }
}


- (TPPRoopView *)roopView {
    if (!_roopView) {
        TPPRoopView *view = [[TPPRoopView alloc] initWithFrame:CGRectZero];
        
        _roopView = view;
    }
    
    return _roopView;
}

- (NSMutableArray<TPPRoopViewModel *> *)data {
    if (!_data) {
        _data = NSMutableArray.array;
    }
    
    return _data;
}

@end
