//
//  UITableViewCell+TableViewController.m
//  MewsCard
//
//  Created by chensiding on 14-3-2.
//  Copyright (c) 2014年 microsoft. All rights reserved.
//

#import "UITableViewCell+TableViewController.h"

@implementation UITableViewCell (TableViewController)

- (id) parentTableViewController
{
    id superview = self.superview;
    
    while(superview && ![superview isKindOfClass:[UITableView class]]){
        superview = [superview superview];
    }
    
    UITableView *tableView = (UITableView *)superview;
    
    if(tableView)
        return (UITableViewController *)tableView.delegate;

    return nil;
}


@end
