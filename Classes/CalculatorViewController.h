//
//  CalculatorViewController.h
//  Calculato
//
//  Created by Jim Kovacs on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController {
	IBOutlet UILabel *display;
	CalculatorBrain *brain;
	bool userIsInTheMiddleOfTypingANumber;
}

@property (nonatomic, retain) IBOutlet UILabel *display;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)solvePressed:(UIButton *)sender;

@end

