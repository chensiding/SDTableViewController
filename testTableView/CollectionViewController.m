//
//  CollectionViewController.m
//  testTableView
//
//  Created by sidchen on 12/22/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (nonatomic) float lastRotation;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.userInteractionEnabled = YES;
    
    // Configure the cell
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 300, 300)];
    view.backgroundColor = [UIColor redColor];
    
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    pinch.delegate = self;
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDrag:)];
    pan.minimumNumberOfTouches = 2;
    pan.delegate = self;
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
    rotation.delegate = self;
    
    [view addGestureRecognizer:pinch];
    [view addGestureRecognizer:pan];
    [view addGestureRecognizer:rotation];
    
    [cell addSubview:view];
    
    return cell;
}

-(void)handleDrag:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translationOffset = [recognizer translationInView:recognizer.view.superview];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.6 animations:^{
            recognizer.view.frame = CGRectMake(20, 20, 300, 300);
        }];
    }
    else{
        recognizer.view.frame = CGRectMake(20 + translationOffset.x, 20 + translationOffset.y, 300, 300);
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.6 animations:^{
            recognizer.view.transform=CGAffineTransformIdentity;
        }];
    }
    else{
        //recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        NSLog(@"%f", recognizer.scale);
    }
    
    recognizer.scale = 1;
}

-(void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.6 animations:^{
            recognizer.view.transform=CGAffineTransformIdentity;
        }];
    }
    else if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        _lastRotation = 0;
    }
    
    CGFloat rotation = recognizer.rotation - _lastRotation;
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);
    _lastRotation = recognizer.rotation;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer.view != otherGestureRecognizer.view){
        return NO;
    }
    
    return YES;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 320);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
