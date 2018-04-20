//
//  ZXSegmentHeaderCell.m
//  ZXSegmentController
//
//  Created by 谢泽鑫 on 2018/4/11.
//

#import "ZXSegmentHeaderCell.h"
#import <Masonry/Masonry.h>
#import "ZXSegmentHeaderModel.h"
#import "UIColor+RGB.h"

@implementation ZXSegmentHeaderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame] ){
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
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
    }
    return self;
}

- (void)createAutolayout{
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-3);
    }];
    
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(-6);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(3);
    }];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self judgeStatus];
}

- (void)didClickBtn:(UIButton*)sender{
    if ( !self.isSelected ){
        if ( self.block ){
            self.block(self);
        }
        self.selected = YES;
    }
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
        make.width.mas_equalTo([self caculateSliderViewWidth]*0.75);
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

- (void)becomeDefaultIndex{
    [self didClickBtn:self.button];
}


- (void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = _sliderColor?_sliderColor:[UIColor colorWithR:140 G:140 B:140];
}

@end
