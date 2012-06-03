//
//  ImagesProcessing.m
//  NeuralNetwork
//
//  Created by Иван Ушаков on 03.06.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import "ImagesProcessing.h"

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