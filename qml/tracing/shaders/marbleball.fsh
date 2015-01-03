// USE_NOISE

uniform mat4 matrix;
uniform vec2 resolution;

varying vec2 qt_TexCoord0;

const float PI = 3.141592;
const float PIHalf = PI * 0.5;
const float PIx2 = PI * 2.0;
const float FIELD_OF_VIEW = 90.0;
const float FOV = (FIELD_OF_VIEW / 360.0) * PI;
const float INF = 1.0e30;

struct Ray {
    vec3 origin;
    vec3 direction;
};

struct Sphere {
    vec3 center;
    float radius;
};

struct Intersection { 
    float t;
    vec3 pos;
    vec3 normal;
    int type; 
};

void hitSphere(Sphere s,  Ray ray, inout Intersection i)
{
    vec3 L = s.center - ray.origin;
    float tca = dot(L, ray.direction);
    if (tca > 0.0) {
        float d = sqrt(dot(L, L) - tca * tca);
        float thc = sqrt(s.radius * s.radius - d * d);
        if (d > 0.0 && d < s.radius && (tca - thc < i.t)) {
            i.t = tca - thc;
            i.pos = ray.origin + ray.direction * i.t;
            i.normal = normalize(i.pos - s.center);
            i.type = 1;
        }
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

    Ray ray;
    ray.origin = rayOrig;
    ray.direction = normalize(rayDir - rayOrig);

    Intersection isect;
    isect.type = 0;
    isect.t = INF;

    Sphere sphere;
    sphere.center = vec3(0, 0, 0);
    sphere.radius = 1.0;

    hitSphere(sphere, ray, isect);

    if (isect.type > 0) {
        float n = 0.0;
        vec3 pos = isect.pos;
        for (float l=1.0; l<8.0; ++l) {
            float p = pow(2.0, l);
            n += abs(1.0/p * noise(pos * p));
        }

        vec3 color = vec3(1.0, 0.9, 0.8) * abs(sin(isect.pos.x * 4.0 + n * 8.0));

        vec3 light = normalize(vec3(1.0, 1.0, 4.0));

        float diffuse = max(0, dot(light, isect.normal));
        float specular = 0.0;
        if (dot(light, isect.normal) > 0.0) {
            vec3 reflected = reflect(light, isect.normal);
            float dotted = dot(reflected, ray.direction);
            // color = vec3(dotted);
            specular = pow(max(0.0, dotted), 30);
        }

        gl_FragColor = vec4((0.1 + diffuse) * color + specular, 1.0);

    } else
        gl_FragColor = vec4(0, 0, 0, 1);

}