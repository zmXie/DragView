//
//  UIDragButton.m
//  Draging
//
//  Created by makai on 13-1-8.
//  Copyright (c) 2013年 makai. All rights reserved.
//

#import "UIDragButton.h"
#import <QuartzCore/QuartzCore.h>
#import "DragView.h"



@implementation UIDragButton
@synthesize location;
@synthesize lastCenter;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame inView:(DragView *)view delegate:(id<UIDragButtonDelegate>)aDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastCenter = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
        superView = view;
        self.delegate = aDelegate;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:longPress];
        [longPress release];    
        
    }
    return self;
}




- (void)drag:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:superView];
    [superView bringSubviewToFront:self];
        switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            {
                [self setAlpha:0.7];
                lastPoint = point;
                [self.layer setShadowColor:[UIColor grayColor].CGColor];
                [self.layer setShadowOpacity:1.0f];
                [self.layer setShadowRadius:10.0f];
                self.backgroundColor = [UIColor lightGrayColor];
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, BtnWidth+10, BtnHeight+10);
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            float offX = point.x - lastPoint.x;
            float offY = point.y - lastPoint.y;
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            if (self.center.y <= superView.midHeight) {
                if (self.location != up) {
                    //down->up
                    [self setLastCenter:CGPointMake(0, 0)];
                    [self setLocation:up];
                    if ([delegate respondsToSelector:@selector(arrangeDownButtonsWithButton:andAdd:)]) {
                        [delegate arrangeDownButtonsWithButton:self andAdd:NO];
                    }
                    [UIView animateWithDuration:.2 animations:^{
                        [self setFrame:CGRectMake(self.center.x + offX - (BtnWidth+10)/2.0, self.center.y + offY - (BtnHeight+10)/2.0, BtnWidth+10, BtnHeight+10)];
                    }];
                }
            }else{
                if (self.location!= down) {
                    if (superView.upButtonsArrayCount == 1) {
                        NSLog(@"我的频道至少要有一个");
                        if ([self.delegate respondsToSelector:@selector(setUpButtonsFrameWithAnimate:withoutShakingButton:)]) {
                            [self.delegate setUpButtonsFrameWithAnimate:YES withoutShakingButton:nil];
                        }
                        return;
                    }

                    //up->down
                    [self setLastCenter:CGPointMake(0, 0)];
                    [self setLocation:down];
                    
                    if ([delegate respondsToSelector:@selector(arrangeDownButtonsWithButton:andAdd:)]) {
                        [delegate arrangeUpButtonsWithButton:self andAdd:NO];
                    }

                    [UIView animateWithDuration:.2 animations:^{
                        [self setFrame:CGRectMake(self.center.x + offX - (BtnWidth+10)/2.0, self.center.y + offY - (BtnHeight+10)/2.0, BtnWidth+10, BtnHeight+10)];
                    }];
                }
            }
            lastPoint = point;
            if ([delegate respondsToSelector:@selector(checkLocationOfOthersWithButton:)]) {
                [delegate checkLocationOfOthersWithButton:self];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self setAlpha:1];
            self.backgroundColor = [UIColor clearColor];
            switch (self.location) {
                case up:
                {
                    self.location = up;
                    [self.layer setShadowOpacity:0];
                    
                    if ([self.delegate respondsToSelector:@selector(setUpButtonsFrameWithAnimate:withoutShakingButton:)]) {
                        [self.delegate setUpButtonsFrameWithAnimate:YES withoutShakingButton:nil];
                    }
                }
                    break;
                case down:
                {
                    [self setLocation:down];
                    [self.layer setShadowOpacity:0];
                    
                    if ([self.delegate respondsToSelector:@selector(setDownButtonsFrameWithAnimate:withoutShakingButton:)]) {
                        [self.delegate setDownButtonsFrameWithAnimate:YES withoutShakingButton:nil];
                    }
                }
                    break;
                default:
                    break;
            }

            break;
        case UIGestureRecognizerStateCancelled:
            [self setAlpha:1];
            break;
        case UIGestureRecognizerStateFailed:
            [self setAlpha:1];
            break;
        default:
            break;
    }
}



-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = .2;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
    
    switch (tag) {
        case 0:
        {
            [self setTitle:@"要闻" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self setTitle:@"财经" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [self setTitle:@"股票" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [self setTitle:@"理财" forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            [self setTitle:@"直播" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [self setTitle:@"基金" forState:UIControlStateNormal];
        }
            break;
        case 6:
        {
            [self setTitle:@"黄金" forState:UIControlStateNormal];
            
        }
            break;
        case 7:
        {
            [self setTitle:@"外汇" forState:UIControlStateNormal];
        }
            break;
        case 8:
        {
            [self setTitle:@"期货" forState:UIControlStateNormal];
        }
            break;
        case 9:
        {
            [self setTitle:@"港股" forState:UIControlStateNormal];
        }
            break;
        case 10:
        {
            [self setTitle:@"在线交流" forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithRed:110.0/255.0 green:149.0/255.0 blue:237.0/255.0 alpha:1] forState:UIControlStateNormal];
        }
            break;
        default:
            [self setTitle:@"****" forState:UIControlStateNormal];

            break;
    }
}

@end
