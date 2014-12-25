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
#import "SDModalTransitionInfo.h"
#import "ArticleViewController.h"

@implementation SDModalTransitionManager

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];

    if(self.modalTransitionType == SDModalTransitionPresent){
        SDModalTransitionInfo *transitionInfo = ((ArticleViewController *)toVC).transitionInfo;
        UIView *sharedView = transitionInfo.sharedView;
        CGRect shareViewOriginalFrame = transitionInfo.sharedViewOriginalFrame;
        
        CGRect toVCInitialFrame = [transitionInfo.containerOfSharedView convertRect:sharedView.frame toView:fromVC.view];
        CGRect toVCFinalFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGRect shareViewInitialFrame = CGRectMake(0, 0, toVCInitialFrame.size.width, toVCInitialFrame.size.height);
        CGRect shareViewFinalFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, shareViewOriginalFrame.size.height / shareViewOriginalFrame.size.width * [UIScreen mainScreen].bounds.size.width);
        
        toVC.view.frame = toVCInitialFrame;
        sharedView.frame = shareViewInitialFrame;
        
        [toVC.view addSubview:transitionInfo.sharedView];
        toVC.view.transform = CGAffineTransformMakeRotation(transitionInfo.rotate);
        toVC.view.transform = CGAffineTransformScale(toVC.view.transform, transitionInfo.scale, transitionInfo.scale);
        
        [container insertSubview:toVC.view aboveSubview:fromVC.view];
        
        [UIView animateWithDuration:1.0
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             toVC.view.transform = CGAffineTransformIdentity;
                             toVC.view.frame = toVCFinalFrame;
                             sharedView.frame = shareViewFinalFrame;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else{
        SDModalTransitionInfo *transitionInfo = ((ArticleViewController *)fromVC).transitionInfo;
        UIView *sharedView = transitionInfo.sharedView;
        CGRect shareViewOriginalFrame = transitionInfo.sharedViewOriginalFrame;
        
        CGRect fromVCFinalFrame = [transitionInfo.containerOfSharedView convertRect:shareViewOriginalFrame toView:toVC.view];
        CGRect shareViewFinalFrame = CGRectMake(0, 0, shareViewOriginalFrame.size.width, shareViewOriginalFrame.size.height);
        
        [UIView animateWithDuration:1.0
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             fromVC.view.transform = CGAffineTransformIdentity;
                             fromVC.view.frame = fromVCFinalFrame;
                             sharedView.frame = shareViewFinalFrame;
                         } completion:^(BOOL finished) {
                             sharedView.frame = shareViewOriginalFrame;
                             [transitionInfo.containerOfSharedView addSubview:sharedView];
                             [transitionContext completeTransition:YES];
                         }];
    }
}

@end
