//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Vijay Parikh on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import "CalculatorBrain.h"


@implementation CalculatorBrain

/*- (void)setOperand:(double)anOperand
{
	operand = anOperand;
}*/

@synthesize operand;

-(NSString *)description
{
	NSString *original = [super description];
	return [original stringByAppendingString:@"This class sucks"];
}

-(void)performWaitingOperation
{
	if ([@"+" isEqual:waitingOperation]){
		operand = waitingOperand + operand;
	} else if([@"-" isEqual:waitingOperation]){
		operand = waitingOperand - operand;
	} else if([@"*" isEqual:waitingOperation]){
		operand = waitingOperand * operand;
	} else if([@"/" isEqual:waitingOperation]){
		if (operand){
		operand = waitingOperand / operand;
		}
	}
}

- (double)performOperation:(NSString *)operation 
{
	if([operation isEqual:@"sqrt"]){
		operand = sqrt(operand);
	} else if ([operation isEqual:@"+/-"]) {			
		operand = -(operand);
	} else if ([operation isEqual:@"1/x"]) {
		operand = 1/operand;
	} else if ([operation isEqual:@"sin"]) {
		operand = sin(operand * M_PI / 180);
	} else if ([operation isEqual:@"cos"]) {
		operand = cos(operand * M_PI / 180);
	} else if ([operation isEqual:@"C"]) {
		operand = 0;
		waitingOperand = 0;
		waitingOperation = nil;
	} else if ([operation isEqual:@"Store"]) {
		numberMemory = operand;
		[[NSUserDefaults standardUserDefaults] setDouble: operand forKey: @"Mem Recall"];
	} else if ([operation isEqual:@"Mem +"]) {
		numberMemory += operand;
	} else if ([operation isEqual:@"Recall"]) {
		//operand = numberMemory;
		operand = [[NSUserDefaults standardUserDefaults] doubleForKey: @"Mem Recall"];
	} else {
		[self performWaitingOperation];
		waitingOperation = operation;
		waitingOperand = operand;
	}

	return operand;
}

@end
