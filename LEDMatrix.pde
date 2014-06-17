/************************************************************************/
/*																		*/
/*	LEDMatrix.pde   Simple MPIDE sketch to control a 10x10 LED matrix   */
/*                                                                      */
/*																		*/
/************************************************************************/
/*  Author:     Marshall Wingerson                                      */
/*         Marshall's Tech Blog                                         */
/************************************************************************/
/*
* This program is free software; distributed under the terms of 
* BSD 3-clause license ("Revised BSD License", "New BSD License", or "Modified BSD License")
*
* Redistribution and use in source and binary forms, with or without modification,
* are permitted provided that the following conditions are met:
*
* 1.    Redistributions of source code must retain the above copyright notice, this
*        list of conditions and the following disclaimer.
* 2.    Redistributions in binary form must reproduce the above copyright notice,
*        this list of conditions and the following disclaimer in the documentation
*        and/or other materials provided with the distribution.
* 3.    Neither the name(s) of the above-listed copyright holder(s) nor the names
*        of its contributors may be used to endorse or promote products derived
*        from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
* IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
* OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/
/************************************************************************/
/*  Description: This is my basic Conway's game of life program for     */
/*     MPIDE. There are simple definitions that can be changed to       */
/*     modify the sketch for different sizes of matrixes.               */
/*																		*/													
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/*																		*/
/*	05/25/2014(MarshallW): Created	                                    */
/*																		*/
/************************************************************************/

#include<LEDMatrix.h>

#define gridRows 10
#define gridCols 10
#define LEDRefreshCounterMax 1
#define lastPatternTimeMax 900
#define lastResetTimeMax 80000

#define blinkTime 300

//GOL defs
#define GOLStartingNum 25

void toggleLED(int xCoord, int yCoord);
void updatePattern(void);

char gameGrid[gridRows][gridCols];
unsigned int lastLEDRefreshTime = 0;
unsigned int lastPatternTime = 0;
unsigned int lastResetTime = 0;

int currentLocX = 0;
int currentLocY = 0;

void setup(void){
	randomSeed(analogRead(A0));
	
	setupUsedPins();
	
	initGOLMatrix();
	
	lastLEDRefreshTime = millis();
	lastPatternTime = millis();
	lastResetTime = millis();
}

void loop(void){
	//update pattern on LED matrix
	if(millis() - lastPatternTime > lastPatternTimeMax){
		updatePattern();
		lastPatternTime = millis();
	}
	//update LED matrix
	if(millis() - lastLEDRefreshTime > LEDRefreshCounterMax){
		printLEDScreen();
		lastLEDRefreshTime = millis();
	}
	//test for timeout of game
	if(millis() - lastResetTime > lastResetTimeMax){
		//reinitialize matrix
		initGOLMatrix();
		
		lastResetTime = millis();
	}
}

void setupUsedPins(void){
	//initialize all used pins
	for(int i = 0; i < 10; i++){
		pinMode(posPins[i], OUTPUT);
		digitalWrite(posPins[i], LOW);
		pinMode(negPins[i], OUTPUT);
		digitalWrite(negPins[i], HIGH);
	}
}

void updatePattern(void){
	int cellCounter;
	//update GOL
	for(int y = 0; y < gridRows; y++){
		for(int x= 0; x < gridCols; x++){
			cellCounter = 0;
			
			//not on edge
			if(x>0 && x<(gridCols-1) && y>0 && y<(gridRows-1)){
				//top-left coord
				if(gameGrid[y-1][x-1] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y-1][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y-1][x+1] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x+1] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y+1][x+1] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y+1][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y+1][x-1] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x-1] == 1)
					cellCounter++;
					
				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}

			//top-left corner
			else if(x == 0 && y == 0){
				//top-left coord
				if(gameGrid[y+(gridRows-1)][x+(gridCols-1)] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y+(gridRows-1)][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y+(gridRows-1)][x+1] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x+1] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y+1][x+1] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y+1][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y+1][x+(gridCols-1)] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x+(gridCols-1)] == 1)
					cellCounter++;
				
				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}
			
			//top-right corner
			else if(x == (gridCols-1) && y == 0){
				//top-left coord
				if(gameGrid[y+(gridRows-1)][x-1] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y+(gridRows-1)][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y+(gridRows-1)][x-(gridCols-1)] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x-(gridCols-1)] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y+1][x-(gridCols-1)] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y+1][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y+1][x-1] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x-1] == 1)
					cellCounter++;
				
				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}

			//lower-right corner
			else if(x == (gridCols-1) && y == (gridRows-1)){
				//top-left coord
				if(gameGrid[y-1][x-1] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y-1][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y-1][x-(gridCols-1)] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x-(gridCols-1)] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y-(gridRows-1)][x-(gridCols-1)] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y-(gridRows-1)][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y-(gridRows-1)][x-1] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x-1] == 1)
					cellCounter++;
				
				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}
			
			//lower-left corner
			else if(x == 0 && y == (gridRows-1)){
				//top-left coord
				if(gameGrid[y-1][x+(gridCols-1)] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y-1][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y-1][x+1] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x+1] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y-(gridRows-1)][x+1] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y-(gridRows-1)][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y-(gridRows-1)][x+(gridCols-1)] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x+(gridCols-1)] == 1)
					cellCounter++;
				
				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}
					
			//top edge
			else if(y == 0){
				//top-left coord
				if(gameGrid[y+(gridRows-1)][x-1] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y+(gridRows-1)][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y+(gridRows-1)][x+1] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x+1] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y+1][x+1] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y+1][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y+1][x-1] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x-1] == 1)
					cellCounter++;
			}
			
			//lower edge
			else if(y == (gridRows - 1)){
				//top-left coord
				if(gameGrid[y-1][x-1] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y-1][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y-1][x+1] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x+1] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y-(gridRows-1)][x+1] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y-(gridRows-1)][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y-(gridRows-1)][x-1] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x-1] == 1)
					cellCounter++;
				
				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}
			
			//left edge
			else if(x == 0){
				//top-left coord
				if(gameGrid[y-1][x+(gridCols-1)] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y-1][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y-1][x+1] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x+1] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y+1][x+1] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y+1][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y+1][x+(gridCols-1)] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x+(gridCols-1)] == 1)
					cellCounter++;

				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}
			
			//right edge
			else if(x == (gridCols - 1)){
				//top-left coord
				if(gameGrid[y-1][x-1] == 1)
					cellCounter++;
				//above coord
				if(gameGrid[y-1][x] == 1)
					cellCounter++;
				//top-right coord
				if(gameGrid[y-1][x-(gridCols-1)] == 1)
					cellCounter++;
				//right coord
				if(gameGrid[y][x-(gridCols-1)] == 1)
					cellCounter++;
				//bottom-right coord
				if(gameGrid[y+1][x-(gridCols-1)] == 1)
					cellCounter++;
				//bottom coord
				if(gameGrid[y+1][x] == 1)
					cellCounter++;
				//bottom-left coord
				if(gameGrid[y+1][x-1] == 1)
					cellCounter++;
				//left coord
				if(gameGrid[y][x-1] == 1)
					cellCounter++;

				//modify depending on number of live cells
				if(cellCounter < 2 || cellCounter > 3)
					gameGrid[y][x] = 0;
				
				else if(cellCounter == 2);
					//do nothing
					
				else
					gameGrid[y][x] = 1;
			}	
		}
	}
}

void clearGOLMatrix(void){
	//initialize gameGrid to zeros
	for(int i = 0; i < gridRows; i++){
		for(int j = 0; j < gridCols; j++)
			gameGrid[i][j] = 0;
	}
}

void initGOLMatrix(void){
	//clear matrix
	clearGOLMatrix();
	
	//set random locations on matrix
	for(int i = 0; i < GOLStartingNum; i++){
		int randX = random(10);
		int randY = random(10);
		if(gameGrid[randX][randY] == 1)
			i--;
		else
			gameGrid[randX][randY] = 1;
	}	
}

void printLEDScreen(void){
	for(int i = 0; i < gridRows; i++){
		for(int j = 0; j < gridCols; j++){
			if(gameGrid[i][j] == 1)
			{
				digitalWrite(posPins[i], HIGH);
				digitalWrite(negPins[j], LOW);
				
				delayMicroseconds(blinkTime);
				
				digitalWrite(posPins[i], LOW);
				digitalWrite(negPins[j], HIGH);
				//toggleLED(i,j);
			}
		}
	}
}

