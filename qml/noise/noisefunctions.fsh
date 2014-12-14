
float interpolate(float a, float b, float t) {
    float tt = (3.0 - 2.0 * t) * t * t;
    return (1.0 - tt) * a + b * tt;
}

float noise(vec2 pt) {
    float range = float(P.length());
    vec2 p = mod(pt, range);
	vec2 p1 = floor(p);
    vec2 p2 = mod(p1 + 1.0, range);

    int ip2y = int(p2.y);
    int ip1y = int(p1.y);

    int ip11 = P[ int( mod(p1.x + P[ip1y], range) ) ];
    int ip12 = P[ int( mod(p1.x + P[ip2y], range) ) ];
    int ip21 = P[ int( mod(p2.x + P[ip1y], range) ) ];
    int ip22 = P[ int( mod(p2.x + P[ip2y], range) ) ];

    float p11 = dot(p - p1, G2[ip11]);
    float p21 = dot(p - vec2(p1.x+1.0, p1.y), G2[ip21]);
    float p12 = dot(p - vec2(p1.x, p1.y+1.0), G2[ip12]);
    float p22 = dot(p - (p1 + vec2(1, 1)), G2[ip22]);

    float p11_21 = interpolate( p11, p21, p.x - p1.x );
    float p12_22 = interpolate( p12, p22, p.x - p1.x );

    return interpolate(p11_21, p12_22, p.y - p1.y);
}

float noise(vec3 pt) {

    float range = float(P.length());
    vec3 p = mod(pt, range);
    vec3 p1 = floor(p);
    vec3 p2 = mod(p1 + 1.0, range);

    int ip1y = int(p1.y);
    int ip2y = int(p2.y);
    int ip1z = int(p1.z);
    int ip2z = int(p2.z);

    float pz1, pz2;
    {
        int ipy1z1 = P[ int(mod(ip1y + P[ip1z], range)) ];
        int ipy2z1 = P[ int(mod(ip2y + P[ip1z], range)) ];
        int ip111 = P[ int( mod(p1.x + ipy1z1, range) ) ];
        int ip121 = P[ int( mod(p1.x + ipy2z1, range) ) ];
        int ip211 = P[ int( mod(p2.x + ipy1z1, range) ) ];
        int ip221 = P[ int( mod(p2.x + ipy2z1, range) ) ];
        float p111 = dot(p - p1, G3[ip111]);
        float p211 = dot(p - (p1+vec3(1,0,0)), G3[ip211]);
        float p121 = dot(p - (p1+vec3(0,1,0)), G3[ip121]);
        float p221 = dot(p - (p1+vec3(1,1,0)), G3[ip221]);
        float p111_211 = interpolate(p111, p211, p.x - p1.x);
        float p121_221 = interpolate(p121, p221, p.x - p1.x);
        pz1 = interpolate(p111_211, p121_221, p.y - p1.y);
    }

    {
        int ipy1z2 = P[ int(mod(ip1y + P[ip2z], range)) ];
        int ipy2z2 = P[ int(mod(ip2y + P[ip2z], range)) ];
        int ip112 = P[ int( mod(p1.x + ipy1z2, range) ) ];
        int ip122 = P[ int( mod(p1.x + ipy2z2, range) ) ];
        int ip212 = P[ int( mod(p2.x + ipy1z2, range) ) ];
        int ip222 = P[ int( mod(p2.x + ipy2z2, range) ) ];
        float p112 = dot(p - (p1+vec3(0,0,1)), G3[ip112]);
        float p212 = dot(p - (p1+vec3(1,0,1)), G3[ip212]);
        float p122 = dot(p - (p1+vec3(0,1,1)), G3[ip122]);
        float p222 = dot(p - (p1+vec3(1,1,1)), G3[ip222]);
        float p112_212 = interpolate(p112, p212, p.x - p1.x);
        float p122_222 = interpolate(p122, p222, p.x - p1.x);
        pz2 = interpolate(p112_212, p122_222, p.y - p1.y);
    }

    return interpolate(pz1, pz2, p.z - p1.z);


}
