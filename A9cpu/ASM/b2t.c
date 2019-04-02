#include <stdio.h>
#include <stdlib.h>


int main(int argc, char **argv){
	FILE *fi, *fo;
	char buff1[2];
	char buff2[16];
	int i;

	if(argc!=3){
		printf("Usage b2t [input] [output]\n");
		return 1;
	}

	fi=fopen(argv[1], "rb");
	if(!fi){
		printf("ERROR: fopen.\n");
		return 3;
	}

	fo=fopen(argv[2], "w");
	if(!fo){
		printf("ERROR: fopen.\n");
		return 4;
	}

	while(fread(buff1, 1, 2, fi)==2){
		for(i=7;i>=0;--i){
			if(buff1[1]&(1<<i)) buff2[i]='1';
			else buff2[i]='0';
		}
		for(i=7;i>=0;--i){
			if(buff1[0]&(1<<i)) buff2[i+8]='1';
			else buff2[i+8]='0';
		}
		for(i=15;i>=0;--i){
			fwrite(buff2+i, 1, 1, fo);
		}
		buff2[0]='\n';
		fwrite(buff2, 1, 1, fo);
	}

	fclose(fi);
	fclose(fo);
	return 0;
}

