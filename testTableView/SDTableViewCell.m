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
@property (strong, nonatomic) NSMutableArray *activeGestureList;

@property (nonatomic) CGFloat scaleByPinch;
@property (nonatomic) CGFloat rotationByPan;
@property (nonatomic) CGFloat rotationByRotate;

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
    self.activeGestureList = [[NSMutableArray alloc]init];
    self.scaleByPinch = 1;
    self.rotationByRotate = 0;
    self.rotationByPan = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 335, 335)];
    
    view.backgroundColor = [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 335, 335)];
    label.text = @"A";
    
    [view addSubview:label];
    self.mainView = view;
    [self addSubview:self.mainView];
    
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
}

-(void)handleGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self saveOriginalState];
            self.layer.zPosition = 999;
            [self.activeGestureList addObject:recognizer];
        }
        case UIGestureRecognizerStateChanged:
        {
            if([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]){
                CGFloat scale = ((UIPinchGestureRecognizer *)recognizer).scale;
                self.scaleByPinch = scale;
            }
            else if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
                CGPoint translation = [((UIPanGestureRecognizer *)recognizer) translationInView:self.superview];
                
                self.rotationByPan = M_PI / 360 * 30 * translation.x / 160;;
                
                self.center = CGPointMake(self.originalFrame.origin.x + self.originalFrame.size.width / 2 +translation.x, self.originalFrame.origin.y+ self.originalFrame.size.height / 2 + translation.y);
            }
            else if([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]){
                CGFloat rotation = ((UIRotationGestureRecognizer*)recognizer).rotation;
                
                self.rotationByRotate = rotation;
            }
            
            NSLog(@"rotaion by pan: %f, rotation by rotate: %f", self.rotationByPan, self.rotationByRotate);
            recognizer.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, self.rotationByRotate + self.rotationByPan);
            recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, self.scaleByPinch, self.scaleByPinch);
            
            break;
        }
        default:
        {
            [self.activeGestureList removeObject:recognizer];
            if([self.activeGestureList count] == 0){
                [self restoreOriginalState];
            }
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
    NSLog(@"Animation Start");
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(self.originalFrame.origin.x + self.originalFrame.size.width / 2, self.originalFrame.origin.y + self.originalFrame.size.height / 2);
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(finished){
            NSLog(@"Animation Finished");
            self.layer.zPosition = self.originalZPosition;
            self.rotationByRotate = 0;
            self.rotationByPan = 0;
            self.scaleByPinch = 1;
        }
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer.view != otherGestureRecognizer.view){
        return NO;
    }
    
    return YES;
}

-(void)inTableView:(UITableView *)tableView didChangeFrameInSuperView:(UIView *)superView
{
    CGRect frameInSuperView = [tableView convertRect:self.frame toView:superView];
    NSLog(@"Frame in super view x=%f, y=%f", frameInSuperView.origin.x, frameInSuperView.origin.y);
    CGFloat scale = 1;
    CGFloat delaScale = 0.15;
    if(CGRectGetMinY(frameInSuperView) < 0){
        scale = 1 - delaScale * -CGRectGetMinY(frameInSuperView)/CGRectGetHeight(frameInSuperView);
    }
    else if(CGRectGetMaxY(frameInSuperView) > CGRectGetHeight(superView.frame)){
        scale = 1 - delaScale * (- CGRectGetHeight(superView.frame) + CGRectGetMaxY(frameInSuperView))/CGRectGetHeight(frameInSuperView);
    }
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

+(SDTableViewCell *)create
{
    SDTableViewCell *cell = [[SDTableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
