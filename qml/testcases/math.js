.pragma library



function vec2(x, y) {
    this.x = x
    this.y = y
}
vec2.prototype.toString = function() {
    return "vec2(" + this.x + "," + this.y + ")"
}
vec2.prototype.subtract = function(v) {
    return new vec2(this.x - v.x,
                    this.y - v.y)
}
vec2.prototype.add = function(v) {
    return new vec2(this.x + v.x,
                    this.y + v.y)
}


function mat2(m11, m12, m21, m22) {
    this.m11 = m11
    this.m12 = m12
    this.m21 = m21
    this.m22 = m22
}

mat2.prototype.toString = function() {
    return "mat2(" + this.m11 + "," + this.m12 + " / " + this.m21 + "," + this.m22 + ")"
}

mat2.prototype.multiplyVector = function(v) {
    return new vec2(this.m11 * v.x + this.m12 * v.y,
                    this.m21 * v.x + this.m22 * v.y)
}

mat2.prototype.multiply = function(M) {
    return new mat2(this.m11 * M.m11 + this.m12 * M.m21,
                    this.m11 * M.m12 + this.m12 * M.m22,
                    this.m21 * M.m11 + this.m22 * M.m21,
                    this.m21 * M.m12 + this.m22 * M.m22)
}

mat2.prototype.transpose = function() {
    return new mat2(this.m11, this.m21,
                    this.m12, this.m22)
}

mat2.prototype.add = function(M) {
    return new mat2(this.m11 + M.m11, this.m12 + M.m12,
                    this.m21 + M.m21, this.m22 + M.m22)
}

mat2.prototype.subtract = function(M) {
    return new mat2(this.m11 - M.m11, this.m12 - M.m12,
                    this.m21 - M.m21, this.m22 - M.m22)
}

mat2.prototype.invert = function() {
    var d = 1 / (this.m11 * this.m22 - this.m12 * this.m21)
    return new mat2( this.m22 * d, -this.m12 * d,
                    -this.m21 * d,  this.m11 * d)
}

// var A = new mat2(1, 2, 3, 4)
// print("A=" + A)

// print("A^T=" + A.transpose())
// print("A^-1=" + A.invert())
// print("A*A^-1=" + A.multiply(A.invert()))
// print("A+A=" + A.add(A))
// print("A-A=" + A.subtract(A))
// print("A*A=" + A.multiply(A))
