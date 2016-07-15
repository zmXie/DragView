//
//  UIDragButton.h
//  Draging
//
//  Created by makai on 13-1-8.
//  Copyright (c) 2013年 makai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    up = 0,
    down = 1,
}Location;

@class UIDragButton;

@protocol UIDragButtonDelegate <NSObject>

- (void)arrangeUpButtonsWithButton:(UIDragButton *)dragButton andAdd:(BOOL)_bool;
- (void)arrangeDownButtonsWithButton:(UIDragButton *)dragButton andAdd:(BOOL)_bool;
- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;
- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;
- (void)checkLocationOfOthersWithButton:(UIDragButton *)shakingButton;
- (void)removeShakingButton:(UIDragButton *)button fromUpButtons:(BOOL)_bool;

@end

@class DragView;

static const float BtnWidth = 240/4.0;
static  const float BtnHeight = 30;
static  const float BtnSpace = 8;
static  const int Columns = 4;



@interface UIDragButton : UIButton
{
    DragView *superView;
    CGPoint lastPoint;
    NSTimer *timer;
}

@property (nonatomic, assign) Location location;
@property (nonatomic, assign) CGPoint lastCenter;
@property (nonatomic, assign) id<UIDragButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame inView:(DragView *)view delegate:(id<UIDragButtonDelegate>)aDelegate;

@end
