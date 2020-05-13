
#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I HAVE PERFORMED ALL   #OF THE WORK TO DETERMINE THE ANSWERS FOUND WITHIN THIS FILE MYSELF WITH   #NO ASSISTANCE FROM ANY PERSON OTHER THAN THE INSTRUCTOR OF THIS COURSE   #OR ONE OF OUR UNDERGRADUATE GRADERS. .  I UNDERSTAND THAT TO DO OTHERWISE  #IS A VIOLATION OF OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY. 
 
# comments in a Makefile start with sharp 

# target all means all targets currently defined in this file
all: lab7.zip calc_values calc_intvalues

# this target is the .zip file that must be submitted to Carmen
lab7.zip: Makefile calc_values.c calc_intvalues.c multlong.s multint.s
	zip lab7.zip Makefile calc_values.c calc_intvalues.c multlong.s multint.s

# this target is the executable for calc_values
calc_values: calc_values.o multlong.o
	gcc calc_values.o multlong.o -o calc_values

# this target is the dependency for calc_values
calc_values.o: calc_values.c
	gcc -ansi -pedantic -g -c -o calc_values.o calc_values.c

# this target is the dependency for multlong
multlong.o: multlong.s
	gcc -g -lc -m64 -c multlong.s

# this target is the executable for calc_intvalues
calc_intvalues: calc_intvalues.o multint.o
	gcc calc_intvalues.o multint.o -o calc_intvalues

# this target is the dependency for calc_intvalues
calc_intvalues.o: calc_intvalues.c
	gcc -ansi -pedantic -g -c -o calc_intvalues.o calc_intvalues.c

# this target is the dependency foint
multint.o: multint.s
	gcc -g -lc -m64 -c multint.s

# this target deletes all files produced from the Makefile
# so that a completely new compile of all items is required
clean:
	rm -rf *.o calc_values calc_intvalues lab7.zip
  
