//
//  ArticleViewController.m
//  testTableView
//
//  Created by sidchen on 12/23/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController () <UIGestureRecognizerDelegate>

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) int originalZPosition;
@property (nonatomic) bool isOriginalStateSet;
@property (strong, nonatomic) NSMutableArray *activeGestureList;

@property (nonatomic) CGFloat scaleByPinch;
@property (nonatomic) CGFloat rotationByPan;
@property (nonatomic) CGFloat rotationByRotate;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    pinch.delegate = self;
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    pan.minimumNumberOfTouches = 2;
    pan.delegate = self;
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    rotation.delegate = self;
    
    [self.view addGestureRecognizer:pinch];
    [self.view addGestureRecognizer:pan];
    [self.view addGestureRecognizer:rotation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleGesture:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self saveOriginalState];
            recognizer.view.layer.zPosition = 999;
            [self.activeGestureList addObject:recognizer];
        }
        case UIGestureRecognizerStateChanged:
        {
            if([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]){
                CGFloat scale = ((UIPinchGestureRecognizer *)recognizer).scale;
                self.scaleByPinch = scale;
            }
            else if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
                CGPoint translation = [((UIPanGestureRecognizer *)recognizer) translationInView:recognizer.view.superview];
                
                self.rotationByPan = M_PI / 360 * 30 * translation.x / 160;;
                
                recognizer.view.center = CGPointMake(self.originalFrame.origin.x + self.originalFrame.size.width / 2 +translation.x, self.originalFrame.origin.y+ self.originalFrame.size.height / 2 + translation.y);
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
                if(self.scaleByPinch < 1){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else{
                    [self restoreOriginalState];
                }
            }
            break;
        }
    }
}

-(void)saveOriginalState
{
    if(!self.isOriginalStateSet){
        self.isOriginalStateSet = YES;
        self.originalFrame = self.view.frame;
        self.originalZPosition = self.view.layer.zPosition;
    }
}

-(void)restoreOriginalState
{
    NSLog(@"Animation Start");
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.originalFrame.origin.x + self.originalFrame.size.width / 2, self.originalFrame.origin.y + self.originalFrame.size.height / 2);
        self.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(finished){
            NSLog(@"Animation Finished");
            self.view.layer.zPosition = self.originalZPosition;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(ArticleViewController *)create
{
    ArticleViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ArticleViewController"]
    ;
    return viewController;
}

@end
