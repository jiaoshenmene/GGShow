//
//  GGCRSupernatantView.h
//  ZombieMovie
//
//  Created by dujia on 16/7/10.
//  Copyright © 2016年 sun. All rights reserved.
//

@protocol GGCRSupernatantViewDelegate<NSObject>

- (void)clickCatEar;

- (void)clickOther;
@end
#import <UIKit/UIKit.h>
@class ALinLive;
@interface GGCRSupernatantView : UIView

@property (nonatomic , weak) id<GGCRSupernatantViewDelegate> delegate;
/** 直播 */
@property(nonatomic, strong) ALinLive *live;
/** 相关的直播或者主播 */
@property (nonatomic, strong) ALinLive *relateLive;

/** 点击关联主播 */
@property (nonatomic, copy) void (^clickRelatedLive)();


- (void) clearEmitterLayer;

- (void)clearCatEarView;

- (void)hiddenEmitterLayer;
@end
