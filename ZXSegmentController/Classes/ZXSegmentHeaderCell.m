//
//  ZXSegmentHeaderCell.m
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import "ZXSegmentHeaderCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+RGB.h"

#define kNotificationBound @"kNotificationBound"

@implementation ZXSegmentHeaderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame] ){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        //滑块view
        UIView* sliderView = [[UIView alloc] init];
#pragma mark - 标记：滑块背景色
        sliderView.backgroundColor = [UIColor colorWithR:140 G:140 B:140];
        [self addSubview:(_sliderView = sliderView)];
        [self addSubview:(_button = button)];
        [self createAutolayout];
        [self judgeStatus];
#pragma mark - 标记：按钮背景色
        self.backgroundColor = [UIColor clearColor];
        
        //安装点击事件通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(boundNotificationHander:)
                                                     name:kNotificationBound
                                                   object:nil];
        
    }
    return self;
}

//收到点击事件的通知
- (void)boundNotificationHander:(NSNotification*)notic{
    /*选中cell后，所有按钮都会收到同通知，对比noticCell，如果是通知自己则处理block, 不是通知自己的则弹起按钮*/
    ZXSegmentHeaderCell* noticCell = (ZXSegmentHeaderCell*)notic.object;
    if ( [noticCell.indexPath isEqual:self.indexPath] ){
        self.selected = YES;
        if ( self.block ){
            self.block(self);
        }
    }else{
        self.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self judgeStatus];
}

- (void)createAutolayout{
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(-6);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(3);
    }];
}



- (void)didClickBtn:(UIButton*)sender{
    //向所有cell发送通知,把当前点击的cell作为对象发出
    NSNotification * notice = [NSNotification notificationWithName:kNotificationBound object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
//    NSLog(@"实际指针地址=%p",self);
}

- (void)judgeStatus{
    if ( self.isSelected ){
#pragma mark - 标记：按钮字体选中状态颜色
        [_button setTitleColor:self.titleSelectedColor?self.titleSelectedColor:[UIColor colorWithR:60 G:60 B:60] forState:UIControlStateNormal];
        [self sliderViewWillDisplay];
    }else{
#pragma mark - 标记：按钮字体未选中状态颜色
        [_button setTitleColor:self.titleColor?self.titleColor:[UIColor colorWithR:160 G:160 B:160] forState:UIControlStateNormal];
        [self sliderViewWillDisappear];
    }
}


//滑块出现
- (void)sliderViewWillDisplay{
    [_sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([self caculateSliderViewWidth]*0.6);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

//滑块消失
- (void)sliderViewWillDisappear{
    [_sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

//计算滑块所需要的长度（title文字的长度）
- (CGFloat)caculateSliderViewWidth{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:_button.titleLabel.font forKey:NSFontAttributeName];
    CGSize size = [_button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:dic
                                                        context:nil].size;
    return size.width;
}


- (void)setTitle:(NSString *)title{
    _title = title;
    [_button setTitle:title forState:UIControlStateNormal];
}

/*重写prepareForReuse方法，防止cell在重用时，isSelected状态被清空*/
- (void)prepareForReuse{
}



- (void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = _sliderColor?_sliderColor:[UIColor colorWithR:140 G:140 B:140];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
