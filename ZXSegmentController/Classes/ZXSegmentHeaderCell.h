//
//  ZXSegmentHeaderCell.h
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import <UIKit/UIKit.h>

@class ZXSegmentHeaderCell,ZXSegmentHeaderCellModel;
typedef void(^SegmentHeaderCellBlock) (ZXSegmentHeaderCell* cell);

@interface ZXSegmentHeaderCell : UICollectionViewCell

@property (nonatomic,weak) UIButton* button;
@property (nonatomic,copy) ZXSegmentHeaderCellModel* model;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,copy) NSString* title;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,strong) SegmentHeaderCellBlock block;
@property (nonatomic,weak) UIView* sliderView;
@property (nonatomic,strong) UIColor* titleColor;
@property (nonatomic,strong) UIColor* titleSelectedColor;
@property (nonatomic,strong) UIColor* sliderColor;
- (void)becomeDefaultIndex;
@end
