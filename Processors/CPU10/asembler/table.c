#include "table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct item{
	char id[128];
	int value;
	struct item *next;
};

static struct item *first; 
static struct item *last;



void table_init(){
	first=NULL;
	last=NULL;
}

int table_add(char* text, int value){
	if(first==NULL){
		first=(struct item*)malloc(sizeof(struct item));
		first->value=value;
		first->next=NULL;
		strcpy(first->id, text);
		last=first;
		return 0;
	}else{
		struct item *p=first;
		while(p!=NULL){
			if(strcmp(p->id, text)==0){
				p->value=value;				
				return 1;
			}
			p=p->next;
		}

		struct item *new=(struct item*)malloc(sizeof(struct item));
		new->value=value;
		new->next=NULL;
		strcpy(new->id, text);

		last->next=new;
		last=new;
		return 0;
	}
}

int table_get(char* text){
	struct item *p=first;
	while(p!=NULL){
		if(strcmp(p->id, text)==0){
			return p->value;
		}
		p=p->next;
	}
	return -1;
}

void table_print(){
	struct item *p=first;
	printf("Table:\n");
	while(p!=NULL){
		printf("%s: %d\n", p->id, p->value);
		p=p->next;
	}
	printf("\n");
}

