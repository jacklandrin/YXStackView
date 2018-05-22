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
@property (nonatomic, assign) CGFloat columnSpacing;//When isAutoFitEdge is YES, it's avilable
@property (nonatomic, assign) BOOL reverse; //When isAutoFitEdge is NO, it's avilable
@property (nonatomic, strong) NSArray<YXStackViewItem*>* items;
@property (nonatomic, assign) BOOL isAutoFitEdge; //whether item is auto resizing with View，if over view edge stackView is multiline. If it's YES，YXStackViewItem doesn't support YXStackViewItemStyleFlexibleSpace and YXStackViewItemStyleFlexibleItem.

@end
