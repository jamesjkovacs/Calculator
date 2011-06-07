//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jim Kovacs on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VARIABLE_PREFIX @"%"

@interface CalculatorBrain : NSObject {
@private
	double operand;
	NSString *waitingOperation;
	double waitingOperand;
    NSMutableArray *internalExpression;
    bool variableJustAdded;
}

@property double operand;
@property (readonly) id expression;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;

+ (double)evaluateExpression:(id)anExpression
         usingVariableValues:(NSDictionary *)variables;
+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;

+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

@end
