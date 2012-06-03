//
//  main.m
//  NeuralNetwork
//
//  Created by Иван Ушаков on 31.05.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"

int main(int argc, const char * argv[])
{
	int result = 0;
	@autoreleasepool {
		App *app = [[App alloc] init];
		result = [app run];
		[app release];
	}
    return result;
}

