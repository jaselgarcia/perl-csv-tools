#!/usr/bin/env -S awk -f

BEGIN {
	FS = ",";
	max = 0 
}

FNR == NR {
	if (NF > max) {
		max = NF;
	}
	next;
}

FNR == 1 {
	for (i = 1; i < max; i++) {
	       	printf header " " i FS;
	}

	printf header " " i ORS;
}

{
	printf $0;
	for (i = 0; i < max - NF; i++) {
	       	printf FS;
	}

	printf ORS;
}
