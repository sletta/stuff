var N = []

var tableSize = 256;

for (var i=0; i<tableSize; ++i) 
    N[i] = i;

N.swap = function(i, j) {
    var tmp = this[i]
    this[i] = this[j]
    this[j] = tmp
}


var margin = 0;
while (margin < 0.015) {
    margin = 1;
	for (var i=0; i<tableSize; ++i) {
    	var j = Math.floor(Math.random() * tableSize)
	    var k = Math.floor(Math.random() * tableSize)
    	N.swap(j, k)
	}
    for (var i=1; i<tableSize; ++i) {
        var delta = Math.abs(N[i] - N[i-1]) / (tableSize - 1);
        if (delta < margin)
            margin = delta;
    }
}
	

print("const int P[" + tableSize + "] = int[" + tableSize + "] (");
var str = "";
for (var i=0; i<tableSize; ++i) {
	if (i%16 == 0) {
		if (i>0) 
			str += "\n"
		str += "    "
	}
	str += Math.floor(N[i]*1000)/1000;	
	if (i<tableSize - 1)
		str += ", "
}
print(str + "\n);")


print("const vec2 G2[" + tableSize + "] = vec2[" + tableSize + "] (");
var str = "";
for (var i=0; i<tableSize; ++i) {
    if (i%6 == 0) {
        if (i>0) 
            str += "\n"
        str += "    "
    }
    var x = Math.random() * 2 - 1;
    var y = Math.random() * 2 - 1    ;
    var l = Math.sqrt(x*x + y*y);
    str += "vec2(" + Math.floor(1000.0 * x/l)/1000 + ", " + Math.floor(1000.0 * y/l)/1000 + ")"
    if (i<tableSize - 1)
        str += ", "
}
print(str + "\n);");

print("const vec3 G3[" + tableSize + "] = vec3[" + tableSize + "] (");
var str = "";
for (var i=0; i<tableSize; ++i) {
    if (i%6 == 0) {
        if (i>0) 
            str += "\n"
        str += "    "
    }
    var x = Math.random() * 2 - 1;
    var y = Math.random() * 2 - 1    ;
    var z = Math.random() * 2 - 1    ;
    var l = Math.sqrt(x*x + y*y + z*z);
    str += "vec3(" + Math.floor(1000.0 * x/l)/1000 + ", "
                   + Math.floor(1000.0 * y/l)/1000 + ", "
                   + Math.floor(1000.0 * y/l)/1000 + ")"
    if (i<tableSize - 1)
        str += ", "
}
print(str + "\n);");
