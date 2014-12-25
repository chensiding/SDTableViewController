//
//  ArticleViewController.h
//  testTableView
//
//  Created by sidchen on 12/23/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDModalTransitionInfo.h"

@interface ArticleViewController : UIViewController

@property (strong,nonatomic) SDModalTransitionInfo *transitionInfo;

+(ArticleViewController *)create;

@end
