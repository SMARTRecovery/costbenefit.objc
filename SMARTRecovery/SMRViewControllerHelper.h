//
//  SMRViewControllerHelpers.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/9/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"


@interface SMRViewControllerHelper : NSObject

+ (NSString *)getVerb:(SMRCostBenefit *)costBenefit;

+ (void)presentCostBenefit:(SMRCostBenefit *)costBenefit viewController:(UIViewController *)viewController context:(NSManagedObjectContext *)context;

+ (void)presentHome:(UIViewController *)viewController context:(NSManagedObjectContext *)context;

@end