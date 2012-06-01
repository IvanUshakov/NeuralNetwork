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
		
//		NSString *path = [NSString stringWithFormat:@"%@/numbers", [[NSFileManager defaultManager] currentDirectoryPath]];
//		NSURL *directoryURL = [NSURL fileURLWithPath:path];
//		NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL
//																 includingPropertiesForKeys:NULL
//																					options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
//																			   errorHandler:^(NSURL *url, NSError *error) {return YES;}];
//		for (NSURL *url in enumerator) { 
//			NSInteger result = [[url lastPathComponent] integerValue];
//			NSDirectoryEnumerator *enumerator2 = [[NSFileManager defaultManager] enumeratorAtURL:url
//																	 includingPropertiesForKeys:NULL
//																						options:NSDirectoryEnumerationSkipsHiddenFiles
//																				   errorHandler:^(NSURL *url, NSError *error) {return YES;}];
//			for (NSURL *url in enumerator2) { 
//				[network backwardPropagationWithInput:imageFileToArray([url path]) result:result];
//			}
//		}

		NSString *path = [NSString stringWithFormat:@"%@/numbers", [[NSFileManager defaultManager] currentDirectoryPath]];
		for (NSInteger i = 0; i < 69; i++)
			for (NSInteger j = 0; j <= 9; j++) {
				NSString *path2 = [NSString stringWithFormat:@"%@/%d/%d.png", path, j, i];
				[network backwardPropagationWithInput:imageFileToArray(path2) result:j];
			}
		
		NSString  *inputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		for (NSInteger i = 0; i <= 9; i++) {
			NSString  *inputPath2 = [NSString stringWithFormat:@"%@/%d.png", inputPath, i];
			NSLog(@"%ld", [network forwardPropagationWithInput:imageFileToArray(inputPath2)]);
		}
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
			array[i] = 0;
		else  
			array[i] = 1;
		i++;
	}    
	return array;
}

