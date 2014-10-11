attribute highp vec4 v;
attribute highp vec2 t;

uniform highp mat4 qt_Matrix;

varying highp vec2 tc;

void main()
{
    gl_Position = qt_Matrix * v;
    tc = t;
}
