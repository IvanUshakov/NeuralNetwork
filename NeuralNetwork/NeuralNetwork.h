//
//  NeuralNetwork.h
//  NeuralNetwork
//
//  Created by Иван Ушаков on 31.05.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Neuron : NSObject {
	float		_learningRate;
	NSInteger	_numInputs;
	float		_lastActivation;
	float		*_weights;
}

@property (nonatomic, assign, readonly) float lastActivation;
@property (nonatomic, assign, readonly) float *weights;

- (id)initWithLearningRate:(float)learningRate numInputs:(NSInteger)numInputs;
- (float)forwardPropagationWithData:(float[])data;
- (void)backwardPropagationWithError:(float)error data:(float[])data;
- (float)activationFunction:(float)sum;
@end

@interface NeuralNetwork : NSObject{
	float		_learningRate;
	NSInteger	_numHiddenNeurons;
	NSInteger	_numOutputs;
	Neuron		**_hiddenNeurons;
	Neuron		**_outputNeurons;
	float		*_hiddenActivations;
	float		*_outputActivations;
}
- (id)initWithNumInputs:(NSInteger)numInputs numHiddenNeurons:(NSInteger)numHiddenNeurons numOutputs:(NSInteger)numOutputs;
- (NSInteger)findMax:(float*)activationValues numvalues:(NSInteger)numvalues;
- (NSInteger)forwardPropagationWithInput:(float[])data;
- (void)backwardPropagationWithInput:(float[])data result:(NSInteger)result;
@end
