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
		
		NSString  *inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/input.png"];
		float *array = imageFileToArray(inputPath);
		
		NeuralNetwork *network = [[NeuralNetwork alloc] initWithNumInputs:336 numHiddenNeurons:130 numOutputs:10];
		
		[network backwardPropagationWithInput:array result:9];
		NSLog(@"%ld", [network forwardPropagationWithInput:array]);
		
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

