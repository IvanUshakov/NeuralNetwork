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
#import "NeuralNetwork.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		NSString  *inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/input.jpg"];
		NSURL *url = [NSURL fileURLWithPath:inputPath];
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

		
		NeuralNetwork *network = [[NeuralNetwork alloc] initWithNumInputs:192 numHiddenNeurons:96 numOutputs:10];
		
		NSLog(@"%ld", [network forwardPropagationWithInput:array]);
		
		[network release];
	}
    return 0;
}

