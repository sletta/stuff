.pragma library


// ************************************************************
// vec3
//

function vec3(x, y, z) {
    this.x = x;
    this.y = y;
    this.z = z;
}

vec3.prototype.dot = function(v) {
    return v.x * this.x
           + v.y * this.y
           + v.z * this.z;
}

vec3.prototype.length = function() {
    return Math.sqrt(this.dot(this));
}



// ************************************************************
// vec4
//

function vec4(x, y, z, w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
}

vec4.prototype.toString = function() { return "vec4(" + this.x + ", " + this.y + ", " + this.z + ", " + this.w + ")"; }

vec4.prototype.dot = function(v) {
    return v.x * this.x
           + v.y * this.y
           + v.z * this.z
           + v.w * this.w
}

vec4.prototype.length = function() {
    return Math.sqrt(this.dot(this));
}


// ************************************************************
// mat4
//

function mat4()
{
    this.data = [1, 0, 0, 0,
                 0, 1, 0, 0,
                 0, 0, 1, 0,
                 0, 0, 0, 1];
}

mat4.prototype.clone = function() {
    var m = new mat4();
    for (var i=0; i<16; ++i)
        m.data[i] = this.data[i];
    return m;
}

mat4.prototype.transposed = function()
{
    var d = this.data;
    var m = new mat4();
    m.data = [d[0], d[4], d[ 8], d[12],
              d[1], d[5], d[ 9], d[13],
              d[2], d[6], d[10], d[14],
              d[3], d[7], d[11], d[15]];
    return m;
}

mat4.prototype.toString = function() {
    return "mat4(" + this.data + ")";
}

// Implements M = M x A, changes this to new value of M
// mat4 A - The input matrix to multiply with (from right)
//
mat4.prototype.multiply = function(A) {
    var nd = [];
    nd.length = 16;

    var a = this.data;
    var b = A.data;

    nd[ 0] = a[ 0] * b[0] + a[ 1] * b[4] + a[ 2] * b[ 8] + a[ 3] * b[12];
    nd[ 1] = a[ 0] * b[1] + a[ 1] * b[5] + a[ 2] * b[ 9] + a[ 3] * b[13];
    nd[ 2] = a[ 0] * b[2] + a[ 1] * b[6] + a[ 2] * b[10] + a[ 3] * b[14];
    nd[ 3] = a[ 0] * b[3] + a[ 1] * b[7] + a[ 2] * b[11] + a[ 3] * b[15];

    nd[ 4] = a[ 4] * b[0] + a[ 5] * b[4] + a[ 6] * b[ 8] + a[ 7] * b[12];
    nd[ 5] = a[ 4] * b[1] + a[ 5] * b[5] + a[ 6] * b[ 9] + a[ 7] * b[13];
    nd[ 6] = a[ 4] * b[2] + a[ 5] * b[6] + a[ 6] * b[10] + a[ 7] * b[14];
    nd[ 7] = a[ 4] * b[3] + a[ 5] * b[7] + a[ 6] * b[11] + a[ 7] * b[15];

    nd[ 8] = a[ 8] * b[0] + a[ 9] * b[4] + a[10] * b[ 8] + a[11] * b[12];
    nd[ 9] = a[ 8] * b[1] + a[ 9] * b[5] + a[10] * b[ 9] + a[11] * b[13];
    nd[10] = a[ 8] * b[2] + a[ 9] * b[6] + a[10] * b[10] + a[11] * b[14];
    nd[11] = a[ 8] * b[3] + a[ 9] * b[7] + a[10] * b[11] + a[11] * b[15];

    nd[12] = a[12] * b[0] + a[13] * b[4] + a[14] * b[ 8] + a[15] * b[12];
    nd[13] = a[12] * b[1] + a[13] * b[5] + a[14] * b[ 9] + a[15] * b[13];
    nd[14] = a[12] * b[2] + a[13] * b[6] + a[14] * b[10] + a[15] * b[14];
    nd[15] = a[12] * b[3] + a[13] * b[7] + a[14] * b[11] + a[15] * b[15];

    this.data = nd;
    return this;
}

mat4.prototype.multiplyFromLeft = function(A)
{
    var m = new mat4();
    m.multiply(A);
    m.multiply(this);
    this.data = m.data;
    return this;
}

mat4.prototype.scale = function(sx, sy, sz) {
    var M = new mat4();
    M.data = [sx, 0, 0, 0,
              0, sy, 0, 0,
              0, 0, sz, 0,
              0, 0, 0, 1];
    return this.multiply(M);
}

mat4.prototype.rotateAroundX = function(angle) {
    var M = new mat4();
    var s = Math.sin(angle);
    var c = Math.cos(angle);
    M.data = [1, 0, 0, 0,
              0, c, -s, 0,
              0, s, c, 0,
              0, 0, 0, 1];
    return this.multiply(M);
}

mat4.prototype.rotateAroundY = function(angle) {
    var M = new mat4();
    var s = Math.sin(angle);
    var c = Math.cos(angle);
    M.data = [c, 0, s, 0,
              0, 1, 0, 0,
              -s, 0, c, 0,
              0, 0, 0, 1];
    return this.multiply(M);
}

mat4.prototype.rotateAroundZ = function(angle) {
    var M = new mat4();
    var s = Math.sin(angle);
    var c = Math.cos(angle);
    M.data = [c, -s, 0, 0,
              s, c, 0, 0,
              0, 0, 1, 0,
              0, 0, 0, 1];
    return this.multiply(M);
}

mat4.prototype.translate = function(dx, dy, dz) {
    var M = new mat4();
    M.data = [1, 0, 0, dx,
              0, 1, 0, dy,
              0, 0, 1, dz,
              0, 0, 0, 1];
    return this.multiply(M);
}

// Implements Mv = v'
// vec4 v - an input vector.
// return: v'
//
mat4.prototype.map = function(v)
{
    var d = this.data;
    var x = d[ 0] * v.x + d[ 1] * v.y + d[ 2] * v.z + d[ 3] * v.w;
    var y = d[ 4] * v.x + d[ 5] * v.y + d[ 6] * v.z + d[ 7] * v.w;
    var z = d[ 8] * v.x + d[ 9] * v.y + d[10] * v.z + d[11] * v.w;
    var w = d[12] * v.x + d[13] * v.y + d[14] * v.z + d[15] * v.w;
    return new vec4(x, y, z, w);
}
