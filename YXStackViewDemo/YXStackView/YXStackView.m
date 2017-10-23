//
//  YXStackView.m
//  YXStackViewDemo
//
//  Created by 刘博 on 2017/10/12.
//  Copyright © 2017年 刘博. All rights reserved.
//

#import "YXStackView.h"

@implementation YXStackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _configToolBar];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self _configToolBar];
    }
    return self;
}

- (void)_configToolBar
{
    self.clipsToBounds = YES;
    self.axis = YXStackViewAxisHorizontal;
}

- (void)setItems:(NSArray<YXStackViewItem *> *)items
{
    if (_items == items) {
        return;
    }
    for (UIBarButtonItem *item in _items) {
        if (item.customView) {
            [item.customView removeFromSuperview];
        }
    }
    _items = items;
    for (YXStackViewItem *item in _items) {
        if (item.customView) {
            [self addSubview:item.customView];
        }
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGFloat totalSpace = 0.0;
    __block NSInteger flexibleSpaceCount = 0;
    __block NSInteger spaceCount = 0;
    [_items enumerateObjectsUsingBlock:^(YXStackViewItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.style == YXStackViewItemStyleCustom) {
            if (!item.customView) {
                return;
            }
            if (self.axis == YXStackViewAxisHorizontal) {
                totalSpace += item.customView.bounds.size.width;
            } else {
                totalSpace += item.customView.bounds.size.height;
            }
            if (_items.lastObject != item) {
                YXStackViewItem *nextItem = _items[idx + 1];
                if (nextItem.style == YXStackViewItemStyleCustom && nextItem.customView) {
                    spaceCount++;
                }
            }
        } else {
            flexibleSpaceCount++;
        }
    }];
    totalSpace += spaceCount * self.spacing;
    CGFloat flexibleSpacing = 0.0;
    if (self.axis == YXStackViewAxisHorizontal) {
        flexibleSpacing = (self.bounds.size.width - totalSpace) / flexibleSpaceCount;
    } else {
        flexibleSpacing = (self.bounds.size.height - totalSpace) / flexibleSpaceCount;
    }
    
    if (flexibleSpacing < self.spacing) {
        NSArray *tempArray = [_items copy];
        NSMutableArray *resultItems = [_items mutableCopy];
        for (YXStackViewItem *item in tempArray) {
            if (item.style == YXStackViewItemStyleFlexibleSpace) {
                [resultItems removeObject:item];
            }
        }
        _items = [NSArray arrayWithArray:resultItems];
    }
    
    CGFloat currentLocation = 0.0;
    if (self.reverse) {
        if (self.axis == YXStackViewAxisHorizontal) {
            currentLocation = self.bounds.size.width;
        } else {
            currentLocation = self.bounds.size.height;
        }
    }

    for (YXStackViewItem *item in _items) {
        if (item.customView) {
            CGRect customViewRect = item.customView.frame;
            if (self.axis == YXStackViewAxisHorizontal) {
                if (!self.reverse) {
                    customViewRect.origin.x = currentLocation;
                } else {
                    customViewRect.origin.x = currentLocation - customViewRect.size.width;
                }
                
            } else {
                if (!self.reverse) {
                    customViewRect.origin.y = currentLocation;
                } else {
                    customViewRect.origin.y = currentLocation - customViewRect.size.height;
                }
            }
            
            if (item.style == YXStackViewItemStyleFlexibleItem) {
                if (self.axis == YXStackViewAxisHorizontal) {
                    customViewRect.size.width = flexibleSpacing - self.spacing * 2;
                } else {
                    customViewRect.size.height = flexibleSpacing - self.spacing * 2;
                }
            }
            
            item.customView.frame = customViewRect;
            if (item != _items.lastObject) {
                if (self.reverse) {
                    currentLocation = currentLocation - (self.spacing + (self.axis == YXStackViewAxisHorizontal ? customViewRect.size.width : customViewRect.size.height));
                } else {
                    currentLocation = currentLocation + (self.spacing + (self.axis == YXStackViewAxisHorizontal ? customViewRect.size.width : customViewRect.size.height));
                }
            }
            
        } else if (item.style == YXStackViewItemStyleFlexibleSpace) {
            if (item != _items[0]) {
                if (self.reverse) {
                    currentLocation += self.spacing;
                } else {
                    currentLocation -= self.spacing;
                }
            }
            if (self.reverse) {
                currentLocation -= flexibleSpacing;
            } else {
                currentLocation += flexibleSpacing;
            }
        }
    }
}

@end
