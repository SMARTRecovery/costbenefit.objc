//
//  SMRCostBenefitItemViewController.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitItem+methods.h"

@interface SMRCostBenefitItemViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *op;
@property (strong, nonatomic) SMRCostBenefit *costBenefit;
@property (strong, nonatomic) SMRCostBenefitItem *costBenefitItem;

@end