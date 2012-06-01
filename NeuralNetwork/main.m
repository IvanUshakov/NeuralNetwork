//
//  main.m
//  NeuralNetwork
//
//  Created by Иван Ушаков on 31.05.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AppKit/AppKit.h>

#import "FSArgumentSignature.h"
#import "FSArgumentParser.h"
#import "FSArgumentPackage.h"

#import "NeuralNetwork.h"

float* imageFileToArray(NSString *path);

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		NeuralNetwork *network = [[NeuralNetwork alloc] initWithNumInputs:336 numHiddenNeurons:130 numOutputs:10];
		
		NSString *path = [NSString stringWithFormat:@"%@/numbers", [[NSFileManager defaultManager] currentDirectoryPath]];
		NSURL *directoryURL = [NSURL fileURLWithPath:path];
		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL
																 includingPropertiesForKeys:NULL
																					options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
																			   errorHandler:^(NSURL *url, NSError *error) {return YES;}];
		for (NSURL *url in enumerator) { 
			NSInteger result = [[url lastPathComponent] integerValue];
			NSDirectoryEnumerator *enumerator2 = [[NSFileManager defaultManager] enumeratorAtURL:url
																	 includingPropertiesForKeys:NULL
																						options:NSDirectoryEnumerationSkipsHiddenFiles
																				   errorHandler:^(NSURL *url, NSError *error) {return YES;}];
			for (NSURL *url in enumerator2) { 
				float *array = imageFileToArray([url path]);
				[network backwardPropagationWithInput:array result:result];

			}
		}
		
		NSString  *inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/0.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/1.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/2.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/3.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/4.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/5.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/6.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/7.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/8.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/9.png"];
		NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath)]);
		[network release];
	}
    return 0;
}

float* imageFileToArray(NSString *path)
{
	NSURL *url = [NSURL fileURLWithPath:path];
	CIImage *inputImage = [CIImage imageWithContentsOfURL:url];
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCIImage:inputImage];
	CGImageRef inputImageRef = [rep CGImage];
	
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inputImageRef));  
	UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);  
	int length = CFDataGetLength(m_DataRef);  
	
	int size = length / 4;
	float *array = malloc(sizeof(float) * size);
	int i = 0;
	for (int index = 0; index < length; index += 4)  
	{  
		int tmpByte = (m_PixelBuf[index + 1] + m_PixelBuf[index + 2] + m_PixelBuf[index + 3]) / 3;  
		if (tmpByte >= 128)  
			array[i] = 1;
		else  
			array[i] = 0;
		i++;
	}    
	return array;
}

