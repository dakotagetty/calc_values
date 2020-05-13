#include "stdlib.h"
#include "stdio.h"
/* BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I HAVE PERFORMED ALL    * OF THE WORK TO DETERMINE THE ANSWERS FOUND WITHIN THIS FILE MYSELF WITH    * NO ASSISTANCE FROM ANY PERSON OTHER THAN THE INSTRUCTOR OF THIS COURSE    * OR ONE OF OUR UNDERGRADUATE GRADERS. .  I UNDERSTAND THAT TO DO OTHERWISE   * IS A VIOLATION OF OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY.   */
/* Author: Dakota Getty */
struct ThreeD_values{
	unsigned long z;
	long x;
	long y;
}*values;

void multlong(long a, long b, struct ThreeD_values* values);

int main(int argc, char ** argv){
long a, b, twoA, twoB, count, i;
FILE *results;

if (argc != 4) {
	printf("Usage: %s <val1> <val2> <filename>\n", argv[0]);
	return;
}
/* Creates numerical values from input and calculates size of memory to allocate */
a = atol(argv[1]);
b = atol(argv[2]);
twoA = 2 * a + 1;
twoB = 2 * b + 1;
values = (struct ThreeD_values *) malloc((twoA*twoB)*sizeof(struct ThreeD_values));
count = twoA*twoB;
multlong(a, b, values);
/* Opens the file */
results = fopen("results", "w");
if (results == NULL){
	perror("results");
	free(values);
	exit(EXIT_FAILURE);
}
/* Prints results to the file from the structure */
for(i = 0; i < count; i++){
	fprintf(results, "%li %li %lu\n", values->x, values->y, values->z);
	values=values+1;
}
/* Closes the output file */
if (fclose(results) != 0){
	perror("fclose");
	free(values);
	exit(EXIT_FAILURE);
}
return;

}
