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
- (bool) isFloatingNumberAlready: (NSString *)number
{
	NSRange range = [number rangeOfString: @"."];
	if (range.location == NSNotFound)
		return NO;
	return YES;
}
		
- (IBAction)digitPressed:(UIButton *)sender
{
	//NSString *digit = [[sender titleLabel] text];
	NSString *digit = sender.titleLabel.text;
	if (userIsInTheMiddleOfTypingANumber) {
		if ([self isFloatingNumberAlready: [display text]] && [digit isEqual:@"."])
			return;
		//[display setText:[[display text] stringByAppendingString: digit]];
		display.text = [display.text stringByAppendingString: digit];
	} else {
		//[display setText:digit];
		display.text = digit;
		userIsInTheMiddleOfTypingANumber = YES;
	}

}
- (IBAction)operationPressed:(UIButton *)sender;
{
	NSLog(@"The answer to %@, the universe and everything is %d.", brain, 42);
	if (userIsInTheMiddleOfTypingANumber) {
		//[[self brain] setOperand:[[display text] doubleValue]];
		//[self brain].operand = [[display text] doubleValue];
		self.brain.operand = [display.text doubleValue];
		userIsInTheMiddleOfTypingANumber = NO;
	}
	NSString *operation = [[sender titleLabel] text];
	//double result = [[self brain] performOperation:operation];
	[self.brain performOperation:operation];
	display.text = [NSString stringWithFormat:@"%g" , self.brain.operand];
}



@end
