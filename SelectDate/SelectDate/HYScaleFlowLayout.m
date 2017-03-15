//
//  HYScaleFlowLayout.m
//  SelectDate
//
//  Created by 韩扬 on 2017/3/15.
//  Copyright © 2017年 韩扬. All rights reserved.
//

#import "HYScaleFlowLayout.h"

@interface HYScaleFlowLayout()

@property (nonatomic, assign) CGFloat previousOffsetX;

@end

@implementation HYScaleFlowLayout

#pragma mark - Override
- (void)prepareLayout
{
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
    self.minimumLineSpacing = 10;//间距
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width/7 - 60, 40);
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray * attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    CGFloat offset = CGRectGetMidX(visibleRect);
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes  * attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = offset - attribute.center.x;
        
        //离中心越近缩放程度越小，离中心越远缩放程度越大（此处离得越远缩的越小)
        CGFloat scaleForDistance = distance / self.itemSize.height;
        CGFloat scaleForCell = 1 + 0.2 * (1 - fabs(scaleForDistance));
        
        attribute.transform3D = CATransform3DMakeScale(1, scaleForCell, 1);
        attribute.zIndex = 1;
        
    }];
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //分页以1/7处
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 7.0) {
        self.previousOffsetX += self.collectionView.frame.size.width - self.minimumLineSpacing * 6;
    }else if(proposedContentOffset.x < self.previousOffsetX + self.itemSize.width / 7.0){
        self.previousOffsetX -= self.collectionView.frame.size.width - self.minimumLineSpacing * 6;
    }
    
    proposedContentOffset.x = self.previousOffsetX;
    
    return proposedContentOffset;
}
@end
