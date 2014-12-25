//
//  UIPinchTableViewCell.h
//  testTableView
//
//  Created by sidchen on 12/19/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTableViewCell : UITableViewCell<UIViewControllerTransitioningDelegate>

-(void)inTableView:(UITableView *)tableView didChangeFrameInSuperView:(UIView *)superView;

@property (strong, nonatomic) UIView *mainView;

+(SDTableViewCell *)create;

@end
