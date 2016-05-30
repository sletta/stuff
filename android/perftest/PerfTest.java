package org.sletta.perftest;

import android.animation.ValueAnimator;
import android.content.Context;
import android.net.Uri;
import android.opengl.*;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.animation.AnimationUtils;
import android.view.animation.Interpolator;

import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import java.util.List;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

public class MainActivity extends AppCompatActivity {

    private GLSurfaceView m_view;
    private GLSurfaceView.Renderer m_renderer;

    private int m_frameCounter = 0;
    private int m_program;

    private ValueAnimator m_animator;
    private int m_animationPos;

    private long m_prevAnimationTime = 0;
    private long m_lastDrawTime = 0;
    private long m_timeOfLastTick = 0;

    private List<Integer> m_animDeltas = new ArrayList<Integer>();
    private List<Integer> m_frameDeltas = new ArrayList<Integer>();
    private List<Integer> m_animToFrameDelta = new ArrayList<Integer>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        m_renderer = new GLSurfaceView.Renderer() {
            public void onSurfaceCreated(GL10 unused, EGLConfig config) { init(); }
            public void onDrawFrame(GL10 unused) { render(); }
            public void onSurfaceChanged(GL10 unused, int width, int height) {  }
        };

        m_view = new GLSurfaceView(this);
        m_view.setEGLContextClientVersion(2);
        m_view.setRenderer(m_renderer);
        setContentView(m_view);

        m_animator = new ValueAnimator();
        m_animator.setRepeatCount(ValueAnimator.INFINITE);
        m_animator.setIntValues(0, 600);
        m_animator.setDuration(2000);
        m_animator.setInterpolator(new Interpolator() {
            public float getInterpolation(float input) { return input; }
        });
        m_animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                m_animationPos = (Integer) animation.getAnimatedValue();

                long time = AnimationUtils.currentAnimationTimeMillis();
                int delta = (int) (time - m_prevAnimationTime);
                if (delta > 18 || delta < 14)
                    Log.i("PerfTest", " -- Bad animation frame, last=" + m_prevAnimationTime + ", current=" + time + ", delta=" + delta);
                m_prevAnimationTime = time;

                synchronized (m_animDeltas) {
                    m_animDeltas.add(delta);
                    if (m_animDeltas.size() > 60)
                        m_animDeltas.remove(0);
                    m_timeOfLastTick = System.currentTimeMillis();
                }
            }
        });
        m_animator.start();
    }

    private int createShader(int type, String code) {
        int shader = GLES20.glCreateShader(type);
        GLES20.glShaderSource(shader, code);
        GLES20.glCompileShader(shader);
        int[] compiled = new int[1];
        GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, compiled, 0);
        if (compiled[0] == 0)
            throw new RuntimeException("Compile error: " + type + ", " + GLES20.glGetShaderInfoLog(shader));
        return shader;
    }

    private int createProgram(String vertexShader, String fragmentShader, String attributes[]) {
        int program = GLES20.glCreateProgram();
        GLES20.glAttachShader(program, createShader(GLES20.GL_VERTEX_SHADER, vertexShader));
        GLES20.glAttachShader(program, createShader(GLES20.GL_FRAGMENT_SHADER, fragmentShader));
        for (int i = 0; i < attributes.length; ++i)
            GLES20.glBindAttribLocation(program, i, attributes[i]);
        GLES20.glLinkProgram(program);
        int[] linkStatus = new int[1];
        GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, linkStatus, 0);
        if (linkStatus[0] == 0) {
            throw new RuntimeException("Link error: " + GLES20.glGetProgramInfoLog(program));
        }
        return program;
    }

    private void init() {
        m_program = createProgram(

            "\n attribute highp vec4 aV;"
          + "\n void main() {"
          + "\n     gl_Position = aV;"
          + "\n }",

            "\n uniform lowp vec4 color;"
          + "\n void main() {"
          + "\n     gl_FragColor = color;"
          + "\n }",

                new String[]{"aV"});

        System.out.println("Created shader program: " + m_program);
    }

    private void checkGLError()
    {
        int error = 0;
        while ((error = GLES20.glGetError()) != GLES20.GL_NO_ERROR) {
            throw new RuntimeException("OpenGL Error, code=0x" + String.format("%x", error));
        }
    }

    private void render() {
        long time = System.currentTimeMillis();
        int delta = (int) (time - m_lastDrawTime);
        m_frameDeltas.add(delta);
        if (m_frameDeltas.size() > 60)
            m_frameDeltas.remove(0);
        m_lastDrawTime = time;

        ++m_frameCounter;
        GLES20.glViewport(0, 0, m_view.getWidth(), m_view.getHeight());
        checkGLError();
        GLES20.glClearColor(0, 0, 0, 1);
        checkGLError();
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
        checkGLError();

        // Draw something
        GLES20.glUseProgram(m_program);
        checkGLError();
        GLES20.glEnableVertexAttribArray(0);
        checkGLError();

        float barHeight = 80;
        float barWidth = 10;
        // Red one using pixed increments, 5 pixels per frame, approx 300 pixels/sec
        drawRect((m_frameCounter * 5) % (m_view.getWidth() - barWidth), 100, barWidth, barHeight, 1, 0, 0, 1);

        // Green one using current time at 300 pixels / second
        float timePos = ((time * 300 + 500) / 1000) % (m_view.getWidth() - (int) barWidth);

        drawRect(timePos, 200, barWidth, barHeight, 0, 1, 0, 1);

        drawRect(m_animationPos, 300, 10, barHeight, 0, 0, 1, 1);

        float boxHeight = 100;
        float c = m_frameCounter % 2;
        drawRect(0, m_view.getHeight() - boxHeight, m_view.getWidth(), boxHeight, c, 1.0f - c, 0, 1);

        synchronized (m_animDeltas) {
            drawList(0, 400, m_animDeltas, 0, 1, 1);

            int tickDelta = (int)(System.currentTimeMillis() - m_timeOfLastTick);
            m_animToFrameDelta.add(tickDelta);
            if (m_animToFrameDelta.size() > 60)
                m_animToFrameDelta.remove(0);
            drawList(150, 400, m_animToFrameDelta, 1, 0, 1);
        }
        drawList(300, 400, m_frameDeltas, 1, 1, 0);

        GLES20.glDisableVertexAttribArray(0);
        checkGLError();
        GLES20.glUseProgram(0);
        checkGLError();
    }

    private void drawList(int x, int y, List<Integer> list, float r, float g, float b) {
        int w = 2;
        int h = 2;
        for (int i = 0; i < list.size(); ++i) {
            int value = list.get(i);
            float lr = r;
            float lg = g;
            float lb = b;
            if (value > 17) {
                lr = 1;
                lg = 0;
                lb = 0;
            }
            drawRect(x + i * w, y, w, value * h, lr, lg, lb, 1);
        }

    }

    private float mapX(float x) { return (x / m_view.getWidth()) * 2.0f - 1.0f; }
    private float mapY(float y) { return 1.0f - (y / m_view.getHeight()) * 2.0f; }

    private void drawRect(float x, float y, float w, float h, float r, float g, float b, float a)
    {
        // buffer..
        float floats[] = new float[8];
        floats[0] = mapX(x);
        floats[1] = mapY(y);
        floats[2] = mapX(x + w);
        floats[3] = mapY(y);
        floats[4] = mapX(x);
        floats[5] = mapY(y + h);
        floats[6] = mapX(x + w);
        floats[7] = mapY(y + h);
        ByteBuffer buffer = ByteBuffer.allocateDirect(4 * 8);
        buffer.order(ByteOrder.nativeOrder());
        FloatBuffer floatBuffer = buffer.asFloatBuffer();
        floatBuffer.put(floats);
        floatBuffer.position(0);
        GLES20.glVertexAttribPointer(0, 2, GLES20.GL_FLOAT, false, 8, floatBuffer);
        checkGLError();

        GLES20.glUniform4f(0, r, g, b, a);
        checkGLError();

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4);
        checkGLError();

    }
}
