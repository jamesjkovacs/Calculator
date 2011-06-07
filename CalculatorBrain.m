//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jim Kovacs on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import "CalculatorBrain.h"


@implementation CalculatorBrain

@synthesize operand;

/*
 * Class Method - returns copy of propertylist passed since user does not know that
 * the expression is already a property list.
*/
+ (id)expressionForPropertyList:(id)propertyList
{
    NSMutableArray *expr = [propertyList copy] ;
    [expr autorelease];
    return (id)expr ;    
}

/*
 * Class Method - returns copy of anExpression passed as a property list since user 
 * does not know that the expression is already a property list.
*/
+ (id)propertyListForExpression:(id)anExpression
{
    NSMutableArray *expr = [anExpression copy] ;
    [expr autorelease];
    return (id)expr ;    
}

/*
 * Class Method - returns an array of all the variables in the current expression (x, a, b).
 * Will return nil if there are no variables. If the variabl is in the exression more than
 * once (5 + x / 3 * x) the variable will only be added to the array once.
*/
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

/*
 * Class Method - returns the expression array as a string.
 * a space will be inserted between each element (24 + x / 3).
 * this is used to update the user entry display once a variable has been added.
*/
+ (NSString *)descriptionOfExpression:(id)anExpression
{
    NSMutableString *expressionString = [[NSMutableString alloc] init];
    BOOL firstEntry = YES;
    //NSMutableString *expressionString;
//    expressionString = @"test";
    for(id obj in anExpression)
    {
        if(!firstEntry)
            [expressionString appendString:@" "];
        if([obj isKindOfClass:[NSNumber class]])
        {
            //expressionString = [NSString stringWithFormat:@"%G",[(NSNumber *)obj doubleValue]];
            [expressionString appendString:[(NSNumber *)obj stringValue]];
            NSLog(@"expressionString is %@",expressionString);
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            if(([obj length] > 1 ) && ([obj characterAtIndex:0] == '%'))
                [expressionString appendString:[obj substringFromIndex:1]];
            else
                [expressionString appendString:(NSString *)obj];
            NSLog(@"expressionString is %@",expressionString);
        }
        firstEntry = NO;
    }
	[expressionString autorelease];
    return expressionString;
}
/*
 * Class Method - Will iterate through the current expression array, insert variables using 
 * the variables NSDictionary and calcuate the answer to the equation and return it as a 
 * double.  It will create a temporary CalculatorBrain instance to run the elements through 
 * the instance method performOperation:operation passing each operation and setting the local 
 * operand variable.  The CalculatorBrain object is allocated and released each time this 
 * method is called.
*/
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
/*
 * Class initializer - initializes variablesJustAdded to NO.
*/
-(id)init
{
    [super init];
    variableJustAdded = NO;
    return self;
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

/*
 * Private Instance Method - Used to add entries (Operands and Operations) to the 
 * internalExpression array.
*/
- (void)addToExpression:(id)anEntry
{
    if(!internalExpression)
        internalExpression = [[NSMutableArray alloc]init];
    [internalExpression addObject:(id)anEntry];
    NSLog(@"expression = %@", internalExpression);
}

/*
 * Instance Method - Used to add a variable to internalExpression by calling 
 * addToExpression and appending a "%" to the front so that it can be identified in the array.
 * local calculation variables are cleared since we now have and expression to solve.
 * the view controller will call this when the x, a, or b keys are pressed by the user.
*/
- (void)setVariableAsOperand:(NSString *)variableName
{
    variableName = [VARIABLE_PREFIX stringByAppendingString:variableName];
    [self addToExpression:variableName];
    operand = 0;
    waitingOperand = 0;
    [waitingOperation release];
    waitingOperation = nil;
    variableJustAdded = YES;
}

/* 
 * Private Instance Method - called by performOperation to perform the 2 number calculations
 * (+, -, /, *). In case of "/" will make sure not to divide by zero.
*/
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
/*
 * Instance Method - Takes the latest operation passed to it and calculates the result which
 * is returned as a double.  Will use the current instance variable operand waitingOperation 
 * and waitingOperand for the calculation if necessary.  If calculation is a single number 
 * command (1/number), then just operand is used.  The storage and recall commands use 
 * NSUserDefaults so that the values are retained even after exiting the application.
 * Will also add each operand and operation to the internalExpression array in case a variable
 * is added by calling the private instance method addToExpression.
*/
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
        variableJustAdded = NO;
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
	} else{ 
        if(!variableJustAdded)
        {
        	[self addToExpression:(id)[NSNumber numberWithDouble: operand]];
            variableJustAdded = NO;
        }
        [self addToExpression:operation];
        if (![CalculatorBrain variablesInExpression:[self expression]])
        {
            [self performWaitingOperation];
            [waitingOperation release];
            waitingOperation = operation;
            [operation retain];
            waitingOperand = operand;
        }
	}

	return operand;
}

// release the instance array.
- (void)dealloc
{
    [internalExpression release];
    [super dealloc];
}

@end
