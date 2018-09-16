#include "mlib.h"
#include <string.h>
#include <math.h>

int ReadLine(FILE *f, char *line){
	int i, n, nl, len;
	char buff[LINE_LEN]={0};
	long start=ftell(f);

	if((n=fread(buff, 1, LINE_LEN, f))<1) return 0;
	for(i=0;i<n;++i){
		if(buff[i]=='\n'){
			nl=1;
			break;
		}
	}
	len=i;
	if(line!=NULL){
		memset(line, 0, LINE_LEN);
		memcpy(line, buff, len);
	}else{
		return 0;
	}
	fseek(f, start+len+nl, SEEK_SET);
	return 1;
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

int isAlphaAF(char c){
	if(c>='a' && c<='f') return 1;
	if(c>='A' && c<='F') return 1;
	return 0;
}



