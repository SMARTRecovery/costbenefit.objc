//
//  SMRCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitTableViewController.h"
#import "SMRLeftMenuViewController.h"
#import "SMRCostBenefitItemViewController.h"
#import "SMRCostBenefitItem+methods.h"
#import "SMREditCostBenefitViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface SMRCostBenefitTableViewController ()

@property (strong, nonatomic) NSMutableArray *boxes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SMRCostBenefitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.boxes = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        [self.boxes addObject:[[NSMutableArray alloc] init]];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = self.costBenefit.title;
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    // Store this costBenefit in NSUserDefaults as the last viewed.
    NSURL *costBenefitURL = [[self.costBenefit objectID] URIRepresentation];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setURL:costBenefitURL forKey:@"SMRLastViewedCostBenefit"];
    [defaults synchronize];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.boxes = [self.costBenefit fetchBoxes:self.context];
    [self.tableView reloadData];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *boxItems = self.boxes[section];
    if ([boxItems count] > 0) {
        return [boxItems count];
    }

    // Return 1 for empty placeholder cell.
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSNumber *boxNumber = [NSNumber numberWithInteger:section];
    return [self.costBenefit getBoxLabelText:boxNumber isPlural:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 18)];
    label.text = [self.costBenefit getBoxLabelText:[NSNumber numberWithInteger:section] isPlural:YES];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];

    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, tableView.frame.size.width, 25)];
    NSString *subtitleText;
    switch (section) {
        case 0:
            subtitleText = @"What do I enjoy about my addiction?";
            break;
        case 1:
            subtitleText = @"What do I hate about my addiction?";
            break;
        case 2:
            subtitleText = @"What will I like about giving up my addiction?";
            break;
        case 3:
            subtitleText = @"What won't I like about giving up my addiction?";
            break;
    }
    subtitle.text = subtitleText;
    subtitle.font = [UIFont systemFontOfSize:11];
    subtitle.textColor = [UIColor whiteColor];
    [view addSubview:subtitle];

    [view setBackgroundColor:[UIColor grayColor]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitItemCell" forIndexPath:indexPath];

    NSMutableArray *boxItems = self.boxes[indexPath.section];
    if ([boxItems count] == 0) {
        cell.textLabel.text = @"(None added)";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @" ";
        [cell setUserInteractionEnabled:NO];
        return cell;
    }

    SMRCostBenefitItem *item = boxItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = [UIColor blackColor];
    NSString *detail = @"Short-term";
    if ([item.isLongTerm boolValue]) {
        detail = @"Long-term";
    }
    cell.detailTextLabel.text = detail;
    [cell setUserInteractionEnabled:YES];
    return cell;
}

#pragma mark - Navigation

- (IBAction)unwindToCostBenefit:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destNavVC = [segue destinationViewController];
    if ([sender isEqual:self.editButton]) {
        SMREditCostBenefitViewController *destVC = (SMREditCostBenefitViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:self.costBenefit];
    }
    else {
        SMRCostBenefitItemViewController *destVC = (SMRCostBenefitItemViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:self.costBenefit];
        [destVC setOp:@"insert"];
        if (![sender isEqual:self.addButton]) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSMutableArray *boxItems = self.boxes[indexPath.section];
            [destVC setCostBenefitItem:boxItems[indexPath.row]];
            [destVC setOp:@"update"];
        }
    }
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end