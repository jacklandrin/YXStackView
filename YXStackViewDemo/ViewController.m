//
//  ViewController.m
//  YXStackViewDemo
//
//  Created by 刘博 on 2017/10/12.
//  Copyright © 2017年 刘博. All rights reserved.
//

#import "ViewController.h"
#import "YXStackView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YXStackView *toolbar = [[YXStackView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    toolbar.spacing = 10.0;
    toolbar.isAutoFitEdge = YES;
//    toolbar.axis = YXStackViewAxisVertical;
//    toolbar.reverse = YES;
    
    [self.view addSubview:toolbar];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    view1.backgroundColor = [UIColor redColor];
    
    YXStackViewItem *item1 = [[YXStackViewItem alloc] init];
    item1.style = YXStackViewItemStyleCustom;
    item1.customView = view1;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    view2.backgroundColor = [UIColor blueColor];
    
    YXStackViewItem *item2 = [[YXStackViewItem alloc] init];
    item2.style = YXStackViewItemStyleCustom;
    item2.customView = view2;
    
    
    YXStackViewItem *space = [[YXStackViewItem alloc] init];
    space.style = YXStackViewItemStyleFlexibleSpace;
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    view3.backgroundColor = [UIColor purpleColor];
    
    YXStackViewItem *item3 = [[YXStackViewItem alloc] init];
    item3.style = YXStackViewItemStyleCustom;
    item3.customView = view3;
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view4.backgroundColor = [UIColor greenColor];
    
    YXStackViewItem *item4 = [[YXStackViewItem alloc] init];
    item4.style = YXStackViewItemStyleCustom;
    item4.customView = view4;
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    view5.backgroundColor = [UIColor brownColor];
    
    YXStackViewItem *item5 = [[YXStackViewItem alloc] init];
    item5.style = YXStackViewItemStyleCustom;
    item5.customView = view5;
    
    toolbar.columnSpacing = 10;
    [toolbar setItems:@[item1, item2, item3, item4, item5]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
