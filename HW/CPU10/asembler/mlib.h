#pragma once
#include <stdio.h>

#define LINE_LEN	256

int ReadLine(FILE *f, char *line);
int strToNum(char *str, char base);
int isAlpha(char c);
int isDigit(char c);
int isAlphaAF(char c);

