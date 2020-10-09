//
//  TPPRoopView.m
//  TPPRoopView
//
//  Created by Mac on 10/9/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TPPRoopView.h"

#import "TPPRoopViewCell.h"

@interface TPPRoopViewEmptyModel : TPPRoopViewModel

@end

@implementation TPPRoopViewEmptyModel

@end

@interface TPPRoopView ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (assign, nonatomic) BOOL isRun;
@property (strong, nonatomic) NSMutableArray<TPPRoopViewModel *> *listData;

@end

@implementation TPPRoopView

- (instancetype)init {
    return [[self.class alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        
        self.rowHeight = 44;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark -

- (void)setData:(NSArray<TPPRoopViewModel *> *)data {
    [self.listData removeAllObjects];
    !data ?: [self.listData addObjectsFromArray:data.copy];
    
    [self.collectionView reloadData];
}

- (void)play {
    if (self.isRun) {
        return;
    }
    
    self.isRun = YES;
    [self render];
}

- (void)pause {
    if (!self.isRun) {
        return;
    }
    
    self.isRun = NO;
    [self render];
}

- (BOOL)isPause {
    return !self.isRun;
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPPRoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TPPRoopViewModel *model = self.listData[indexPath.item];
    if ([model isKindOfClass:TPPRoopViewEmptyModel.class]) {
        cell.model = nil;
    } else {
        cell.model = model;
    }
    
    cell.contentView.backgroundColor = UIColor.whiteColor;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width-20*2, self.rowHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

#pragma mark -

- (void)render {
    if (!self.isRun) {
        return;
    }
    
    if (self.listData.count <= 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self render];
        });
        
        return;
    }
    
    TPPRoopViewModel *model = self.listData.lastObject;
    [self.listData removeObject:model];
    [self.listData insertObject:TPPRoopViewEmptyModel.new atIndex:0];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.listData.count-1 inSection:0]]];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    } completion:^(BOOL finished) {
        
        [self.listData replaceObjectAtIndex:0 withObject:model];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self render];
    });
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        [view registerClass:TPPRoopViewCell.class forCellWithReuseIdentifier:@"cell"];
        view.backgroundColor = UIColor.clearColor;
        
        _collectionView = view;
    }
    
    return _collectionView;
}

- (NSMutableArray<TPPRoopViewModel *> *)listData {
    if (!_listData) {
        _listData = NSMutableArray.array;
    }
    
    return _listData;
}

- (NSTimeInterval)duration {
    if (_duration <= 1) {
        _duration = 1;
    }
    
    return _duration;
}

- (CGFloat)rowHeight {
    if (_rowHeight < 0.1) {
        _rowHeight = 0.1;
    }
    
    return _rowHeight;
}

@end
