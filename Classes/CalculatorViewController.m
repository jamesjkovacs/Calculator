//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jim Kovacs on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
//@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;

// Create an instance of the model object brain.
- (void) viewDidLoad
{
    brain = [[CalculatorBrain alloc] init];
}

//- (CalculatorBrain *)brain
//{
//	if (!brain) {
//		brain = [[CalculatorBrain alloc] init];
//	}
//	return brain;
//}
// Private instance method called by digitPressed.  Checks to see if user already entered a
// "." in the current number to prevent them from using it again.
- (bool) isFloatingNumberAlready: (NSString *)number
{
	NSRange range = [number rangeOfString: @"."];
	if (range.location == NSNotFound)
		return NO;
	return YES;
}

// Called when user presses any of the number keys.  Will update the display with the current
// number the user has entered (4.52, 43, etc.).
- (IBAction)digitPressed:(UIButton *)sender
{
	NSString *digit = sender.titleLabel.text;
	if (userIsInTheMiddleOfTypingANumber) {
		if ([self isFloatingNumberAlready: display.text] && [digit isEqual:@"."])
			return;
		display.text = [display.text stringByAppendingString: digit];
	} else {
		display.text = digit;
		userIsInTheMiddleOfTypingANumber = YES;
	}

}

// User pressed one of the calculation buttons (+, -, c, x, etc.).  Will call CalculatorBrain
// setVariableAsOperand if x,a,or b were pressed.  Otherwise performOperation is called.
- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
//	NSLog(@"The answer to %@, the universe and everything is %d.", brain, 42);
    if ([sender.titleLabel.text isEqual:@"x"] || [sender.titleLabel.text isEqual:@"a"] 
        || [sender.titleLabel.text isEqual:@"b"])
    {
        [brain setVariableAsOperand:operation];
    }
	else
    {
        if (userIsInTheMiddleOfTypingANumber) 
        {
            brain.operand = [display.text doubleValue];
            userIsInTheMiddleOfTypingANumber = NO;
        }
        [brain performOperation:operation];
    }
    if([CalculatorBrain variablesInExpression:brain.expression])
        display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
	else
        display.text = [NSString stringWithFormat:@"%g" , brain.operand];
}

// User pushed the "Solve" button. Calls CalculatorBrain's evaluateExpression method 
// and updates the display with the calculated result.
- (IBAction)solvePressed:(UIButton *)sender
{
    NSDictionary *varValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt: 4], @"%x",[NSNumber numberWithInt: 8], @"%a",nil];
    
    double result = [CalculatorBrain evaluateExpression:brain.expression usingVariableValues:varValues];
//    NSArray *jim = [[CalculatorBrain descriptionOfExpression:self.brain.expression] componentsSeparatedByString:@" "]; 
//    NSString *test = [jim lastObject];
//    if(![test isEqualToString: @"="])
    if(![[[[CalculatorBrain descriptionOfExpression:brain.expression] componentsSeparatedByString:@" "] lastObject]isEqualToString: @"="])
    	[brain performOperation:@"="];    
    display.text = [NSString stringWithFormat:@"%@ %g", [CalculatorBrain descriptionOfExpression:brain.expression],result];
}

- (void) viewDidUnLoad
{
    self.display = nil;
}

// Release our model. 
- (void)dealloc
{
    [brain release];
    [super dealloc];
}



@end
