//
//  ZXSegmentHeaderView.h
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import <UIKit/UIKit.h>
#import "ZXSegmentHeaderModel.h"

typedef void(^HeaderViewBlock) (NSUInteger index);

@interface ZXSegmentHeaderView : UICollectionView
- (instancetype _Nullable)initWithModel:(ZXSegmentHeaderModel* _Nonnull)model
                      withContainerView:(UIView* _Nonnull)containerView
                       withDefaultIndex:(NSUInteger)defaultIndex
                         withTitleColor:(UIColor*)titleColor
                 withTitleSelectedColor:(UIColor*)titleSelectedColor
                        withSliderColor:(UIColor*)sliderColor
                              withBlock:(HeaderViewBlock _Nullable)block;

- (void)clickHeaderViewWithIndex:(NSUInteger)index;

@property (nonatomic,assign,readonly) NSUInteger index;

@end
