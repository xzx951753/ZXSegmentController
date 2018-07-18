//
//  ZXSegmentHeaderView.m
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import "ZXSegmentHeaderView.h"
#import "ZXSegmentHeaderCell.h"


#define MaxDisplayItem 4
#define ItemHeight 60.0
#define FontSize 17

@interface ZXSegmentHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) ZXSegmentHeaderModel* model;
@property (nonatomic,strong) HeaderViewBlock block;
@property (nonatomic,weak) UIView* containerView;
@property (nonatomic,strong) NSMutableDictionary* cellIdentifierDict;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,strong) UIColor* titleColor;
@property (nonatomic,strong) UIColor* titleSelectedColor;
@property (nonatomic,strong) UIColor* sliderColor;
@property (nonatomic,assign) NSInteger maxDisplayItem;
@property (nonatomic,assign) CGFloat itemHeight;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat scaleFontSize;
@property (nonatomic,assign) BOOL firstInit;
@end

@implementation ZXSegmentHeaderView


- (instancetype _Nullable)initWithModel:(ZXSegmentHeaderModel* _Nonnull)model
                      withContainerView:(UIView* _Nonnull)containerView
                       withDefaultIndex:(NSUInteger)defaultIndex
                         withTitleColor:(UIColor*)titleColor
                 withTitleSelectedColor:(UIColor*)titleSelectedColor
                        withSliderColor:(UIColor*)sliderColor
                              withBlock:(HeaderViewBlock _Nullable)block
                     withMaxDisplayItem:(NSInteger)maxDisplayItem
                         withItemHeight:(CGFloat)itemHeight
                           withFontSize:(CGFloat)fontSize{
    _maxDisplayItem = maxDisplayItem;
    _itemHeight = itemHeight;
    _fontSize = fontSize;
    return [self initWithModel:model withContainerView:containerView withDefaultIndex:defaultIndex withTitleColor:titleColor withTitleSelectedColor:titleSelectedColor withSliderColor:sliderColor withBlock:block];
}

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
    if ( model.indexs.count < self.maxDisplayItem ){
        maxItem = model.indexs.count;
    }else{
        maxItem = self.maxDisplayItem;
    }
    //item宽度：
    flowLayout.itemSize = CGSizeMake(containerView.frame.size.width / maxItem, self.itemHeight);
    
    
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
        if ( model.indexs.count < self.maxDisplayItem ){
            self.scrollEnabled = NO;
        }
        
        /*横竖屏切换通知*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
    }
    return self;
}

- (NSInteger)numberOfSections{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.indexs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
    NSString *identifier = [self.cellIdentifierDict objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if(identifier == nil){
        identifier = [NSString stringWithFormat:@"selectedBtn%@", [NSString stringWithFormat:@"%@", indexPath]];
        [self.cellIdentifierDict setObject:identifier forKey:[NSString  stringWithFormat:@"%@",indexPath]];
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
    headerCell.indexPath = indexPath;
    headerCell.titleColor = self.titleColor;
    headerCell.titleSelectedColor = self.titleSelectedColor;
    headerCell.sliderColor = self.sliderColor;
    //设置title字体大小
    [headerCell.button.titleLabel setFont:[UIFont systemFontOfSize:self.scaleFontSize]];
    headerCell.block = ^(ZXSegmentHeaderCell *cell) {
        // 执行控制器翻页.......
        self.block(cell.index);
        self.currentIndex = cell.indexPath.row;
        [self scrollToItemAtIndexPath:cell.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    };
    return headerCell;
}

/*选中cell*/
- (void)clickHeaderViewWithIndex:(NSIndexPath*)indexPath{
    ZXSegmentHeaderCell* headerCell = [self collectionView:self cellForItemAtIndexPath:indexPath];
    [headerCell didClickBtn:headerCell.button];
    self.currentIndex = indexPath.row;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath* visibleIndexPath = ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]);
    if( indexPath.row == visibleIndexPath.row ){
        dispatch_async(dispatch_get_main_queue(),^{
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        });
    }
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated{
    [super scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    if ( !self.firstInit ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clickHeaderViewWithIndex:[NSIndexPath indexPathForRow:self.index inSection:0]];
            self.firstInit = YES;
        });
    }
}



- (NSUInteger)index{
    return _currentIndex;
}

- (void)changeRotate:(NSNotification*)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
        //最大item显示数(如果标题按钮大于6个，则只显示6个，如果小于6个，则显示self.model.values.count个)
        NSInteger maxItem = 0;
        if ( self.model.indexs.count < self.maxDisplayItem ){
            maxItem = self.model.indexs.count;
        }else{
            maxItem = self.maxDisplayItem;
        }
        //item宽度：
        flowLayout.itemSize = CGSizeMake(self.containerView.frame.size.width / maxItem, self.itemHeight);
    });
}

- (NSInteger)maxDisplayItem{
    if ( _maxDisplayItem == 0 ){
        return MaxDisplayItem;
    }
    return _maxDisplayItem;
}

- (CGFloat)itemHeight{
    if ( _itemHeight == 0 ){
        return ItemHeight;
    }
    return _itemHeight;
}

- (CGFloat)fontSize{
    if ( _fontSize == 0 ){
        return FontSize;
    }
    return _fontSize;
}

- (CGFloat)scaleFontSize{
    if ( _fontSize == 0 ){
        return FontSize * 0.78;
    }
    return self.fontSize * 0.78;
}

- (NSMutableDictionary *)cellIdentifierDict{
    /**
     该段代码用于解决使用registerClass注册cell后，因重用机制，
     导致cell每次重用时isSelected状态会被清空，特此为每个cell在地址池申请注册，
     通过不同的identifier把cell的内存地址固定住
     start
     **/
    if ( _cellIdentifierDict == nil ) {
        _cellIdentifierDict = [NSMutableDictionary dictionary];
    }
    return _cellIdentifierDict;
}

//当scrollToItemAtIndexPath方法以动画方式滚动结束后，会触发该代理方法,这里让scrollToItemAtIndexPath结束后，发送一个通知。
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //动画结束...
    if ( self.selecting ){
        [[NSNotificationCenter defaultCenter] postNotificationName:ZXSegmentHeaderViewDidEndScrollingAnimation object:self];
    }
}



@end
