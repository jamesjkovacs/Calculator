//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Vijay Parikh on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController()
@property (readonly) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain
{
	if (!brain) {
		brain = [[CalculatorBrain alloc] init];
	}
	return brain;
}
- (void)dealloc
{
    [brain release];
    [super dealloc];
}
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
        [self.brain setVariableAsOperand:operation];
    }
	else
    {
        if (userIsInTheMiddleOfTypingANumber) 
        {
            self.brain.operand = [display.text doubleValue];
            userIsInTheMiddleOfTypingANumber = NO;
        }
        [self.brain performOperation:operation];
    }
    if([CalculatorBrain variablesInExpression:self.brain.expression])
        display.text = [CalculatorBrain descriptionOfExpression:self.brain.expression];
	else
        display.text = [NSString stringWithFormat:@"%g" , self.brain.operand];
}
- (IBAction)solvePressed:(UIButton *)sender
{
    NSDictionary *varValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt: 4], @"%x",[NSNumber numberWithInt: 8], @"%a",nil];
    
    double result = [CalculatorBrain evaluateExpression:self.brain.expression usingVariableValues:varValues];
    display.text = [NSString stringWithFormat:@"%@ %g", [CalculatorBrain descriptionOfExpression:self.brain.expression],result];
}



@end
