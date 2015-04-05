//
//  SMRCostBenefitViewController.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"

@interface SMRCostBenefitViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) SMRCostBenefit *costBenefit;

- (IBAction)unwindToCostBenefit:(UIStoryboardSegue *)segue;

@end