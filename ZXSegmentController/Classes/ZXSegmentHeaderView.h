//
//  ZXSegmentHeaderView.h
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//  可单独使用ZXSegmentHeaderView 创建分段控制View

#import <UIKit/UIKit.h>
#import "ZXSegmentHeaderModel.h"

typedef void(^HeaderViewBlock) (NSUInteger index);


//static NSNotificationName  = @"didEndScrollingAnimation";
#define ZXSegmentHeaderViewDidEndScrollingAnimation @"didEndScrollingAnimation"

@interface ZXSegmentHeaderView : UICollectionView
- (instancetype _Nullable)initWithModel:(ZXSegmentHeaderModel* _Nonnull)model
                      withContainerView:(UIView* _Nonnull)containerView
                       withDefaultIndex:(NSUInteger)defaultIndex
                         withTitleColor:(UIColor*)titleColor
                 withTitleSelectedColor:(UIColor*)titleSelectedColor
                        withSliderColor:(UIColor*)sliderColor
                              withBlock:(HeaderViewBlock _Nullable)block;

- (instancetype _Nullable)initWithModel:(ZXSegmentHeaderModel* _Nonnull)model
                      withContainerView:(UIView* _Nonnull)containerView
                       withDefaultIndex:(NSUInteger)defaultIndex
                         withTitleColor:(UIColor*)titleColor
                 withTitleSelectedColor:(UIColor*)titleSelectedColor
                        withSliderColor:(UIColor*)sliderColor
                              withBlock:(HeaderViewBlock _Nullable)block
                     withMaxDisplayItem:(NSInteger)maxDisplayItem
                         withItemHeight:(CGFloat)itemHeight
                           withFontSize:(CGFloat)fontSize;



- (void)clickHeaderViewWithIndex:(NSIndexPath*)indexPath;

@property (nonatomic,assign) BOOL selecting;
@property (nonatomic,assign,readonly) NSUInteger index;


@end
