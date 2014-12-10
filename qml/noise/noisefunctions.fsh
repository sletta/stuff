
float interpolate(float a, float b, float t) {
    return mix( a, b, (3.0 - 2.0 * t) * t * t );
}

float noise(vec2 pt) {
	vec2 p1 = floor(pt);
    vec2 p2 = mod(p1 + 1.0, 256.0);

    int ip2y = int(p2.y);

    int ip11 = P[ int( mod( p1.x + P[ int(p1.y) ], 256.0) ) ];
    int ip12 = P[ int( mod( p1.x + P[ip2y], 256.0) ) ];
    int ip21 = P[ int( mod( p1.x + 1.0 + P[ int(p1.y) ], 256.0) ) ];
    int ip22 = P[ int( mod( p1.x + 1.0 + P[ip2y], 256.0) ) ];

    float p11 = dot(pt - p1, G2[ip11]);
    float p21 = dot(pt - vec2(p1.x+1.0, p1.y), G2[ip21]);
    float p12 = dot(pt - vec2(p1.x, p1.y+1.0), G2[ip12]);
    float p22 = dot(pt - p2, G2[ip22]);

    float p11_21 = interpolate( p11, p21, pt.x - p1.x );
    float p12_22 = interpolate( p12, p22, pt.x - p1.x );

    return interpolate(p11_21, p12_22, pt.y - p1.y);
}
