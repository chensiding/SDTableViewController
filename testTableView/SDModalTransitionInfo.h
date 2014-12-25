//
//  SDModalTransitionInfo.h
//  testTableView
//
//  Created by sidchen on 12/25/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDModalTransitionInfo : NSObject

@property (nonatomic) CGRect sharedViewOriginalFrame;
@property (weak, nonatomic) UIView *containerOfSharedView;
@property (weak, nonatomic) UIView *sharedView;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat rotate;
@property (nonatomic) CGPoint center;

@end
