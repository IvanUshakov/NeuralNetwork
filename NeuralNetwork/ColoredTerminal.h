//
//  ColoredTerminal.h
//  NeuralNetwork
//
//  Created by Иван Ушаков on 03.06.12.
//  Copyright (c) 2012 Иван Ушаков. All rights reserved.
//

#define CT_RESET		0
#define CT_BRIGHT 		1
#define CT_DIM			2
#define CT_UNDERLINE 	3
#define CT_BLINK		4
#define CT_REVERSE		7
#define CT_HIDDEN		8

#define CT_BLACK 		0
#define CT_RED			1
#define CT_GREEN		2
#define CT_YELLOW		3
#define CT_BLUE			4
#define CT_MAGENTA		5
#define CT_CYAN			6
#define	CT_WHITE		7

void textcolor(int attr, int fg, int bg);
