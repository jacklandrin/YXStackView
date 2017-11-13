//
//  YXStackViewItem.h
//  YXStackViewDemo
//
//  Created by 刘博 on 2017/10/12.
//  Copyright © 2017年 刘博. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YXStackViewItemStyleCustom,
    YXStackViewItemStyleFlexibleSpace,
    YXStackViewItemStyleFlexibleItem
}YXStackViewItemStyle;

@interface YXStackViewItem : NSObject

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) YXStackViewItemStyle style;

@end
