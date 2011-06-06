//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Vijay Parikh on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
//@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;

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
- (bool) isFloatingNumberAlready: (NSString *)number
{
	NSRange range = [number rangeOfString: @"."];
	if (range.location == NSNotFound)
		return NO;
	return YES;
}

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
- (void)dealloc
{
    [brain release];
    [super dealloc];
}



@end
