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

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

@end
