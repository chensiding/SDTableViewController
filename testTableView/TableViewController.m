//
//  TableViewController.m
//  testTableView
//
//  Created by sidchen on 12/19/14.
//  Copyright (c) 2014 microsoft.bing. All rights reserved.
//

#import "TableViewController.h"
#import "SDTableViewCell.h"
#import "ArticleViewController.h"
#import "SDModalTransitionManager.h"

@interface TableViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CATransform3D tableCellTransformation;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SDModalTransitionManager *modalTransitionManager;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.modalTransitionManager = [[SDModalTransitionManager alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 0.8);
    transform = CATransform3DScale(transform, 0.6, 0.6, 0.6);
    transform = CATransform3DTranslate(transform, 0, 0, -20);
    _tableCellTransformation = transform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SDTableViewCell *cell = [SDTableViewCell create];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 335;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*cell.layer.transform = self.tableCellTransformation;
    cell.layer.opacity = 0.8;
    
    [UIView animateWithDuration:0.4 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];*/
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (SDTableViewCell *cell in visibleCells) {
        [cell inTableView:self.tableView didChangeFrameInSuperView:self.view];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    ArticleViewController *articleViewController = [ArticleViewController create];
    articleViewController.transitioningDelegate = self;
    articleViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    //if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
    //articleViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //[self setProvidesPresentationContextTransitionStyle:YES];
    //[self setDefinesPresentationContext:YES];
    //}
    //else{
    //    [[self parentTableViewController]setModalPresentationStyle:UIModalPresentationCurrentContext];
    //}
    
    [self presentViewController:articleViewController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.modalTransitionManager.modalTransitionType = SDModalTransitionDismiss;
    return self.modalTransitionManager;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.modalTransitionManager.modalTransitionType = SDModalTransitionPresent;
    return self.modalTransitionManager;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
