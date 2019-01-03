#pragma once


struct fs_d{
	char name[16];
	int max_capacity;
	int max_file_size;
	int max_file_count;
	int free_bytes;
	int file_count;
};


int fs_init();
void fs_info(struct fs_d* desc);
int fs_format(char *name, int file_size);
int fs_fcreate(char *name);
int fs_fremove(char *name);
int fs_list(char *files);
int fs_fread(char *name, char *data);
int fs_fwrite(char *name, char *data);
