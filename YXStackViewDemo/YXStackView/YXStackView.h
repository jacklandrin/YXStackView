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
@property (nonatomic, assign) CGFloat columnSpacing;//isAutoFitEdge为YES时生效
@property (nonatomic, assign) BOOL reverse; //isAutoFitEdge为NO时生效
@property (nonatomic, strong) NSArray<YXStackViewItem*>* items;
@property (nonatomic, assign) BOOL isAutoFitEdge; //item是否自适应View大小，超过view边距进行折行,当为YES时，YXStackViewItem不支持YXStackViewItemStyleFlexibleSpace和YXStackViewItemStyleFlexibleItem

@end
