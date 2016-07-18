//
//  GGCloseBtn.m
//  GGShow
//
//  Created by dujia on 16/7/18.
//  Copyright © 2016年 dujia. All rights reserved.
//

#import "GGCloseBtn.h"

@implementation GGCloseBtn

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (NSArray *)tools
{
    return @[@"talk_close_40x40"];
}

- (void)setup
{
    CGFloat wh = 40;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i<self.tools.count; i++) {
        x = 0;
        UIImageView *toolView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
        toolView.userInteractionEnabled = YES;
        toolView.tag = i;
        toolView.image = [UIImage imageNamed:self.tools[i]];
        [toolView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self addSubview:toolView];
    }
}

- (void)click:(UITapGestureRecognizer *)tapRec
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
