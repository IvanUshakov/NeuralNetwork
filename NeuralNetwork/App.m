//
//  App.m
//  NeuralNetwork
//
//  Created by Иван Ушаков on 03.06.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "App.h"
#import "ImagesProcessing.h"
#import "ColoredTerminal.h"

@interface App()
@property (nonatomic, retain) NeuralNetwork		*network;
@property (nonatomic, retain) FSArgumentPackage	*argumentPackage;

- (void)showError:(NSError*)error;

- (void)trainWithFolder:(NSString*)folder examplesCount:(NSInteger)count;
- (void)solveFile:(NSString*)file;
- (void)showHelp;
@end

@implementation App
@synthesize network = _network;
@synthesize argumentPackage = _argumentPackage;

- (id)init
{
	self = [super init];
	if (self) {		
		[self parseParametrs];
		self.network = [[NeuralNetwork alloc] initWithNumInputs:336 numHiddenNeurons:130 numOutputs:10];
	}
	return  self;
}

- (void)dealloc
{
	[_network release];
	[_argumentPackage release];
	[super dealloc];
}

#pragma mark - working

- (int)run
{
	BOOL tarainFlag = [self.argumentPackage boolValueOfFlag:@"t"];
	BOOL solveFlag = [self.argumentPackage boolValueOfFlag:@"s"];
	if ((!tarainFlag && !solveFlag) || (tarainFlag && solveFlag)) {
		NSError *error = [NSError errorWithDomain:@"com.NeuralNetwork.errorDomain"
											 code:MissingSignatures 
										 userInfo:nil];

		[self showError:error];
	}
	if (tarainFlag) {
		[self trainWithFolder:@"" examplesCount:90];
	}
	if (solveFlag) {
		[self solveFile:@""];
	}
	return 0;
}

- (void)showError:(NSError*)error
{
	NSUInteger count;
	FSArgumentSignature * signature;
	switch (error.code) {
		case TooManySignatures:
			count = [[[error userInfo] objectForKey:FSAPErrorDictKeys.CountOfTooManySignatures] unsignedIntegerValue];
			signature = [[error userInfo] objectForKey:FSAPErrorDictKeys.TooManyOfThisSignature];
			NSLog(@"You used %lu too many of the \"%@\" argument!", count-1, signature.longNames);
			NSLog(@"Use flag -h for help.");
			break;
			
		case ArgumentMissingValue:
			NSLog(@"You used flag with required value, but not set value!");
			NSLog(@"Use flag -h for help.");
			break;
			
		case UnknownArgument:
			NSLog(@"You used an unknown flag: %@!", [[error userInfo] objectForKey:FSAPErrorDictKeys.UnknownSignature]);
			NSLog(@"Use flag -h for help.");
			break;
			
		case MissingSignatures:
			NSLog(@"You should suse one of the next flags: -t or -s!");
			NSLog(@"Use flag -h for help.");
			break;
		default:
			NSLog(@"Miscelleneous error %@", error);
			NSLog(@"Use flag -h for help.");
			break;
	}
}

#pragma mark - tasks

- (void)trainWithFolder:(NSString*)folder examplesCount:(NSInteger)count
{
	for (NSInteger i = 0; i < count; i++) {
		for (NSInteger j = 0; j <= 9; j++) {
			NSString *filePath = [NSString stringWithFormat:@"%@/%d/%d.png", folder, j, i];
			[self.network backwardPropagationWithInput:imageFileToArray(filePath) result:j];
		}
	}
	for (NSInteger i = 0; i <= 9; i++) {
		NSInteger count = 0;
		for (NSInteger j = 1; j < 91; j++) {
			NSString *filePath = [NSString stringWithFormat:@"%@/%d/%d.png", folder, i, j];
			NSInteger result = [self.network forwardPropagationWithInput:imageFileToArray(filePath)];
			if (result == i) {
				count++;
			}
		}
		NSLog(@"%ld - %f%%", i, (float)count / 90 * 100);
	}
}

- (void)solveFile:(NSString*)file
{
	NSLog(@"%ld", [self.network forwardPropagationWithInput:imageFileToArray(file)]);
}

- (void)showHelp
{
	NSArray *signatures = [self parserSignatures];
	[signatures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		printf("%s\n", [[obj descriptionWithLocale:nil indent:1] UTF8String]);
	}];
}

#pragma mark - private

- (NSArray*)parserSignatures
{
	//TODO: set descriptins
	FSArgumentSignature *helpSig = [FSArgumentSignature argumentSignatureAsFlag:@"h" longNames:@"help" multipleAllowed:NO];
	FSArgumentSignature *versionSig = [FSArgumentSignature argumentSignatureAsFlag:@"v" longNames:@"version" multipleAllowed:NO];
	FSArgumentSignature *trainSig = [FSArgumentSignature argumentSignatureAsFlag:@"t" longNames:@"train" multipleAllowed:NO];
	FSArgumentSignature *solveSig = [FSArgumentSignature argumentSignatureAsFlag:@"s" longNames:@"solve" multipleAllowed:NO];
	FSArgumentSignature	*networkFileSig = [FSArgumentSignature argumentSignatureAsNamedArgument:@"n"
																					longNames:@"network-file" 
																					 required:NO
																			  multipleAllowed:NO];
	FSArgumentSignature	*examplesCountSig = [FSArgumentSignature argumentSignatureAsNamedArgument:@"c"
																						longNames:@"examples-count" 
																						 required:NO
																				  multipleAllowed:NO];
	return [NSArray arrayWithObjects:helpSig, versionSig, trainSig, solveSig, networkFileSig, examplesCountSig, nil];	
}

- (void)parseParametrs
{
	NSError * err = nil;
	self.argumentPackage = [FSArgumentParser parseArguments:[[NSProcessInfo processInfo] arguments] 
											 withSignatures:[self parserSignatures]
													  error:&err];
	if (err) {
		[self showError:err];
		exit(-1);
	}
}
@end
