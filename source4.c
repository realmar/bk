#include <stdio.h>
#include "ljacklm.h"

void HandleError(long error, char *function_name) {
	char error_string[50];
	if(error) {
		GetErrorString(error, error_string);
		printf("%s error %ld: %s\n", function_name, error, error_string);
		exit(1);
	}
}

int main() {
	return 0;
}

int test() {
	float version = 0.0;
	long errorcode;

	long id_num = -1;
	long demo = 0;
	long tris_d = 0;
	long tris_io = 0;
	long state_d = 0;
	long state_io = 0;
	long update_digital = 0;
	long output_d = 0;
	long output_io = 0;

	tris_d = (long)0x00FF;
	tris_io = (long)0x3;
	state_d = (long)0x00F0;
	state_io = (long)0x2;

	tris_d = (long)0xFFFF;
	tris_io = (long)0x0;
	state_d = (long)0xC003;
	state_io = (long)0x0;

	output_io = tris_io & state_io;

	printf("Starting performing some setting of the U12\n");
	printf("update_digital = 1\n");

	update_digital = 1;

	errorcode = DigitalIO(&id_num, demo, &tris_d, tris_io, &state_d, &state_io, update_digital, &output_d);
	HandleError(errorcode, "DigitalIO (update)");

	printf("Parameter set to U12 you should messaure now the output\n");
	printf("update_digital = 0\n");

	update_digital = 0;
}
