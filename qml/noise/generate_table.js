var N = []

for (var i=0; i<256; ++i) 
    N[i] = i;

N.swap = function(i, j) {
    var tmp = this[i]
    this[i] = this[j]
    this[j] = tmp
}

var margin = 0;
while (margin < 0.015) {
    margin = 1;
	for (var i=0; i<256; ++i) {
    	var j = Math.floor(Math.random() * 256)
	    var k = Math.floor(Math.random() * 256)
    	N.swap(j, k)
	}
    for (var i=1; i<256; ++i) {
        var delta = Math.abs(N[i] - N[i-1]) / 255;
        if (delta < margin)
            margin = delta;
    }
}
	

print("const int P[256] = int[256] (");
var str = "";
for (var i=0; i<256; ++i) {
	if (i%16 == 0) {
		if (i>0) 
			str += "\n"
		str += "    "
	}
	str += Math.floor(N[i]*1000)/1000;	
	if (i<255)
		str += ", "
}
print(str + "\n);")


print("const vec2 G2[256] = vec2[256] (");
var str = "";
for (var i=0; i<256; ++i) {
    if (i%8 == 0) {
        if (i>0) 
            str += "\n"
        str += "    "
    }
    var x = Math.random() * 2 - 1;
    var y = Math.random() * 2 - 1    ;
    var l = Math.sqrt(x*x + y*y);
    str += "vec2(" + Math.floor(1000.0 * x/l)/1000 + ", " + Math.floor(1000.0 * y/l)/1000 + ")"
    if (i<255)
        str += ", "
}
print(str + "\n);");
