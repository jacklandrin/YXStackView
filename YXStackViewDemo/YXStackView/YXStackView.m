//
//  YXStackView.m
//  YXStackViewDemo
//
//  Created by 刘博 on 2017/10/12.
//  Copyright © 2017年 刘博. All rights reserved.
//

#import "YXStackView.h"
#import <objc/runtime.h>

@interface YXStackViewMatrixColumn : NSObject

@property (nonatomic, assign) CGFloat itemMaxLength;
@property (nonatomic, assign) NSUInteger columnNum;
@property (nonatomic, strong) NSMutableArray<YXStackViewItem*> *itemArray;

@end

@implementation YXStackView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _configStackView];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self _configStackView];
    }
    return self;
}

- (void)_configStackView
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
    
    if (self.isAutoFitEdge) {
        [self multicolumnsLayout];
    } else {
        [self singlecolumnLayout];
    }
}

- (void)multicolumnsLayout
{
   
    __block NSUInteger currentColumn = 0;
    __block CGFloat currentX = 0;
    __block CGFloat currentY = 0;
    NSMutableArray<YXStackViewMatrixColumn*> *columnArray = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(YXStackViewItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.style != YXStackViewItemStyleCustom) {
            return;
        }
        UIView *customView = item.customView;
        CGRect originRect = customView.frame;
        if (self.axis == YXStackViewAxisHorizontal) {
            if (customView.bounds.size.width > self.bounds.size.width) {
                return;
            }
            if (currentX + originRect.size.width > self.bounds.size.width) {
                currentColumn++;
                currentX = 0;
            }
            YXStackViewMatrixColumn *matrixColumn = [[YXStackViewMatrixColumn alloc] init];
            if (currentX == 0) {
                matrixColumn = [[YXStackViewMatrixColumn alloc] init];
                matrixColumn.columnNum = currentColumn;
                [columnArray addObject:matrixColumn];
            } else {
                matrixColumn = [columnArray objectAtIndex:currentColumn];
                originRect.origin.x = currentX;
            }
            currentX += (originRect.size.width + self.spacing);
            [matrixColumn.itemArray addObject:item];
            matrixColumn.itemMaxLength = MAX(matrixColumn.itemMaxLength, originRect.size.height);
            
        } else {
            if (customView.bounds.size.height > self.bounds.size.height) {
                return;
            }
            if (currentY + originRect.size.height > self.bounds.size.height) {
                currentColumn++;
                currentY = 0;
            }
            YXStackViewMatrixColumn *matrixColumn;
            if (currentY == 0) {
                matrixColumn = [[YXStackViewMatrixColumn alloc] init];
                matrixColumn.columnNum = currentColumn;
                [columnArray addObject:matrixColumn];
            } else {
                matrixColumn = [columnArray objectAtIndex:currentColumn];
                originRect.origin.y = currentY;
            }
            currentY += (originRect.size.height + self.spacing);
            [matrixColumn.itemArray addObject:item];
            matrixColumn.itemMaxLength = MAX(matrixColumn.itemMaxLength, originRect.size.width);
        }
        customView.frame = originRect;
    }];
    
    currentX = 0.0;
    currentY = 0.0;
    [columnArray enumerateObjectsUsingBlock:^(YXStackViewMatrixColumn * _Nonnull matrixcColumn, NSUInteger idx, BOOL * _Nonnull stop) {
        [matrixcColumn.itemArray enumerateObjectsUsingBlock:^(YXStackViewItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *customView = item.customView;
            CGRect originRect = customView.frame;
            if (self.axis == YXStackViewAxisHorizontal) {
                CGFloat itemY = (matrixcColumn.itemMaxLength - originRect.size.height) / 2 + currentY;
                originRect.origin.y = itemY;
            } else {
                CGFloat itemX = (matrixcColumn.itemMaxLength - originRect.size.width) / 2 + currentX;
                originRect.origin.x = itemX;
            }
            customView.frame = originRect;
        }];
        if (self.axis == YXStackViewAxisHorizontal) {
            currentY += (matrixcColumn.itemMaxLength + self.columnSpacing);
        } else {
            currentX += (matrixcColumn.itemMaxLength + self.columnSpacing);
        }
    }];
    CGRect originStackViewRect = self.frame;
    if (self.axis == YXStackViewAxisHorizontal) {
        originStackViewRect.size.height = currentY - self.columnSpacing;
    } else {
        originStackViewRect.size.width = currentX - self.columnSpacing;
    }
    self.frame = originStackViewRect;
}

- (void)singlecolumnLayout
{
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
        item.index = idx;
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

@implementation YXStackViewMatrixColumn

-(instancetype)init
{
    if (self = [super init]) {
        _columnNum = 0;
        _itemMaxLength = 0;
        _itemArray = [NSMutableArray array];
    }
    return self;
}

@end
