//
//  YXToolbar.h
//  YXStackViewDemo
//
//  Created by 刘博 on 2017/10/12.
//  Copyright © 2017年 刘博. All rights reserved.
//

#import "YXStackViewItem.h"

typedef enum {
    YXStackViewAxisHorizontal,
    YXStackViewAxisVertical
} YXStackViewAxis;

@interface YXStackView : UIView

@property (nonatomic, assign) YXStackViewAxis axis;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) BOOL reverse;
@property (nonatomic, strong) NSArray<YXStackViewItem*>* items;

@end
