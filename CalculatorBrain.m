//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Vijay Parikh on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import "CalculatorBrain.h"


@implementation CalculatorBrain

@synthesize operand;

+ (NSSet *)variablesInExpression:(id)anExpression
{
    NSMutableSet *variables = [NSMutableSet set];
    for(id obj in anExpression)
    {
        if([obj isKindOfClass:[NSString class]] && [obj length] > 1)
        {
           if(![variables member:obj])
               [variables addObject:obj];
        }
    }
    if([variables count]) return (NSSet *)variables;
    return nil;
}

+ (NSString *)descriptionOfExpression:(id)anExpression
{
    //NSString *expressionString = [[NSString alloc] init];
    NSString *expressionString;
    expressionString = @"test";
    for(id obj in anExpression)
    {
        if([obj isKindOfClass:[NSNumber class]])
        {
            expressionString = [NSString stringWithFormat:@"%G",[(NSNumber *)obj doubleValue]];
            NSLog(@"expressionString is %@",expressionString);
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            if(([obj length] > 1 ) && ([obj characterAtIndex:0] == '%'))
                expressionString = [expressionString stringByAppendingString:[obj substringFromIndex:1]];
            else
                expressionString = [expressionString stringByAppendingString:(NSString *)obj];
            NSLog(@"expressionString is %@",expressionString);
        }
    }
	return expressionString;
}

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables
{
    double returnResult = 0;
    CalculatorBrain *workerBrain = [[CalculatorBrain alloc]init];
    for(id obj in anExpression)
    {
        NSLog(@"our element is %@",obj);
        if([obj isKindOfClass:[NSNumber class]])
        {
            workerBrain.operand = [(NSNumber *)obj doubleValue];
            NSLog(@"our new number is %G",workerBrain.operand);
        }
        else if([obj isKindOfClass:[NSString class]])
        {
            if(([obj length] > 1) && ([obj characterAtIndex:0] == '%'))
            {
                workerBrain.operand = [(NSNumber *)[variables objectForKey:obj] doubleValue];
                NSLog(@"our new test number is %G",workerBrain.operand);
            }
            else
            {
                returnResult = [workerBrain performOperation:(NSString *)obj];
                NSLog(@"our new operation is %@",obj);
            }
        }
        else 
        {    
            [workerBrain release];
            return 0;
        }
    }
    if(![[anExpression lastObject] isKindOfClass:[NSString class]] || 
       ![[anExpression lastObject] isEqualToString:@"="])
       {
           returnResult = [workerBrain performOperation:@"="];
       }
    [workerBrain release];
    return returnResult;
}

-(id)expression
{
    NSMutableArray *expr = [internalExpression copy] ;
    [expr autorelease];
    return (id)expr ;
//    return internalExpression;
}

-(NSString *)description
{
	NSString *original = [super description];
	return [original stringByAppendingString:@"This class sucks"];
}

- (void)addToExpression:(id)anEntry
{
    if(!internalExpression)
        internalExpression = [[NSMutableArray alloc]init];
    [internalExpression addObject:(id)anEntry];
    NSLog(@"expression = %@", internalExpression);
}

- (void)setVariableAsOperand:(NSString *)variableName
{
    variableName = [VARIABLE_PREFIX stringByAppendingString:variableName];
    [self addToExpression:variableName];
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
	double numberMemory = 0;
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
        [internalExpression release];
        internalExpression = [[NSMutableArray alloc]init];
//        internalExpression = nil;
	} else if ([operation isEqual:@"Store"]) {
//		numberMemory = operand;
		[[NSUserDefaults standardUserDefaults] setDouble: operand forKey: @"Mem Recall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	} else if ([operation isEqual:@"Mem +"]) {
		numberMemory = operand + [[NSUserDefaults standardUserDefaults] doubleForKey: @"Mem Recall"];
		[[NSUserDefaults standardUserDefaults] setDouble: numberMemory forKey: @"Mem Recall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	} else if ([operation isEqual:@"Recall"]) {
		//operand = numberMemory;
		operand = [[NSUserDefaults standardUserDefaults] doubleForKey: @"Mem Recall"];
	} else {
		[self performWaitingOperation];
		[waitingOperation release];
        waitingOperation = operation;
        [operation retain];
		waitingOperand = operand;
        if(![CalculatorBrain variablesInExpression:[self expression]])
        	[self addToExpression:(id)[NSNumber numberWithDouble: operand]];
        [self addToExpression:operation];
	}

	return operand;
}
- (void)dealloc
{
    [internalExpression release];
    [super dealloc];
}

@end
