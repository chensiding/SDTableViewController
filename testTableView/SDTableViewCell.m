//
//  UITableViewCell.m
//  testTableView
//
//  Created by sidchen on 12/19/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import "SDTableViewCell.h"

@interface SDTableViewCell ()

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) int originalZPosition;
@property (nonatomic) bool isOriginalStateSet;
@property (nonatomic) bool isAnimating;

@end

@implementation SDTableViewCell

-(id)init
{
    self = [super init];
    if(self){
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self commonInit];
}

-(void)commonInit{
    self.isOriginalStateSet = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 300, 300)];
    
    view.backgroundColor = [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
    
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    pinch.delegate = self;
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    pan.minimumNumberOfTouches = 2;
    pan.delegate = self;
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    rotation.delegate = self;
    
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:rotation];
    
    [self addSubview:view];
}

-(void)handleGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self saveOriginalState];
            self.layer.zPosition = 999;
        }
        case UIGestureRecognizerStateChanged:
        {
            if([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]){
                CGFloat scale = ((UIPinchGestureRecognizer *)recognizer).scale;
                
                self.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale);
                
                ((UIPinchGestureRecognizer *)recognizer).scale = 1;
            }
            else if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
                CGPoint translation = [((UIPanGestureRecognizer *)recognizer) translationInView:self.superview];
                
                self.center = CGPointMake(self.originalFrame.origin.x + self.originalFrame.size.width / 2 +translation.x, self.originalFrame.origin.y+ self.originalFrame.size.height / 2 + translation.y);
            }
            else if([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
                CGFloat rotation = ((UIRotationGestureRecognizer*)recognizer).rotation;
                
                recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);
                
                ((UIRotationGestureRecognizer*)recognizer).rotation = 0;
            }
            
            break;
        }
        default:
        {
            [self restoreOriginalState];
            break;
        }
    }

}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self saveOriginalState];
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat scale = recognizer.scale;
            
            self.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale);
            
            recognizer.scale = 1;
            
            break;
        }
        default:
        {
            [self restoreOriginalState];
            break;
        }
    }
}

-(void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self saveOriginalState];
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat rotation = recognizer.rotation;
            
            recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);
            
            recognizer.rotation = 0;
            
            break;
        }
        default:
        {
            [self restoreOriginalState];
            break;
        }
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self saveOriginalState];
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.superview];
            
            self.center = CGPointMake(self.originalFrame.origin.x + self.originalFrame.size.width / 2 +translation.x, self.originalFrame.origin.y+ self.originalFrame.size.height / 2 + translation.y);
            
            break;
        }
        default:
        {
            [self restoreOriginalState];
            break;
        }
    }
}

-(void)saveOriginalState
{
    if(!self.isOriginalStateSet){
        self.isOriginalStateSet = YES;
        self.originalFrame = self.frame;
        self.originalZPosition = self.layer.zPosition;
    }
}

-(void)restoreOriginalState
{
    if(!self.isAnimating){
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.originalFrame;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if(finished){
                self.isAnimating=NO;
                self.layer.zPosition = self.originalZPosition;
            }
        }];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer.view != otherGestureRecognizer.view){
        return NO;
    }
    
    return YES;
}

+(SDTableViewCell *)create
{
    SDTableViewCell *cell = [[SDTableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
