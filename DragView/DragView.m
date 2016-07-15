//
//  DragView.m
//  DragView
//
//  Created by cnfol on 14-1-10.
//  Copyright (c) 2014年 cnfol. All rights reserved.
//

#import "DragView.h"
#import "UIDragButton.h"

static float centerDistance = 23;//两个按钮的中心距离

@interface DragView () <UIDragButtonDelegate>

@end

@implementation DragView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        [self layoutBgView];
    }
    return self;
}

#pragma mark 添加背景图

-(void)layoutBgView
{
    //布局
    UILabel * myChannel = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, 70, 20)];
    myChannel.backgroundColor = [UIColor clearColor];
    myChannel.text = @"我的频道";
    myChannel.font = [UIFont fontWithName:@"Arial" size:16];
    [self addSubview:myChannel];
    
    UIImageView * addImgV = [[UIImageView alloc]initWithFrame:CGRectMake(87, 19, 11, 12)];
    addImgV.backgroundColor = [UIColor redColor];
    addImgV.image = [UIImage imageNamed:@"Info01"];
    [self addSubview:addImgV];

    UILabel * stateChannel = [[UILabel alloc]initWithFrame:CGRectMake(105   , 15 , 150, 20)];
    stateChannel.backgroundColor = [UIColor clearColor];
    stateChannel.textAlignment = NSTextAlignmentCenter;
    stateChannel.text = @"长按拖动可以增删及调序";
    stateChannel.font = [UIFont fontWithName:@"Arial" size:12];
    stateChannel.textColor = [UIColor grayColor];
    [self addSubview:stateChannel];
    
    upView = [[UIView alloc]initWithFrame:CGRectMake(10, 40, 280, 46)];
    upView.backgroundColor = [UIColor whiteColor];
    upView.layer.cornerRadius = 3;
    upView.layer.masksToBounds = YES;
    upView.layer.borderWidth = 1;
    upView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    [self addSubview:upView];

    otherChannelLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, upView.frame.origin.y + upView.frame.size.height + 5, 70, 20)];
    otherChannelLabel.backgroundColor = [UIColor clearColor];
    otherChannelLabel.text = @"其他频道";
    otherChannelLabel.font = [UIFont fontWithName:@"Arial" size:16];
    [self addSubview:otherChannelLabel];
    
    otherChannelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(87, otherChannelLabel.frame.origin.y + 4, 11, 12)];
    otherChannelImageView.image = [UIImage imageNamed:@"Info02"];
    otherChannelImageView.backgroundColor = [UIColor redColor];
    [self addSubview:otherChannelImageView];
    
    downView = [[UIView alloc]initWithFrame:CGRectMake(10, otherChannelImageView.frame.origin.y + otherChannelImageView.frame.size.height + 5, 280, 46)];
    downView.backgroundColor = [UIColor whiteColor];
    //设置圆角
    downView.layer.cornerRadius = 3;
    //设置超出部分剪裁
    downView.layer.masksToBounds = YES;
    downView.layer.borderWidth = 1;
    downView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    [self addSubview:downView];
    
    noChannelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 46)];
    noChannelLabel.backgroundColor = [UIColor clearColor];
    noChannelLabel.text = @"暂无其它频道";
    noChannelLabel.font = [UIFont systemFontOfSize:13];
    [downView addSubview:noChannelLabel];
    noChannelLabel.hidden = YES;
    
    upButtonsArray = [[NSMutableArray alloc] init];
    downButtonsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i++) {
        UIDragButton* btn = [[UIDragButton alloc] initWithFrame:CGRectZero inView:self delegate:self];
        btn.tag = i;
        btn.location = up;
        [self addSubview:btn];
        [upButtonsArray addObject:btn];
    }
    [self setUpButtonsFrameWithAnimate:NO withoutShakingButton:nil];

    for (int i = 4; i < 11; i++) {
        UIDragButton* btn = [[UIDragButton alloc] initWithFrame:CGRectZero inView:self delegate:self];
        btn.tag = i;
        btn.location = down;
        [self addSubview:btn];
        [downButtonsArray addObject:btn];
    }
    [self setDownButtonsFrameWithAnimate:NO withoutShakingButton:nil];
}

#pragma mark - UIDragButtonDelegate

- (void)removeShakingButton:(UIDragButton *)button fromUpButtons:(BOOL)_bool
{
    if (_bool) {
        if ([upButtonsArray containsObject:button]) {
            [upButtonsArray removeObject:button];
        }
    }else{
        if ([downButtonsArray containsObject:button]) {
            [downButtonsArray removeObject:button];
        }
    }
}

- (void)arrangeUpButtonsWithButton:(UIDragButton *)dragButton andAdd:(BOOL)_bool
{
    if (_bool) {
        if (![upButtonsArray containsObject:dragButton]) {
            [upButtonsArray addObject:dragButton];
        }
    }else{
        [upButtonsArray removeObject:dragButton];
        NSInteger insertIndex = [downButtonsArray count];
        for (int i = 0; i <[downButtonsArray count]; i++) {
            UIDragButton *button2 = (UIDragButton *)[downButtonsArray objectAtIndex:i];
            if (CGRectIntersectsRect(dragButton.frame, button2.frame)) {
                float x = dragButton.frame.origin.x - button2.frame.origin.x;
                float y = dragButton.frame.origin.y - button2.frame.origin.y;
                if (sqrtf(x*x + y*y) < centerDistance){
                    insertIndex = i;
                    break;
                }
            }

            if (i == 0) {
                if (dragButton.center.y < button2.center.y && dragButton.center.x <= button2.center.x) {
                    insertIndex = i;
                    break;
                }
            }
            else{
                UIDragButton *button1 = (UIDragButton *)[downButtonsArray objectAtIndex:i - 1];
                if ((dragButton.center.y < button2.center.y) && (dragButton.center.x > button1.center.x) && (dragButton.center.x <= button2.center.x)) {
                    insertIndex = i;
                    break;
                }
            }
        }
        NSLog(@"insertIndex = %d", insertIndex);
        [downButtonsArray insertObject:dragButton atIndex:insertIndex];
    }
    
    if (upButtonsArray.count <= 0) return;
    [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:nil];
}

- (void)arrangeDownButtonsWithButton:(UIDragButton *)dragButton andAdd:(BOOL)_bool
{
    if (_bool) {
        if (![downButtonsArray containsObject:dragButton]) {
            [downButtonsArray addObject:dragButton];
        }
    }
    else{
        [downButtonsArray removeObject:dragButton];
        int insertIndex = [upButtonsArray count];

        NSLog(@"count === %d",upButtonsArray.count);
        for (int i = 0; i < [upButtonsArray count]; i++) {
            UIDragButton *button2 = (UIDragButton *)[upButtonsArray objectAtIndex:i];
            
            if (CGRectIntersectsRect(dragButton.frame, button2.frame)) {
                float x = dragButton.frame.origin.x - button2.frame.origin.x;
                float y = dragButton.frame.origin.y - button2.frame.origin.y;
                if (sqrtf(x*x + y*y) < centerDistance){
                    insertIndex = i;
                    break;
                }
            }
            
            if (i == 0) {
                if (dragButton.center.y < button2.center.y && dragButton.center.x <= button2.center.x) {
                    insertIndex = i;
                    break;
                }
            }else{
                UIDragButton *button1 = (UIDragButton *)[upButtonsArray objectAtIndex:i - 1];
                if ((dragButton.center.y < button2.center.y) && (dragButton.center.x > button1.center.x) && (dragButton.center.x <= button2.center.x)) {
                    insertIndex = i;
                    break;
                }
            }
        }
        [upButtonsArray insertObject:dragButton atIndex:insertIndex];

    }
    if (downButtonsArray.count <= 0) return;
    [self setDownButtonsFrameWithAnimate:YES withoutShakingButton:nil];
    
}

- (void)checkLocationOfOthersWithButton:(UIDragButton *)shakingButton
{
    switch (shakingButton.location) {
        case up:
        {
            int indexOfShakingButton = 0;
            for ( int i = 0; i < [upButtonsArray count]; i++) {
                if (((UIDragButton *)[upButtonsArray objectAtIndex:i]).tag == shakingButton.tag) {
                    indexOfShakingButton = i;
                    break;
                }
            }
            for (int i = 0; i < [upButtonsArray count]; i++) {
                UIDragButton *button = (UIDragButton *)[upButtonsArray objectAtIndex:i];
                if (button.tag != shakingButton.tag){
                    if (CGRectIntersectsRect(shakingButton.frame, button.frame)) {
                        float x = shakingButton.frame.origin.x - button.frame.origin.x;
                        float y = shakingButton.frame.origin.y - button.frame.origin.y;
                        if (sqrtf(x*x + y*y) < centerDistance) {
                            [upButtonsArray removeObject:shakingButton];
                            [upButtonsArray insertObject:shakingButton atIndex:i];
                            [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                        }
                        break;
                    }
                }
            }
            
            break;
        }
        case down:
        {
            int indexOfShakingButton = 0;
            for ( int i = 0; i < [downButtonsArray count]; i++) {
                if (((UIDragButton *)[downButtonsArray objectAtIndex:i]).tag == shakingButton.tag) {
                    indexOfShakingButton = i;
                    break;
                }
            }
            for (int i = 0; i < [downButtonsArray count]; i++) {
                UIDragButton *button = (UIDragButton *)[downButtonsArray objectAtIndex:i];
                if (button.tag != shakingButton.tag){
                    if (CGRectIntersectsRect(shakingButton.frame, button.frame)) {
                        float x = shakingButton.frame.origin.x - button.frame.origin.x;
                        float y = shakingButton.frame.origin.y - button.frame.origin.y;
                        if (sqrtf(x*x + y*y) < centerDistance) {
                            NSLog(@"before=====%@",downButtonsArray);
                            [downButtonsArray removeObject:shakingButton];
                            [downButtonsArray insertObject:shakingButton atIndex:i];
                            NSLog(@"replace===  %@",downButtonsArray);
                            [self setDownButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                        }
                        break;
                    }
                }
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - private methord

- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton
{
    [self adjustBgViewFrame];
    
    int count = [upButtonsArray count];
            if (_bool) {
            [UIView animateWithDuration:0.4 animations:^{
                for (int i = 0; i < count; i++) {
                    UIDragButton *button = (UIDragButton *)[upButtonsArray objectAtIndex:i];
                    if (button != shakingButton) {
                        button.frame = CGRectMake(10 + BtnSpace + i%Columns * (BtnWidth+BtnSpace), upView.frame.origin.y + BtnSpace + i/Columns * (BtnHeight+BtnSpace), BtnWidth, BtnHeight);
                        [button setLastCenter:button.center];
                    }
                }
            }];
        }
        else{
            for (int i = 0; i < count; i++) {
                UIDragButton *button = (UIDragButton *)[upButtonsArray objectAtIndex:i];
                button.frame = CGRectMake(10 + BtnSpace + i%Columns * (BtnWidth+BtnSpace), upView.frame.origin.y + BtnSpace + i/Columns * (BtnHeight+BtnSpace), BtnWidth, BtnHeight);
                [button setLastCenter:button.center];
            }
        }
}

- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton
{
    [self adjustBgViewFrame];
    
           if (_bool) {
            
            [UIView animateWithDuration:0.4 animations:^{
                NSLog(@"downArray === %@",downButtonsArray);
                for (int i = 0; i < [downButtonsArray count]; i++) {
                    UIDragButton *button = (UIDragButton *)[downButtonsArray objectAtIndex:i];
                    if (button != shakingButton) {
                        button.frame = CGRectMake(10 + BtnSpace + i%Columns * (BtnWidth+BtnSpace), downView.frame.origin.y + BtnSpace + i/Columns * (BtnHeight+BtnSpace), BtnWidth, BtnHeight);
                        [button setLastCenter:button.center];
                    }
                }
            }];
            
        }else{
            for (int i = 0; i < [downButtonsArray count]; i++) {
                UIDragButton *button = (UIDragButton *)[downButtonsArray objectAtIndex:i];
                button.frame = CGRectMake(10 + BtnSpace + i%Columns * (BtnWidth+BtnSpace), downView.frame.origin.y + BtnSpace + i/Columns * (BtnHeight+BtnSpace), BtnWidth, BtnHeight);
                [button setLastCenter:button.center];
            }
        }
}

-(void)adjustBgViewFrame
{
    noChannelLabel.hidden = YES;
    float downViewHeight = BtnHeight + 2*BtnSpace;
    if (upButtonsArray.count <= Columns) {
        upView.frame = CGRectMake(10, 40, 280, BtnHeight + 2*BtnSpace);
        downViewHeight = BtnHeight*2 + 3*BtnSpace;
        if (upButtonsArray.count < 3) {
            downViewHeight = BtnHeight*3 + 4*BtnSpace;
        }
    }
    else if (upButtonsArray.count <= 2*Columns){
        upView.frame = CGRectMake(10, 40, 280, BtnHeight*2 + 3*BtnSpace);
        if (upButtonsArray.count < 7) {
            downViewHeight = BtnHeight*2 + 3*BtnSpace;
        }
    }
    else{
        if (upButtonsArray.count == 11) {
            noChannelLabel.hidden = NO;
        }
        upView.frame = CGRectMake(10, 40, 280, BtnHeight*3 + 4*BtnSpace);
    }
    
    otherChannelLabel.frame = CGRectMake(12, upView.frame.origin.y + upView.frame.size.height + 10, 70, 20);
    otherChannelImageView.frame = CGRectMake(87, otherChannelLabel.frame.origin.y + 4, 11, 12);
    downView.frame = CGRectMake(10, otherChannelImageView.frame.origin.y + otherChannelImageView.frame.size.height + 10, 280, downViewHeight);

}

-(float)midHeight
{
    return otherChannelLabel.frame.origin.y;
}

-(NSInteger)upButtonsArrayCount
{
    return upButtonsArray.count;
}

@end
