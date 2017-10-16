//
//  YXStackViewItem.m
//  YXStackViewDemo
//
//  Created by 刘博 on 2017/10/12.
//  Copyright © 2017年 刘博. All rights reserved.
//

#import "YXStackViewItem.h"

@implementation YXStackViewItem

- (UIView *)customView
{
    if (self.style == YXStackViewItemStyleFlexibleSpace) {
        return nil;
    }
    return _customView;
}

@end
