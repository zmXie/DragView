//
//  DragView.h
//  DragView
//
//  Created by cnfol on 14-1-10.
//  Copyright (c) 2014年 cnfol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragView : UIView
{
    UIView* upView;
    UIView* downView;
    UILabel* otherChannelLabel;
    UIImageView* otherChannelImageView;
    UILabel* noChannelLabel;
    
    NSMutableArray *upButtonsArray;
    NSMutableArray *downButtonsArray;

}

-(float)midHeight;
-(NSInteger)upButtonsArrayCount;

@end
