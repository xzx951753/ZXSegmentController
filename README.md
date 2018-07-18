# ZXSegmentController
一个可自由调整布局的分段控制器
 

# 示例动画
![IntroduceAnimation](https://raw.githubusercontent.com/xzx951753/ZXSegmentController/master/示例动画.gif "IntroduceAnimation")


# 更新
version 0.1.1 修复切换页面时出现闪动  
version 0.1.2 对ZXSegmentHeaderView进行解耦，可根据实际情况选用ZXSegmentController或ZXSegmentHeaderView， 前者使用控制器做页面切换，后者仅仅是创建一个segmentView，可根据自身需求定制插件，使用方法请参考ZXSegmentController.m中viewDidLoad方法  
version 0.1.3 针对segmentHeaderView的字体大小做优化，在创建对象时的fontSize改为选中button的字体大小，而未选中的按钮字体大小缩小0.78倍。   
version 0.1.4 修复设置defaultIndex时，出现header滚动的不和谐动画，使用通知的方式设置headerView切换.  
version 0.1.5 增加scrollToIndex方法，可以使用代码切换控制器  


## 示例代码
```Objective-C
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

/*使用代码控制跳转到第1个控制器*/
[segmentController scrollToIndex:1 animated:YES];

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
```

## 安装
已上传到trunk，可使用pod安装

```ruby
pod 'ZXSegmentController'
```

## Author

xzx951753, 285644797@qq.com

## License

ZXFilterView is available under the MIT license. See the LICENSE file for more info.
