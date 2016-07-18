//
//  GGCRSupernatantView.m
//  ZombieMovie
//
//  Created by dujia on 16/7/10.
//  Copyright © 2016年 sun. All rights reserved.
//

#import "GGCRSupernatantView.h"
#import "GGChatRoomView.h"

#import "GGCRInputView.h"
#import "ALinBottomToolView.h"
#import "ALinLiveAnchorView.h"
#import "ALinLive.h"
#import "ALinCatEarView.h"



CGFloat const crviewheight = 250;
CGFloat const crviewrightGap = 100;


@interface GGCRSupernatantView()<UIScrollViewDelegate , GGChatRoomViewDelegate>

/** 同一个工会的主播/相关主播 */
@property(nonatomic, weak) UIImageView *otherView;

@property (nonatomic , strong) GGCRInputView * inputView;
@property (nonatomic, strong) GGChatRoomView *chatRoomView;
@property (nonatomic , strong) UIScrollView *mScrollView;
/** 底部的工具栏 */
@property(nonatomic, weak) ALinBottomToolView *toolView;

/** 顶部主播相关视图 */
@property(nonatomic, weak) ALinLiveAnchorView *anchorView;

/** 同类型直播视图 */
@property(nonatomic, weak) ALinCatEarView *catEarView;

/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;

@property (nonatomic , strong) UIView *controlView;

@end

@implementation GGCRSupernatantView
- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    
        
        CGRect rect = GGMainScreenFrame;
        
//        self.userInteractionEnabled = NO;
        
        
        _mScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _mScrollView.backgroundColor = [UIColor clearColor];
        _mScrollView.delegate = self;
        _mScrollView.pagingEnabled = YES;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.contentSize = CGSizeMake(CGRectGetWidth(frame) * 2, CGRectGetHeight(frame));
        [self addSubview:_mScrollView];
        
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _controlView.backgroundColor = [UIColor clearColor];
        
        [_mScrollView addSubview:_controlView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_mScrollView addGestureRecognizer:tap];
        
        
        _chatRoomView = [[GGChatRoomView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rect) - crviewheight, CGRectGetWidth(rect) - crviewrightGap, crviewheight)];
        [_controlView addSubview:_chatRoomView];
        _chatRoomView.backgroundColor = [UIColor clearColor];
        _chatRoomView.delegate = self;
        
        
        _inputView = [[GGCRInputView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mScrollView.frame), CGRectGetWidth(frame), 50)];
    
        [self addSubview:_inputView];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.toolView.hidden = NO;
        self.otherView.hidden = NO;
        
    }
    return self;
}

- (void) tap:(UITapGestureRecognizer *)gesture
{
    [_inputView.inputTextField resignFirstResponder];
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    CGRect rect = GGMainScreenFrame;
     NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    GGWeakObj(self);
    [UIView animateWithDuration:0.3f animations:^{
        GGStrongObj(self);
        [self.mScrollView setY:- CGRectGetHeight(keyboardF) - 50];
         [self.inputView setY:CGRectGetHeight(rect) - CGRectGetHeight(keyboardF) - 50];
    }];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    GGWeakObj(self);
    [UIView animateWithDuration:0.3f animations:^{
        GGStrongObj(self);
        [self.mScrollView setY:0 ];
        [self.inputView setY:CGRectGetMaxY(self.mScrollView.frame)];
    }];
}

- (void)showInputView:(UIButton *)sender
{
    [_inputView.inputTextField becomeFirstResponder];
   
    
}


bool _isSelected = NO;
- (ALinBottomToolView *)toolView
{
    if (!_toolView) {
        ALinBottomToolView *toolView = [[ALinBottomToolView alloc] init];
        [toolView setClickToolBlock:^(LiveToolType type) {
            switch (type) {
                case LiveToolTypePublicTalk:
//                    _isSelected = !_isSelected;
//                    _isSelected ? [_renderer start] : [_renderer stop];
                    break;
                case LiveToolTypePrivateTalk:
                    
                    break;
                case LiveToolTypeGift:
                    
                    break;
                case LiveToolTypeRank:
                    
                    break;
                case LiveToolTypeShare:
                    
                    break;
                case LiveToolTypeClose:
//                    [self quit];
                    break;
                default:
                    break;
            }
        }];
        [self.controlView addSubview:toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-10);
            make.height.equalTo(@40);
        }];
        _toolView = toolView;
    }
    return _toolView;
}

-(void)setLive:(ALinLive *)live
{
    _live = live;
    self.anchorView.live = live;
}

- (ALinLiveAnchorView *)anchorView
{
    if (!_anchorView) {
        ALinLiveAnchorView *anchorView = [ALinLiveAnchorView liveAnchorView];
        [anchorView setClickDeviceShow:^(bool isSelected) {
//            if (_moviePlayer) {
//                _moviePlayer.shouldShowHudView = !isSelected;
//            }
        }];
        [self.controlView addSubview:anchorView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@120);
            make.top.equalTo(@0);
        }];
        _anchorView = anchorView;
    }
    return _anchorView;
}

- (void)setRelateLive:(ALinLive *)relateLive
{
    _relateLive = relateLive;
    // 设置相关主播
    if (relateLive) {
        self.catEarView.live = relateLive;
    }else{
        self.catEarView.hidden = YES;
    }

}

- (ALinCatEarView *)catEarView
{
    if (!_catEarView) {
        ALinCatEarView *catEarView = [ALinCatEarView catEarView];
        [self.controlView addSubview:catEarView];
        [catEarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCatEar)]];
        [catEarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(self.controlView);
            make.width.height.equalTo(@98);
        }];
        _catEarView = catEarView;
    }
    return _catEarView;
}


- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.controlView.frame.size.width-50,self.controlView.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
        [self.controlView.layer addSublayer:emitterLayer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

- (void)clearEmitterLayer
{
    // 如果切换主播, 取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
}

- (void)clearCatEarView
{
    if (_catEarView) {
        [_catEarView removeFromSuperview];
        _catEarView = nil;
    }

}

- (UIImageView *)otherView
{
    if (!_otherView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)]];
        [self.controlView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.catEarView);
            make.bottom.equalTo(self.catEarView.mas_top).offset(-40);
        }];
        _otherView = imageView;
    }
    return _otherView;
}

- (void)hiddenEmitterLayer
{
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}

- (void)clickCatEar
{
    if ([_delegate respondsToSelector:@selector(clickCatEar)]) {
        [_delegate clickCatEar];
    }
}

- (void)clickOther
{
    if ([_delegate respondsToSelector:@selector(clickOther)]) {
        [_delegate clickOther];
    }
}

@end
