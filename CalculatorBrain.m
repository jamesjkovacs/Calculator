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

-(id)expression
{
    return (id)[internalExpression copy] ;
}

-(NSString *)description
{
	NSString *original = [super description];
	return [original stringByAppendingString:@"This class sucks"];
}


- (void)setVariableAsOperand:(NSString *)variableName
{
    NSString *vp = VARIABLE_PREFIX;
    [internalExpression addObject:(id)[vp stringByAppendingString: variableName]];
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
    if(!internalExpression) internalExpression = [[NSMutableArray alloc]init];
    [internalExpression addObject:(id)[NSNumber numberWithDouble: operand]];
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
		[waitingOperation release];
		waitingOperation = nil;
	} else if ([operation isEqual:@"Store"]) {
		numberMemory = operand;
		[[NSUserDefaults standardUserDefaults] setDouble: operand forKey: @"Mem Recall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	} else if ([operation isEqual:@"Mem +"]) {
		numberMemory += operand;
	} else if ([operation isEqual:@"Recall"]) {
		//operand = numberMemory;
		operand = [[NSUserDefaults standardUserDefaults] doubleForKey: @"Mem Recall"];
	} else {
		[self performWaitingOperation];
		[waitingOperation release];
        waitingOperation = operation;
		waitingOperand = operand;
        [internalExpression addObject:(id)operation];
        
	}

	return operand;
}
- (void)dealloc
{
    [internalExpression release];
    [super dealloc];
}

@end
