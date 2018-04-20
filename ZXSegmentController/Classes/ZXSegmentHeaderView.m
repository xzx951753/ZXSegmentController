//
//  ZXSegmentHeaderView.m
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import "ZXSegmentHeaderView.h"
#import "ZXSegmentHeaderCell.h"


#define MaxDisplayItem 6
#define ItemHeight 40.0

@interface ZXSegmentHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) ZXSegmentHeaderModel* model;
@property (nonatomic,strong) HeaderViewBlock block;
@property (nonatomic,weak) UIView* containerView;
@property (nonatomic,strong) NSMutableDictionary* cellIdentifierDict;
@property (nonatomic,strong) NSMutableArray* cellArray;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,strong) UIColor* titleColor;
@property (nonatomic,strong) UIColor* titleSelectedColor;
@property (nonatomic,strong) UIColor* sliderColor;
@end

@implementation ZXSegmentHeaderView

- (instancetype _Nullable)initWithModel:(ZXSegmentHeaderModel* _Nonnull)model
                      withContainerView:(UIView* _Nonnull)containerView
                       withDefaultIndex:(NSUInteger)defaultIndex
                         withTitleColor:(UIColor*)titleColor
                 withTitleSelectedColor:(UIColor*)titleSelectedColor
                        withSliderColor:(UIColor*)sliderColor
                              withBlock:(HeaderViewBlock _Nullable)block{
    //创建flowLayout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //横向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //行间距
    flowLayout.minimumLineSpacing = 0;
    //列间距
    flowLayout.minimumInteritemSpacing = 0;
    //外边距
    flowLayout.sectionInset = UIEdgeInsetsZero;
    //最大item显示数(如果标题按钮大于6个，则只显示6个，如果小于6个，则显示self.model.values.count个)
    NSInteger maxItem = 0;
    if ( model.indexs.count < MaxDisplayItem ){
        maxItem = model.indexs.count;
    }else{
        maxItem = MaxDisplayItem;
    }
    //item宽度：
    flowLayout.itemSize = CGSizeMake(containerView.frame.size.width / maxItem, ItemHeight);
    
    
    if ( self = [super initWithFrame:CGRectZero collectionViewLayout:flowLayout] ){
        _model = model;
        _block = block;
        _containerView = containerView;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.currentIndex = defaultIndex;
        self.titleColor = titleColor;
        self.titleSelectedColor = titleSelectedColor;
        self.sliderColor = sliderColor;
        
        self.scrollEnabled = YES;
        if ( model.indexs.count < MaxDisplayItem ){
            self.scrollEnabled = NO;
        }
        
        /*横竖屏切换通知*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
    }
    return self;
}

- (NSInteger)numberOfSections{
    [self choiceCell];
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.indexs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ( _cellArray == nil ){
        _cellArray = [NSMutableArray array];
    }
    
    /**
     该段代码用于解决使用registerClass注册cell后，因重用机制，
     导致cell每次重用时isSelected状态会被清空，特此为每个cell在地址池申请注册，
     通过不同的identifier把cell的内存地址固定住
     start
     **/
    if ( _cellIdentifierDict == nil ) {
        _cellIdentifierDict = [NSMutableDictionary dictionary];
    }
    
    NSString *identifier = [_cellIdentifierDict objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    
    if(identifier == nil){
        identifier = [NSString stringWithFormat:@"selectedBtn%@", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellIdentifierDict setObject:identifier forKey:[NSString  stringWithFormat:@"%@",indexPath]];
        // 注册Cell
        [collectionView registerClass:[ZXSegmentHeaderCell class] forCellWithReuseIdentifier:identifier];
    }
    /************************ end ***************************/
    
    
    
    ZXSegmentHeaderCell* headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //取出数据
    NSString* cellTitle = self.model.names[indexPath.row];
    NSUInteger index = [[self.model.indexs objectAtIndex:indexPath.row] integerValue];
    headerCell.index = index;
    headerCell.title = cellTitle;
    
    headerCell.titleColor = self.titleColor;
    headerCell.titleSelectedColor = self.titleSelectedColor;
    headerCell.sliderColor = self.sliderColor;
    
    //遍历_cellArray查找是否已有cell,如果有则不需要重复添加cell
    NSInteger find = 0;
    for ( ZXSegmentHeaderCell* item in _cellArray ){
        if ( [item isEqual:headerCell] ){
            find += 1;
        }
    }
    if ( find == 0 ){
        [_cellArray addObject:headerCell];
    }

    headerCell.block = ^(ZXSegmentHeaderCell *cell) {
        //还原除当前cell以外的其他按钮
        for ( ZXSegmentHeaderCell* item in self.cellArray ){
            if ( ![item isEqual:cell] ){
                item.selected = NO;
            }
        }
        
        self.currentIndex = cell.index;
        [self choiceCell];
        
        // 执行控制器翻页.......
        self.block(cell.index);
    };

    return headerCell;
}



/**
 之所以用GCD是因为该段代码需要在初始的cell加载完成后才能执行。 因为要选择一个默认的cell，
 然而它还没有被加载到cellArray中，如果此时强行访问cellArray中越界部分的数组，
 将会导致cash。
 使用GCD把该段代码放到主线程队列的最后位置，等初始cell加载完成后，再通过scrollToItemAtIndexPath
 滚动到defaultIndex位置。scrollToItemAtIndexPath滚动的同时会再加载新的cell, 然而这段时间是有延时的，
 并不会马上加载完，所以开启RunLoop循环，直到defaultIndex对应的cell被加载到cellArray中，再对其进行becomeDefaultIndex操作。
 **/
- (void)choiceCell{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(choiceCellHandler:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    });
}

- (void)choiceCellHandler:(NSTimer*)timer{
    if ( self.cellArray.count > self.currentIndex ){
        ZXSegmentHeaderCell* cell = (ZXSegmentHeaderCell*)self.cellArray[self.currentIndex];
        if ( cell ){
            [cell becomeDefaultIndex];
        }
        [timer invalidate];
        timer = nil;
    };
}


- (void)clickHeaderViewWithIndex:(NSUInteger)index{
    self.currentIndex = index;
    [self choiceCell];
}

- (NSUInteger)index{
    return _currentIndex;
}

- (void)changeRotate:(NSNotification*)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
        //最大item显示数(如果标题按钮大于6个，则只显示6个，如果小于6个，则显示self.model.values.count个)
        NSInteger maxItem = 0;
        if ( self.model.indexs.count < MaxDisplayItem ){
            maxItem = self.model.indexs.count;
        }else{
            maxItem = MaxDisplayItem;
        }
        //item宽度：
        flowLayout.itemSize = CGSizeMake(self.containerView.frame.size.width / maxItem, ItemHeight);
    });
}

@end
