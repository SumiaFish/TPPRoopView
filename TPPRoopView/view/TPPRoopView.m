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

@interface TPPRoopViewEmptyCell : TPPRoopViewCell

@end

@implementation TPPRoopViewEmptyCell

@end

@interface TPPRoopView ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (assign, nonatomic) BOOL isRun;
@property (assign, nonatomic) BOOL isChanging;
@property (strong, nonatomic) NSMutableArray<TPPRoopViewModel *> *listData;
@property (assign, nonatomic) NSRange range;
@property (strong, nonatomic) NSArray<TPPRoopViewModel *> *currentData;

@end

@implementation TPPRoopView

- (instancetype)init {
    return [[self.class alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        
        self.rowHeight = 44;
        self.insets = UIEdgeInsetsMake(20, 20, 20, 20);
        self.lineSpace = 8;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(self.insets.left, self.insets.top, self.bounds.size.width - self.insets.left - self.insets.right, self.bounds.size.height - self.insets.top - self.insets.bottom);
}

#pragma mark -

- (void)setData:(NSArray<TPPRoopViewModel *> *)data {
    if (self.isChanging) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.data = data;
        });
        
        return;
    }
    
    self.isChanging = YES;
    
    [self.listData removeAllObjects];
    !data ?: [self.listData addObjectsFromArray:data.copy];
    [self.collectionView reloadData];
    
    self.isChanging  = NO;
}

- (void)setMaxRows:(NSInteger)maxRows {
    self.range = NSMakeRange(0, maxRows < 2 ? 2 : maxRows);
}

- (NSInteger)maxRows {
    return self.range.length;
}

- (NSRange)range {
    if (_range.location == NSNotFound) {
        _range = NSMakeRange(0, 2);
    }
    
    return _range;
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

- (CGFloat)height {
    CGFloat minimumLineSpacing = self.lineSpace;
    UIEdgeInsets insets = self.insets;
    
    return (self.rowHeight * (self.maxRows-1) + minimumLineSpacing * (self.maxRows-1-1)) + insets.top + insets.bottom;
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TPPRoopViewModel *model = self.currentData[indexPath.item];
    BOOL isEmpty = [model isKindOfClass:TPPRoopViewEmptyModel.class];
    TPPRoopViewCell *cell = isEmpty ? [collectionView dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath] : [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = isEmpty ? nil : model;
    cell.contentView.backgroundColor = isEmpty ? UIColor.clearColor : UIColor.whiteColor;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width-20*2, self.rowHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpace;
}

#pragma mark -

- (void)render {
    if (!self.isRun) {
        return;
    }
    
    //
    if (self.maxRows > self.listData.count) {
        return;
    }
    
    //
    if (self.isChanging) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self render];
        });
        
        return;
    }
    
    //
    NSMutableArray<TPPRoopViewModel *> *currentData = NSMutableArray.array;
    void (^ block) (void) = ^ {
        for (NSInteger i = self.range.location; i < self.listData.count; i++) {
            if (currentData.count >= self.maxRows) {
                break;
            }
            
            [currentData addObject:self.listData[i]];
        }
    };
    
    block();
    
    if (currentData.count == 0) {
        self.range = NSMakeRange(self.range.location % self.listData.count, self.maxRows);
        block();
    }
    
    if (currentData.count < self.maxRows) {
        for (NSInteger i = 0; i < self.maxRows - currentData.count; i++) {
            [currentData addObject:self.listData[i]];
        }
    }

    if (currentData.count < self.maxRows ||
        self.isChanging) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self render];
        });
        
        return;
    }
    
    //
    self.isChanging = YES;
    
    //
    self.currentData = currentData;
    TPPRoopViewModel *model1 = currentData.lastObject;
    TPPRoopViewModel *model2 = currentData[currentData.count-2];
    TPPRoopViewEmptyModel *emptyModel = TPPRoopViewEmptyModel.new;
    
    [UIView performWithoutAnimation:^{
        [currentData replaceObjectAtIndex:currentData.count-1 withObject:emptyModel];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:currentData.count-1 inSection:0]]];
        
        [currentData replaceObjectAtIndex:currentData.count-2 withObject:emptyModel];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:currentData.count-2 inSection:0]]];
        
        [currentData removeObjectAtIndex:currentData.count-1];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:currentData.count-1 inSection:0]]];
    }];
    
    [self.collectionView performBatchUpdates:^{

           [currentData insertObject:emptyModel atIndex:0];
           [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];

        } completion:^(BOOL finished) {
            
            [self.collectionView performBatchUpdates:^{
                
                [currentData replaceObjectAtIndex:0 withObject:model1];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
                
                [UIView performWithoutAnimation:^{
                    [currentData replaceObjectAtIndex:currentData.count-1 withObject:model2];
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:currentData.count-1 inSection:0]]];
                }];
                
                
            } completion:^(BOOL finished) {
                
                self.range = NSMakeRange(self.range.location + 1, self.range.length);
                self.isChanging = NO;
                
            }];
            
        }];

    //
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
        [view registerClass:TPPRoopViewEmptyCell.class forCellWithReuseIdentifier:@"emptyCell"];
        view.backgroundColor = UIColor.clearColor;
        view.clipsToBounds = YES;
        
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
