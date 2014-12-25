//
//  ModalTransitionManager.h
//  testTableView
//
//  Created by sidchen on 12/24/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SDModalTransitionType){
    SDModalTransitionPresent = 0,
    SDModalTransitionDismiss
};

@interface SDModalTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) SDModalTransitionType modalTransitionType;

@end
