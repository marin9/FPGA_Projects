#pragma once
#include <stdio.h>

#define LINE_SIZE	256


int ReadLine(FILE *f, char *line);
char *getToken(char *buff, char *token);
int strToNum(char *str, char base);
int isAlpha(char c);
int isDigit(char c);
int isHexDigit(char c);

int parseLabel(char *t);
int parseMnemonic(char *t);
int parseCommand(char *t);
int parseNumber(char *t);
int parseLabelArg(char *t);
int parseEnd(char *t);

