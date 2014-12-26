varying vec2 qt_TexCoord0;
uniform vec2 resolution;
uniform mat4 matrix;
uniform mat4 cubeMatrix;
uniform sampler2D skymap;
uniform float tSlow;
uniform float tFast;

uniform sampler2D normals;
uniform sampler2D materials;

uniform sampler2D noise;

const float PI = 3.141592;
const float PIHalf = PI * 0.5;
const float PIx2 = PI * 2.0;
const float FIELD_OF_VIEW = 90.0;
const float FOV = (FIELD_OF_VIEW / 360.0) * PI;
const float INF = 1.0e30;

const float SKYMAP_DISTANCE = 1000.0;
const vec3 SKYLIGHT = vec3(SKYMAP_DISTANCE * 0.44, SKYMAP_DISTANCE, -0.58 * SKYMAP_DISTANCE);
//const vec3 SKYLIGHT = vec3(-100, 100, -100);

const vec4 SPHERE_MATERIAL = vec4(0.05, 0.5, 0.5, 0.0);
const vec4 WATER_MATERIAL = vec4(0.0, 0.5, 0.5, 0.0);
const vec4 SKYBOX_MATERIAL = vec4(1.0, 0.0, 0.0, 1.0);

const vec3 GLOW_COLOR = vec3(0.2, 0.3, 0.8);


struct Ray {
    vec3 origin;
    vec3 direction;
    float weight;
};

struct Sphere {
    vec3 center;
    float radius;
};

struct Intersection {
    float t;
    float tt;
    vec3 pos; // hit point
    vec3 normal; // normal at hit point
    vec3 color;
    vec4 type;  // x: ambient, y: diffuse, z: reflect, w: end-of-the-world...
};

void hitSphere(Sphere s, Ray ray, inout Intersection i);

float blueGlow()
{
    return max(0.0, 8.0 * pow(sin(tSlow * PIx2), 16.0));
}

float intersectPlane(vec3 n, vec3 p0, vec3 l, vec3 l0)
{
    float denom = dot(n, l);
    return dot((p0 - l0), n) / denom;
}


void hitCubeSide(Ray r, vec3 p0, vec3 p1, vec3 p2, inout Intersection i)
{
    vec3 pv1 = p1 - p0;
    vec3 pv2 = p2 - p0;
    vec3 n = normalize(cross(pv1, pv2));

//    if (dot(n, r.direction) < 0.0)
//        return;

    float t = dot((p0 - r.origin), n) / dot(n, r.direction);
    if (t < 0.001 || t > i.t)
        return;

    /*

      L                 -> the line, given by L2 - L1
      P                 -> the point
      P'                -> the point projected on L

      P' = t * L
      (P - P') dot L = 0
      (P - tL) dot L = 0
      P dot L - t L dot L = 0;
      t = P dot L / L dot L


      */

//    if (t < i.t) {
//        i.color = vec3(0, t / 20.0, 1);
//        i.type = vec4(1, 0, 0, 0);
//        i.pos = r.direction * t + r.origin;
//        i.normal = vec3(0, 0, 0);
//        i.t = t;
//        return;
//    }

    vec3 pos = r.origin + r.direction * t; // position in world coords
    vec3 rPos = pos - p0; //  position relative to this plane anchored at p0

    float t1 = dot(rPos, pv1) / dot(pv1, pv1);
    float t2 = dot(rPos, pv2) / dot(pv2, pv2);

    if (t1 > 0.0 && t1 < 1.0 && t2 > 0.0 && t2 < 1.0) {
        vec2 tc = vec2(1.0 - t1, t2);

        vec2 ref = texture2D(materials, tc).xz;
        float glow = ref.x * blueGlow();
        vec3 npv1 = normalize(pv1);
        vec3 npv2 = normalize(pv2);
        mat3 tmat = mat3(npv1, -npv2, n);
        vec3 localNormal = tmat * normalize(texture2D(normals, tc).xyz * 2.0 - 1.0);
        float l = pow(dot(r.direction, localNormal), 8.0);
        i.color = glow * GLOW_COLOR + vec3(l);
        i.t = t;
        i.normal = localNormal;
        i.type = vec4(l + ref.x * glow, 0, 0. + ref.y * 0.5, 0);
        i.pos = pos;
    }
}

void hitCube(Ray r, inout Intersection i)
{
    /*

          011 +--------+ 111
            / |      / |
          /   |    /   |
    010 +--------+ 110 |
        | 001 +--|-----+ 101
        |   /    |   /
        | /      | /
        +--------+
    000           100

   */


    mat4 m = mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1); //
    m = cubeMatrix;
    m = m * 2.0;
    vec3 p000 = vec4(m * vec4(0, 0, 0, 1)).xyz;
    vec3 p001 = vec4(m * vec4(0, 0, 1, 1)).xyz;
    vec3 p010 = vec4(m * vec4(0, 1, 0, 1)).xyz;
    vec3 p011 = vec4(m * vec4(0, 1, 1, 1)).xyz;
    vec3 p100 = vec4(m * vec4(1, 0, 0, 1)).xyz;
    vec3 p101 = vec4(m * vec4(1, 0, 1, 1)).xyz;
    vec3 p110 = vec4(m * vec4(1, 1, 0, 1)).xyz;
    vec3 p111 = vec4(m * vec4(1, 1, 1, 1)).xyz;

    hitCubeSide(r, p001, p011, p101, i);
    hitCubeSide(r, p101, p111, p100, i);
    hitCubeSide(r, p100, p110, p000, i);
    hitCubeSide(r, p000, p010, p001, i);
    hitCubeSide(r, p000, p001, p100, i); // bottom
    hitCubeSide(r, p011, p010, p111, i); // top

#if 0
    vec3 s[8];
    s[0] = p000;
    s[1] = p001;
    s[2] = p010;
    s[3] = p011;
    s[4] = p100;
    s[5] = p101;
    s[6] = p110;
    s[7] = p111;
    for (int j=0; j<8; ++j) {
        Sphere sphere;
        sphere.radius = 0.1;
        sphere.center = s[j];
        bool was = i.type.z > 0.0;
        hitSphere(sphere, r, i);
        if (i.type.z > 0.0 && !was) {
            i.color = s[j];
            i.type = vec4(1, 0, 0, 0);
        }
    }
#endif
}


void hitGradientSkymap(Ray r, inout Intersection i)
{
    if (i.t < SKYMAP_DISTANCE)
        return;

    i.t = SKYMAP_DISTANCE;

    vec3 nearGround = vec3(0.7, 0.8, 0.9);
    vec3 highUp = vec3(0.2, 0.3, 0.6);

    i.color = mix(nearGround, highUp, r.direction.y);
    i.type = SKYBOX_MATERIAL;
    i.normal = r.direction;
    return;
}

void hitSkymap(Ray r, inout Intersection i)
{
    const vec2 subtex = vec2(1.0/4.0, 1.0/3.0);

    vec3 b1 = vec3(-SKYMAP_DISTANCE, -SKYMAP_DISTANCE, -SKYMAP_DISTANCE);
    vec3 b2 = vec3(SKYMAP_DISTANCE, SKYMAP_DISTANCE, SKYMAP_DISTANCE);

    vec3 t1 = (b1 - r.origin) / r.direction;
    vec3 t2 = (b2 - r.origin) / r.direction;

    vec2 front  = vec2( 1, -1) * (r.origin + r.direction * t1.z).xy / (2.0 * SKYMAP_DISTANCE) + 0.5;
    vec2 left   = vec2(-1, -1) * (r.origin + r.direction * t1.x).zy / (2.0 * SKYMAP_DISTANCE) + 0.5;
    vec2 top    = vec2( 1, -1) * (r.origin + r.direction * t2.y).xz / (2.0 * SKYMAP_DISTANCE) + 0.5;
    vec2 right  = vec2( 1, -1) * (r.origin + r.direction * t2.x).zy / (2.0 * SKYMAP_DISTANCE) + 0.5;
    vec2 back   = vec2(-1, -1) * (r.origin + r.direction * t2.z).xy / (2.0 * SKYMAP_DISTANCE) + 0.5;

    float t = INF;
    vec3 color;
    if (t1.z >= 0.0 && front.x >= 0.0 && front.x <= 1.0 && front.y >= 0.0 && front.y <= 1.0) {
        t = t1.z;
        color = texture2D(skymap, (vec2(1, 1) + front) * subtex).xyz;
    } else if (t1.x >= 0.0 && left.x >= 0.0 && left.x <= 1.0 && left.y >= 0.0 && left.y <= 1.0) {
        t = t1.x;
        color = texture2D(skymap, (vec2(0, 1) + left) * subtex).xyz;
    } else if (t2.y >= 0.0 && top.x >= 0.0 && top.x <= 1.0 && top.y >= 0.0 && top.y <= 1.0) {
        t = t2.y;
        color = texture2D(skymap, (vec2(1, 0) + top) * subtex).xyz;
    } else if (t2.x >= 0.0 && right.x >= 0.0 && right.x <= 1.0 && right.y >= 0.0 && right.y <= 1.0) {
        t = t2.x;
        color = texture2D(skymap, (vec2(2, 1) + right) * subtex).xyz;
    } else if (t2.z >= 0.0 && back.x >= 0.0 && back.x <= 1.0 && back.y >= 0.0 && back.y <= 1.0) {
        t = t2.z;
        color = texture2D(skymap, (vec2(3, 1) + back) * subtex).xyz;
    }

    if (t < i.t) {
        i.t = t;
        i.color = color;
        i.normal = vec3(0, 0, 0);
        i.pos = r.origin + r.direction * t;
        i.type = vec4(1, 0, 0, 1);
    }
}

vec2 noise( vec2 p ) {

    float v = 0.0;          

    float time = tSlow;
    vec2 tv = vec2( time, time );

    v += texture2D(noise, (p + tv) / 32.0 ).x;
    v += texture2D(noise, (p - tv) / 32.0 ).y;
    v += texture2D(noise, (-p + tv.yx) / 16.0 ).z;
    v += texture2D(noise, (-p.yx - tv.yx) / 16.0 ).x;

    const float sp = 1.0;
    const float sr = 1.0;
    v = smoothstep( sp, sp + sr, v );
    v = v - smoothstep( 0.5, 1.0, v );

    time = tSlow;
    float w1 = 0.5 * sin( dot(p, vec2(0.2, 0.2)) * PIx2 + time * PIx2 ) + 0.5;
    float w2 = 0.5 * sin( dot(p, vec2(0.2, 0.2)) * PIx2 * 2.0 + time * PIx2) + 0.5;
    float w3 = 0.5 * sin( dot(p, vec2(0.2, 0.2)) * PIx2 * 4.0 + time * PIx2) + 0.5;
    float w4 = 0.5 * sin( dot(p, vec2(0.2, 0.2)) * PIx2 * 8.0 + time * PIx2) + 0.5;

    float w = dot(vec4(w1, w2, w3, w4), vec4(0.9, 0.05, 0.025, 0.025));

    return smoothstep(0.0, 1.0, vec2(w, v));
}


float waterElevation(vec2 p)
{
    // float a = tSlow * PIx2;
    // float b = tFast * PIx2;
    // return  0.02 + 0.005 * sin(length(p.xy) * 4.0 + a - b)
    //         + 0.005 * sin(a * 2.0 + p.x * 4.0);
    return 0.1 * dot( noise( p ), vec2( 0.8, 0.03 ) );
}

void hitWater(Ray r, inout Intersection i)
{
    vec3 pnormal = vec3(0, 1, 0);
    if (dot(pnormal, r.direction) > 0.0)
        return;
    vec3 porigin = vec3(0, -0.5, 0);
    float t = dot((porigin - r.origin), pnormal) / dot(pnormal, r.direction);
    if (t > 0.001 && t < i.t) {
        vec3 p = r.origin + r.direction * t;

        const float D = 0.1;
        vec3 p0 = vec3(p.x, waterElevation(p.xz), p.z);
        vec3 p1 = vec3(p.x + D, waterElevation(p.xz + vec2(D, 0)), p.z);
        vec3 p2 = vec3(p.x, waterElevation(p.xz + vec2(0, D)), p.z + D);

        i.pos = p0;
        i.normal = normalize(cross(p2 - p0, p1 - p0));

        i.t = t;
        i.color = vec3(0.4, 0.5, 0.7) + p0.y * 1.0;
        i.type = WATER_MATERIAL;
    }
}

void hitSphere(Sphere s,  Ray ray, inout Intersection i)
{
    vec3 L = s.center - ray.origin;
    float tca = dot(L, ray.direction);
    if (tca > 0.0) {
        float d = sqrt(dot(L, L) - tca * tca);
        float thc = sqrt(s.radius * s.radius - d * d);
        if (d > 0.0 && d < s.radius && (tca - thc < i.t)) {
            i.color = vec3(1, 1, 1);
            i.t = tca - thc;
            i.pos = ray.origin + ray.direction * i.t;
            i.normal = normalize(i.pos - s.center);
            i.type = SPHERE_MATERIAL;
        }
    }
}

void hitSpheres(Ray r, inout Intersection i)
{
    float a = tSlow * PIx2;
    for (int j=0; j<4; ++j) {
        Sphere s;
        s.center = vec3(cos(a) * 3.0, 1.5, sin(a) * 3.0);
        s.radius = 0.66;
        hitSphere(s, r, i);
        a += PIHalf;
    }
}

float calculateLight(Intersection i)
{
    return max(0.0, dot(i.normal, normalize(SKYLIGHT)));
}

void shootRay(Ray r, inout Intersection i)
{
    hitSkymap(r, i);
    hitSpheres(r, i);
    hitCube(r, i);
    hitWater(r, i);
}

void applyColorFromHit(inout vec3 color, Ray r, Intersection i)
{
    color += r.weight * i.type.x * i.color;
    if (i.type.y > 0.0) {
        Ray lightRay;
        lightRay.direction = normalize(SKYLIGHT - i.pos);
        lightRay.origin = i.pos;
        Intersection li;
        li.type = vec4(0, 0, 0, 0);
        li.t = INF;
        shootRay(lightRay, li);
        if (li.type.w > 0.0 && i.type.y > 0.0)
            color += r.weight * i.type.y * i.color * vec3(calculateLight(i));
    }
}

void main()
{
    float aspectRatio = resolution.x / resolution.y;
    vec3 camRayIsect = vec3((qt_TexCoord0.x * 2.0 - 1.0) * FOV * aspectRatio,
                          (1.0 - qt_TexCoord0.y * 2.0) * FOV,
                          -1);
    vec3 camRayOrig = vec3(0, 0, 0);

    vec3 rayDir = vec4(matrix * vec4(camRayIsect, 1)).xyz;
    vec3 rayOrig = vec4(matrix * vec4(camRayOrig, 1)).xyz;

    Ray r;
    r.origin = rayOrig;
    r.direction = normalize(rayDir - rayOrig);
    r.weight = 1.0;

    Intersection i;
    i.tt = 0.0;
    vec3 color = vec3(0, 0, 0);

    int iterations = 8;
    while (--iterations >= 0) { 
        i.t = INF;
        i.type = vec4(0, 0, 0, 0);
        i.color = vec3(0, 0, 0);

        shootRay(r, i);
        applyColorFromHit(color, r, i);

        if (i.type.w > 0.0)
            iterations = 0;

        if (i.type.z > 0.0) {
            Ray sray;
            sray.weight = r.weight * i.type.z;
            sray.origin = i.pos;
            sray.direction = reflect(r.direction, i.normal);
            r = sray;
            i.tt += i.t;
        } else {
            iterations = 0;
        }
    }

    if (true) {
        vec3 fog = vec3(0.1, 0.1, 0.12);
        float fogAmount = 1.0 - i.pos.y / SKYMAP_DISTANCE;

//        float fogAmount = clamp(max(i.tt / 50.0, fogMax), 0.0, 1.0);
        color = mix(color, fog, fogAmount * 0.5);
    }

    if (true) {
        vec3 skylight = normalize(SKYLIGHT - r.origin);
        float ii = pow(max(0.0, dot(skylight, r.direction)), 40.0);
        color += vec3(1.0, 0.7, 0.2) * ii;
    }


    gl_FragColor = vec4(color, 1);
}
