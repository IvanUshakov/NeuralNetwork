//
//  NeuralNetwork.m
//  NeuralNetwork
//
//  Created by Иван Ушаков on 31.05.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import "NeuralNetwork.h"

@implementation Neuron
@synthesize lastActivation = _lastActivation;
@synthesize weights = _weights;

- (id)initWithLearningRate:(float)learningRate numInputs:(NSInteger)numInputs
{
	self = [super init];
	if (self) {
		_learningRate = learningRate;
		_numInputs = numInputs;
		_lastActivation = 0;
		_weights = malloc(sizeof(float) * _numInputs);
		for (NSInteger i = 0; i < _numInputs; i++) {
			_weights[i] = (float)rand() / RAND_MAX - 0.5f;
		}
	}
	return self;
}

- (float)forwardPropagationWithData:(float[])data
{
	float sum = 0;
	for (NSInteger i = 0; i < _numInputs; i++) {
		sum += _weights[i] * data[i];
	}
	//NSLog(@"%f", sum);
	_lastActivation = [self activationFunction:sum];
	return _lastActivation;
}

- (void)backwardPropagationWithError:(float)error data:(float[])data
{
	for (NSInteger i = 0; i < _numInputs; i++) {
		_weights[i] = _weights[i] + _learningRate * error * data[i];
	}
}

- (float)activationFunction:(float)sum
{
	return (1 / (1 + exp(-sum)));
}

- (void)dealloc
{
	[super dealloc];
	free(_weights);
}
@end

@implementation NeuralNetwork
- (id)initWithNumInputs:(NSInteger)numInputs numHiddenNeurons:(NSInteger)numHiddenNeurons numOutputs:(NSInteger)numOutputs
{
	self = [super init];
	if (self) {
		_learningRate = 0.07;
		_numHiddenNeurons = numHiddenNeurons;
		_numOutputs = numOutputs;
		_hiddenNeurons = malloc(sizeof(Neuron*) * _numHiddenNeurons);
		for (NSInteger i = 0; i < _numHiddenNeurons; i++) {
			_hiddenNeurons[i] = [[Neuron alloc] initWithLearningRate:_learningRate numInputs:numInputs];
		}
		_outputNeurons = malloc(sizeof(Neuron*) * _numOutputs);
		for (NSInteger i = 0; i < _numOutputs; i++) {
			_outputNeurons[i] = [[Neuron alloc] initWithLearningRate:_learningRate numInputs:_numHiddenNeurons];
		}
		_hiddenActivations = malloc(sizeof(float) * _numHiddenNeurons);
		_outputActivations = malloc(sizeof(float) * _numOutputs);
	}
	return self;
}

- (NSInteger)findMax:(float*)activationValues numvalues:(NSInteger)numvalues;
{
	NSInteger max = 0;
	for (NSInteger i = 0; i < numvalues; i++) {
		if (activationValues[i] > activationValues[max]) {
			max = i;
		}
	}
	return max;
}

- (NSInteger)forwardPropagationWithInput:(float[])data;
{
	for (NSInteger i = 0; i < _numHiddenNeurons; i++) {
		_hiddenActivations[i] = [_hiddenNeurons[i] forwardPropagationWithData:data];
		//NSLog(@"_hiddenActivations[%ld] = %f", i, _hiddenActivations[i]);
	}
	for (NSInteger i = 0; i < _numOutputs; i++) {
		_outputActivations[i] = [_outputNeurons[i] forwardPropagationWithData:_hiddenActivations];
		//NSLog(@"_outputActivations[%ld] = %f", i, _outputActivations[i]);
	}
	return [self findMax:_outputActivations numvalues:_numOutputs];
}

- (void)backwardPropagationWithInput:(float[])data result:(NSInteger)result;
{
	[self forwardPropagationWithInput:data];
	float *errors = malloc(sizeof(float) * _numOutputs);
	for (NSInteger i = 0; i < _numOutputs; i++)
	{
		float fire = (i == result) ? 1 : 0;
		float lastActivation = [_outputNeurons[i] lastActivation];
		float errorTerm = lastActivation * (1 - lastActivation) * (fire - lastActivation);
		errors[i] = errorTerm;
		[_outputNeurons[i] backwardPropagationWithError:errorTerm data:_hiddenActivations];
	}
	for (NSInteger i = 0; i < _numHiddenNeurons; i++) {
		float weightDeltaH = 0;
		for (NSInteger j = 0; j < _numOutputs; j++) {
			weightDeltaH += errors[j] * [_outputNeurons[j] weights][i];
		}
		float lastActivation = [_hiddenNeurons[i] lastActivation];
		float errorTerm = weightDeltaH * lastActivation * (1 - lastActivation);
		[_hiddenNeurons[i] backwardPropagationWithError:errorTerm data:data];
	}
	free(errors);
}

- (void)dealloc
{
	[super dealloc];
	for (NSInteger i = 0; i < _numHiddenNeurons; i++) {
		[_hiddenNeurons[i] release];
	}
	free(_hiddenNeurons);
	for (NSInteger i = 0; i < _numOutputs; i++) {
		[_outputNeurons[i] release];
	}
	free(_outputNeurons);
	
	free(_hiddenActivations);
	free(_outputActivations);
}
@end
