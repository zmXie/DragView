//
//  RootViewController.m
//  DragView
//
//  Created by cnfol on 14-1-10.
//  Copyright (c) 2014年 cnfol. All rights reserved.
//

#import "RootViewController.h"
#import "DragView.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    DragView* dragView = [[DragView alloc] initWithFrame:CGRectMake(10, 60, 300, 250)];
    dragView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    dragView.layer.cornerRadius = 3;
    dragView.layer.masksToBounds = YES;
    dragView.layer.borderWidth = .5;
    dragView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:dragView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
