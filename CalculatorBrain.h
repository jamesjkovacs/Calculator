//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Vijay Parikh on 5/24/11.
//  Copyright 2011 Amano McGann. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalculatorBrain : NSObject {
@private
	double operand;
	NSString *waitingOperation;
	double waitingOperand, numberMemory;
}

@property double operand;
//- (void)setOperand:(double)anOperand;
- (double)performOperation:(NSString *)operation;

@end
