//
//  ZXViewController.m
//  ZXSegmentController
//
//  Created by xzx951753 on 04/11/2018.
//  Copyright (c) 2018 xzx951753. All rights reserved.
//

#import "ZXViewController.h"
#import <Masonry/Masonry.h>
#import <ZXSegmentController/ZXSegmentController.h>

@interface ZXViewController ()

@property (nonatomic,weak) ZXSegmentController* segmentController;

@end

@implementation ZXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIViewController*  VC_1 = [[UITableViewController alloc] init];
    VC_1.view.backgroundColor = [UIColor redColor];
    UIViewController*  VC_2 = [[UITableViewController alloc] init];
    VC_2.view.backgroundColor = [UIColor yellowColor];
    UIViewController*  VC_3 = [[UITableViewController alloc] init];
    VC_3.view.backgroundColor = [UIColor greenColor];
    UIViewController*  VC_4 = [[UITableViewController alloc] init];
    VC_4.view.backgroundColor = [UIColor blueColor];
    UIViewController*  VC_5 = [[UITableViewController alloc] init];
    VC_5.view.backgroundColor = [UIColor orangeColor];
    UIViewController*  VC_6 = [[UITableViewController alloc] init];
    VC_6.view.backgroundColor = [UIColor grayColor];
    UIViewController*  VC_7 = [[UITableViewController alloc] init];
    VC_7.view.backgroundColor = [UIColor brownColor];
    UIViewController*  VC_8 = [[UIViewController alloc] init];
    VC_8.view.backgroundColor = [UIColor purpleColor];
    UIViewController*  VC_9 = [[UIViewController alloc] init];
    VC_9.view.backgroundColor = [UIColor blackColor];
    UIViewController*  VC_10 = [[UITableViewController alloc] init];
    
    
    NSArray* names = @[@"头条",@"视频",@"娱乐",@"体育",@"段子",@"新时代",@"本地",@"网易号",@"微咨询",@"财经"];
    NSArray* controllers = @[VC_1,VC_2,VC_3,VC_4,VC_5,VC_6,VC_7,VC_8,VC_9,VC_10];
    
    
    /*
     *   controllers长度和names长度必须一致，否则将会导致cash
     *   segmentController在一个屏幕里最多显示6个按钮，如果超过6个，将会自动开启滚动功能，如果不足6个，按钮宽度=父view宽度/x  (x=按钮个数)
     */
    ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                               withTitleNames:names
                                                                             withDefaultIndex:8
                                                                               withTitleColor:[UIColor grayColor]
                                                                       withTitleSelectedColor:[UIColor redColor]
                                                                              withSliderColor:[UIColor redColor]];
    [self addChildViewController:(_segmentController = segmentController)];
    [self.view addSubview:segmentController.view];
    [segmentController didMoveToParentViewController:self];
    [self createAutolayout];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [segmentController scrollToIndex:1 animated:YES];
    //    });
    /*
     *  横竖屏切换通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}



- (void)createAutolayout{
    /*
        高度自由化的布局，可以根据需求，把segmentController布局成你需要的样子.(面对不同的场景，设置不同的top距离)
     */
    [_segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self changeRotate:nil];
}

- (void)changeRotate:(NSNotification*)noti{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [self.segmentController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
        }];
    } else {
        //横屏
        [self.segmentController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
