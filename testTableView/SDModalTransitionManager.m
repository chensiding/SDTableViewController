//
//  ModalTransitionManager.m
//  testTableView
//
//  Created by sidchen on 12/24/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import "SDModalTransitionManager.h"
#import "TableViewController.h"
#import "SDTableViewCell.h"

@implementation SDModalTransitionManager

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
    UIView *container = [transitionContext containerView];
   
    
    if(self.modalTransitionType == SDModalTransitionPresent){
        
        SDTableViewCell *cell = (SDTableViewCell *)((TableViewController *)fromVC).selectedCell;
        UIView *mainView = cell.mainView;
        
        [container insertSubview:toVC.view aboveSubview:fromVC.view];
        
        CGRect toVCInitalFrame = [cell convertRect:mainView.frame toView:fromVC.view];
        NSLog(@"toVCInitialFrame : x=%f, y=%f, width=%f, height=%f", toVCInitalFrame.origin.x, toVCInitalFrame.origin.y, toVCInitalFrame.size.width, toVCInitalFrame.size.height);
        
        toVC.view.frame = toVCInitalFrame;
        mainView.frame = CGRectMake(0, 0, toVCInitalFrame.size.width, toVCInitalFrame.size.height);
        [toVC.view addSubview:mainView];
        
        CGRect mainViewFinalFrame = CGRectMake(0, 0, 375, 375);
        
        CGRect toVCFinalFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [UIView animateWithDuration:1.0
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             toVC.view.frame = toVCFinalFrame;
                             mainView.frame = mainViewFinalFrame;
                             toVC.view.transform = CGAffineTransformMakeRotation(0);
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else{
        
        SDTableViewCell *cell = (SDTableViewCell *)((TableViewController *)toVC).selectedCell;
        UIView *mainView = cell.mainView;

        CGRect fromVCFinalFrame = [cell convertRect:mainView.frame toView:toVC.view];
        fromVCFinalFrame.size = CGSizeMake(335, 335);
        fromVCFinalFrame.origin = CGPointMake(fromVCFinalFrame.origin.x+20, fromVCFinalFrame.origin.y+20);
        
        NSLog(@"fromVCFinalFrame: x=%f, y=%f, width=%f, height=%f", fromVCFinalFrame.origin.x, fromVCFinalFrame.origin.y, fromVCFinalFrame.size.width, fromVCFinalFrame.size.height);
        
        [UIView animateWithDuration:1.0
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             fromVC.view.transform = CGAffineTransformIdentity;
                             fromVC.view.frame = fromVCFinalFrame;
                             mainView.frame = CGRectMake(0, 0, 335, 335);
                         } completion:^(BOOL finished) {
                             mainView.frame = CGRectMake(20, 20, 335, 335);
                             [cell addSubview:mainView];
                             [transitionContext completeTransition:YES];
                         }];
    }
}

@end
