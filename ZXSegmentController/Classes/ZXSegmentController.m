//
//  ZXSegmentController.m
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import "ZXSegmentController.h"
#import <Masonry/Masonry.h>
#import "ZXSegmentHeaderView.h"


@interface ZXSegmentController ()

@property (nonatomic,weak) ZXSegmentHeaderView* headerView;

@property (nonatomic,strong) NSArray* names;
@property (nonatomic,strong) NSArray* indexs;
@property (nonatomic,strong) NSArray* controllers;
@property (nonatomic,weak) UIViewController* currentController;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UIColor* titleColor;
@property (nonatomic,strong) UIColor* titleSelectedColor;
@property (nonatomic,strong) UIColor* sliderColor;
@property (nonatomic,assign) NSInteger maxDisplayItem;
@property (nonatomic,assign) CGFloat itemHeight;
@property (nonatomic,assign) CGFloat fontSize;

//左右滑动手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation ZXSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //延迟执行,等待ZXSegmentController在父view中的autolayout生效.
    dispatch_async(dispatch_get_main_queue(), ^{
        ZXSegmentHeaderModel* model = [[ZXSegmentHeaderModel alloc] init];
        model.names = self.names;
        model.indexs = self.indexs;
        
        ZXSegmentHeaderView* headerView = [[ZXSegmentHeaderView alloc] initWithModel:model
                                                                   withContainerView:self.view
                                                                    withDefaultIndex:self.index
                                                                      withTitleColor:self.titleColor
                                                              withTitleSelectedColor:self.titleSelectedColor
                                                                     withSliderColor:self.sliderColor
                                                                           withBlock:^(NSUInteger index) {
            //切换控制器
            UIViewController* newController = (UIViewController*)self.controllers[index];
            [self replaceController:self.currentController newController:newController];
        }
                                                                  withMaxDisplayItem:6
                                                                      withItemHeight:40
                                                                        withFontSize:20];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endScrollingAnimation:)
                                                     name:ZXSegmentHeaderViewDidEndScrollingAnimation
                                                   object:nil];

        
        [self.view addSubview:(self.headerView = headerView)];
        self.view.backgroundColor = [UIColor grayColor];

        for ( UIViewController* item in self.controllers ){
            [self addChildViewController:item];
            
            if ( [item isEqual:(UIViewController*)self.controllers[self.index]] ){
                //设置默认控制器
                [self.view addSubview:item.view];
                self.currentController = item;
            }
        }
        [self createAutolayout];
        [self createLeftWithRightSwipeGesture];
    });
}

- (void)createLeftWithRightSwipeGesture{
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:_rightSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer*)sender{
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        //左滑...
        NSInteger newIndex = self.headerView.index+1;
        if ( newIndex < self.controllers.count ){
//            NSLog(@"%ld",newIndex);
            [self.headerView clickHeaderViewWithIndex:[NSIndexPath indexPathForRow:newIndex inSection:0]];
        }
    }
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        //右滑...
        NSInteger newIndex = self.headerView.index-1;
        if ( newIndex >= 0 ){
//            NSLog(@"%ld",newIndex);
            [self.headerView clickHeaderViewWithIndex:[NSIndexPath indexPathForRow:newIndex inSection:0]];
        }
    }
}

- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names
                   withDefaultIndex:(NSUInteger)index
                     withTitleColor:(UIColor* _Nullable)titleColor
             withTitleSelectedColor:(UIColor* _Nullable)titleSelectedColor
                    withSliderColor:(UIColor* _Nullable)sliderColor
                 withMaxDisplayItem:(NSInteger)maxDisplayItem
                     withItemHeight:(CGFloat)itemHeight
                       withFontSize:(CGFloat)fontSize{
    if ( self = [self initWithControllers:controllers
                           withTitleNames:names
                         withDefaultIndex:index
                           withTitleColor:titleColor
                   withTitleSelectedColor:titleSelectedColor
                          withSliderColor:sliderColor] ){
        _maxDisplayItem = maxDisplayItem;
        _itemHeight = itemHeight;
        _fontSize = fontSize;
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names
                   withDefaultIndex:(NSUInteger)index
                     withTitleColor:(UIColor* _Nullable)titleColor
             withTitleSelectedColor:(UIColor* _Nullable)titleSelectedColor
                    withSliderColor:(UIColor* _Nullable)sliderColor{
    if ( self = [self initWithControllers:controllers withTitleNames:names withDefaultIndex:index] ){
        self.titleColor = titleColor;
        self.titleSelectedColor = titleSelectedColor;
        self.sliderColor = sliderColor;
    }
    return self;
};


- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names
                   withDefaultIndex:(NSUInteger)index{
    if ( self = [self initWithControllers:controllers withTitleNames:names] ){
        self.index = index;
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray* _Nonnull)controllers
                     withTitleNames:(NSArray* _Nonnull)names{
    if ( self = [super init] ){
        _names = names;
        _controllers = controllers;
        
        //初始化index
        NSMutableArray* indexs = [NSMutableArray array];
        for ( NSUInteger index = 0 ; index < names.count ; index++ ){
            [indexs addObject:[NSNumber numberWithUnsignedInteger:index]];
        }
        _indexs = indexs;
    }
    return self;
}



- (void)createAutolayout{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [_currentController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的子视图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    if ( [oldController isEqual:newController] ){
        return ;
    }

    [self transitionFromViewController:oldController
                      toViewController:newController
                              duration:0
                               options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                [newController.view mas_updateConstraints:^(MASConstraintMaker *make) {
                                    make.top.equalTo(self.headerView.mas_bottom);
                                    make.right.left.bottom.mas_equalTo(0);
                                }];
                            }completion:^(BOOL finished) {
                                if (finished) {
                                    self.currentController = newController;
                                }else{
                                    self.currentController = oldController;
                                }
                            }];
}

- (void)setEnableSwipeGestureRecognizer:(BOOL)enableSwipeGestureRecognizer{
    _enableSwipeGestureRecognizer = enableSwipeGestureRecognizer;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.leftSwipeGestureRecognizer.enabled = self.enableSwipeGestureRecognizer;
        self.rightSwipeGestureRecognizer.enabled = self.enableSwipeGestureRecognizer;
    });
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    self.index = index;
    self.headerView.selecting = YES;
    [self.headerView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    if ( !animated ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endScrollingAnimation:nil];
        });
    }
    
}

- (void)endScrollingAnimation:(NSNotification*)notic{
    [self.headerView clickHeaderViewWithIndex:[NSIndexPath indexPathForRow:_index inSection:0]];
    self.headerView.selecting = NO;
}


@end
