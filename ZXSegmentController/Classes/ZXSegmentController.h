//
//  ZXSegmentController.h
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//
// 注：可根据实际情况选用ZXSegmentController或ZXSegmentHeaderView， 前者使用控制器做页面切换，后者仅仅是一个segmentView，可根据自身需求定制插件

#import <UIKit/UIKit.h>

@interface ZXSegmentController : UIViewController
/*通过重载创建分段控制器*/
- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names;

- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names
                   withDefaultIndex:(NSUInteger)index;

- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names
                   withDefaultIndex:(NSUInteger)index
                     withTitleColor:(UIColor* _Nullable)titleColor
             withTitleSelectedColor:(UIColor* _Nullable)titleSelectedColor
                    withSliderColor:(UIColor* _Nullable)sliderColor;

- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names
                   withDefaultIndex:(NSUInteger)index
                     withTitleColor:(UIColor* _Nullable)titleColor
             withTitleSelectedColor:(UIColor* _Nullable)titleSelectedColor
                    withSliderColor:(UIColor* _Nullable)sliderColor
                 withMaxDisplayItem:(NSInteger)maxDisplayItem
                     withItemHeight:(CGFloat)itemHeight
                       withFontSize:(CGFloat)fontSize;

//页面切换
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
//开启或关闭手势
@property (nonatomic,assign) BOOL enableSwipeGestureRecognizer;

@end
