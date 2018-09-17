#include "mlib.h"
#include <string.h>
#include <math.h>


int ReadLine(FILE *f, char *line){
	int i, n, nl, len;
	char buff[LINE_SIZE]={0};
	long start=ftell(f);

	if((n=fread(buff, 1, LINE_SIZE, f))<1) return 0;
	for(i=0;i<n;++i){
		if(buff[i]=='\n'){
			nl=1;
			break;
		}
	}
	len=i;
	if(line!=NULL){
		memset(line, 0, LINE_SIZE);
		memcpy(line, buff, len);
	}else{
		return 0;
	}
	fseek(f, start+len+nl, SEEK_SET);
	return 1;
}

char *getToken(char *buff, char *token){
	int strtoken=0;
	while(*buff==' ' || *buff=='\t') ++buff;
	while(1){
		if((*buff==' ' && !strtoken) || *buff=='\t' || *buff==0) break;

		if(!strtoken && *buff=='"') strtoken=1;
		else if(strtoken && *buff=='"') strtoken=0;
		*token=*buff;
		++token;
		++buff;
	}
	*token=0;
	return buff;
}

int strToNum(char *str, char base){
	int i=0;
	int val=0;
	int neg=0;
	int len=strlen(str);

	if(str[i]=='-'){
		neg=1;
		++i;
	}

	if(base=='b'){
		for(i=len-1;i>=0;--i){
			if(str[i]=='1'){
				val=val+pow(2, len-i-1);
			}
		}
	}else if(base=='h'){
		for(i=len-1;i>=0;--i){
			int n;
			if(str[i]>='0' && str[i]<='9'){
				n=str[i]-'0';
			}else if(str[i]>='A' && str[i]<='F'){
				n=str[i]-'A'+10;
			}else if(str[i]>='a' && str[i]<='f'){
				n=str[i]-'a'+10;
			}
			val=val+n*pow(16, len-i-1);
		}
	}else if(base=='d'){
		for(i=len-1;i>=0;--i){
			int n=str[i]-'0';
			val=val+n*pow(10, len-i-1);
		}
	}

	if(neg) return -val;
	else	return val;
}

int isAlpha(char c){
	if(c>='a' && c<='z') return 1;
	if(c>='A' && c<='Z') return 1;
	return 0;
}

int isDigit(char c){
	if(c>='0' && c<='9') return 1;
	else return 0;
}

int isHexDigit(char c){
	if(c>='a' && c<='f') return 1;
	if(c>='A' && c<='F') return 1;
	if(isDigit(c))		return 1;
	return 0;
}



int parseLabel(char *t){
	if(*t!='_' && !isAlpha(*t)) return 0;
	++t;

	while(*t!=0 && *t!=':'){
		if(!isAlpha(*t) && !isDigit(*t) && *t!='_') return 0;
		++t;
	}
	if(*t==':'){
		*t=0;
		return 1;
	}else{
		return 0;
	}
}

int parseMnemonic(char *t){
	while(isAlpha(*t)) ++t;
	if(*t==0) return 1;
	else return 0;
}

int parseCommand(char *t){
	if(*t!='.') return 0;
	++t;
	while(isAlpha(*t)) ++t;

	if(*t==0) return 1;
	else return 0;
}

int parseNumber(char *t){
	char *tmp;
	if(*t=='$'){
		++t;
		tmp=t;
		while(isHexDigit(*tmp)) ++tmp;
		if(*tmp!=0) return -1;
		else 		return strToNum(t, 'h');
	}else if(*t=='%'){
		++t;
		tmp=t;
		while(*tmp=='0' || *tmp=='1'){
			++tmp;
		}
		if(*tmp!=0) return -1;
		else 		return strToNum(t, 'b');
	}else if(*t=='\''){
		return *(t+1);
	}else{
		tmp=t;
		while(isDigit(*tmp)){
			++tmp;
		}
		if(*tmp!=0) return -1;
		else 		return strToNum(t, 'd');
	}
}

int parseLabelArg(char *t){
	if(isAlpha(*t) || *t=='_') ++t;
	else return 0;

	while(isAlpha(*t) || isDigit(*t) || *t=='_') ++t;
	if(*t!=0) return 0;
	else return 1;
}

int parseEnd(char *t){
	if(*t==';' || *t==0) return 1;
	else				return 0;
}

