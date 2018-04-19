//
//  ZXSegmentController.h
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import <UIKit/UIKit.h>

@interface ZXSegmentController : UIViewController
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

//开启或关闭手势
@property (nonatomic,assign) BOOL enableSwipeGestureRecognizer;

@end
