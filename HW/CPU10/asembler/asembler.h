#pragma once

unsigned char* asembler(char *file_name, int *length);
char *getToken(char *buff, char *token);
int parseLabel(char *t);
int parseMnemonic(char *t);
int parseCommand(char *t);
int parseNumber(char *t);
int parseString(char *t);
int parseConstant(char *t);
void checkEnd();

