//
//  ColoredTerminal.m
//  NeuralNetwork
//
//  Created by Иван Ушаков on 03.06.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#include <stdio.h>

void textcolor(int attr, int fg, int bg)
{	
	char command[13];
	sprintf(command, "%c[%d;%d;%dm", 0x1B, attr, fg + 30, bg + 40);
	printf("%s", command);
}