
float noise(float x) {
	float xx = fract(x) * 256.0;
	float x1 = floor(xx);
	float x2 = x1 + 1.0;
	return mix(NOISE[int(x1)], NOISE[int(mod(x2, 256))], xx-x1) / 255.0;
}

float noise(vec2 pt) {
	vec2 p = fract(pt) * 256.0;
	vec2 p1 = floor(p);

    int ip2y = int(mod(p1.y+1.0, 256.0));

    float p11 = NOISE[ int( mod( p1.x + NOISE[ int(p1.y) ], 256.0) ) ];
    float p12 = NOISE[ int( mod( p1.x + NOISE[ip2y], 256.0) ) ];
    float p21 = NOISE[ int( mod( p1.x + 1.0 + NOISE[ int(p1.y) ], 256.0) ) ];
    float p22 = NOISE[ int( mod( p1.x + 1.0 + NOISE[ip2y], 256.0) ) ];

    float p11_21 = mix( p11, p21, p.x - p1.x );
    float p12_22 = mix( p12, p22, p.x - p1.x );

    return mix( p11_21, p12_22, p.y - p1.y ) / 256.0;
}

float smoothNoise(vec2 pt) { return smoothstep(0.0, 1.0, noise(pt)); }
float smoothNoise(float pt) { return smoothstep(0.0, 1.0, noise(pt)); }
