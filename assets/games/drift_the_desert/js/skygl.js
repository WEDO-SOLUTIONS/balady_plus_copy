/* Drift the Desert — WebGL background.

   Everything behind the track is a single fragment shader: sky gradient, sun,
   drifting fBm clouds, two ranges of sandstone mesas, the dune field, heat
   shimmer and the aerial haze that ties them together. It runs on its own
   canvas *behind* the 2D one, which keeps the gameplay layer untouched.

   Three things make this safe to ship in a WebView:
     - it is entirely optional (`DriftSky.start()` returns false and the 2D
       scene keeps drawing its own sky and mesas),
     - it renders at a fraction of the device resolution and is upscaled by
       the compositor, so fill rate stays low on weak GPUs,
     - a lost context disables it permanently and falls back, rather than
       leaving a dead black rectangle behind the game.

   WebGL 1 / GLSL ES 1.00 throughout: WebGL 2 is still not a given in older
   Android system WebViews. */
(function (global) {
  'use strict';

  var VERT = [
    'attribute vec2 aPos;',
    'void main() { gl_Position = vec4(aPos, 0.0, 1.0); }'
  ].join('\n');

  var FRAG = [
    '#ifdef GL_FRAGMENT_PRECISION_HIGH',
    'precision highp float;',
    '#else',
    'precision mediump float;',
    '#endif',

    'uniform vec2  uRes;',      // drawing buffer size, px
    'uniform float uTime;',     // seconds since start
    'uniform float uScroll;',   // world distance travelled, for parallax
    'uniform float uHorizon;',  // horizon line, px from the top
    'uniform float uDusk;',     // 0 = golden hour .. 1 = dusk
    'uniform float uSpeed;',    // 0..1, drives shimmer and haze

    /* ------------------------------------------------------------ noise */

    'float hash(vec2 p) {',
    '  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);',
    '}',

    'float vnoise(vec2 p) {',
    '  vec2 i = floor(p);',
    '  vec2 f = fract(p);',
    '  vec2 u = f * f * (3.0 - 2.0 * f);',
    '  return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),',
    '             mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);',
    '}',

    'float fbm(vec2 p) {',
    '  float a = 0.5, s = 0.0;',
    '  for (int i = 0; i < 4; i++) { s += a * vnoise(p); p *= 2.03; a *= 0.5; }',
    '  return s;',
    '}',

    // Two octaves is enough for the cloud shading term and the sand ripples,
    // and halves the cost of the two most-shaded regions of the frame.
    'float fbm2(vec2 p) {',
    '  return 0.5 * vnoise(p) + 0.25 * vnoise(p * 2.03);',
    '}',

    /* ---------------------------------------------------------- terrain */

    // Height of a range of flat-topped buttes at `x`, in 0..1. Roughly a third
    // of the cells are left empty so the range breaks up into open desert.
    'float skyline(float x, float seed, float scale) {',
    '  float t = x * scale + seed;',
    '  float c = floor(t);',
    '  float f = fract(t);',
    '  float present = step(0.36, hash(vec2(c, seed + 13.0)));',
    '  float h = 0.42 + 0.58 * hash(vec2(c, seed));',
    '  float w = 0.30 + 0.34 * hash(vec2(c, seed + 5.0));',
    '  float d = abs(f - 0.5);',
    '  float body = smoothstep(w + 0.10, w - 0.06, d);',   // plateau with talus
    '  float tilt = 1.0 - 0.10 * (f - 0.5);',              // slight asymmetry
    '  return present * h * body * tilt;',
    '}',

    // Rolling dune crests: a few sines is plenty and costs nothing.
    'float duneCrest(float x, float phase) {',
    '  return sin(x * 0.9 + phase) * 0.55',
    '       + sin(x * 2.27 + phase * 1.7) * 0.26',
    '       + sin(x * 0.37 - phase * 0.6) * 0.48;',
    '}',

    /* -------------------------------------------------------------- sky */

    'vec3 skyColour(float t, float dusk) {',
    '  vec3 zenithDay  = vec3(0.07, 0.20, 0.36);',
    '  vec3 midDay     = vec3(0.39, 0.55, 0.65);',
    '  vec3 lowDay     = vec3(0.99, 0.80, 0.53);',
    '  vec3 zenithDusk = vec3(0.04, 0.05, 0.14);',
    '  vec3 midDusk    = vec3(0.19, 0.14, 0.27);',
    '  vec3 lowDusk    = vec3(0.76, 0.36, 0.26);',
    '  vec3 zenith = mix(zenithDay, zenithDusk, dusk);',
    '  vec3 mid    = mix(midDay,    midDusk,    dusk);',
    '  vec3 low    = mix(lowDay,    lowDusk,    dusk);',
    '  return t < 0.62 ? mix(zenith, mid, smoothstep(0.0, 0.62, t))',
    '                  : mix(mid, low, smoothstep(0.62, 1.0, t));',
    '}',

    /* ------------------------------------------------------------- main */

    'void main() {',
    '  vec2 px = vec2(gl_FragCoord.x, uRes.y - gl_FragCoord.y);',   // y from top
    '  float hz = uHorizon;',
    '  float W = uRes.x;',
    '  float dusk = uDusk;',

    // Everything dissolves into the colour the sky has at the horizon, which
    // is what makes the aerial perspective read as distance rather than fog.
    '  vec3 haze = skyColour(1.0, dusk);',
    '  vec3 sunTint = mix(vec3(1.0, 0.92, 0.75), vec3(1.0, 0.52, 0.33), dusk);',
    '  vec2 sun = vec2(W * 0.68, hz - uRes.y * (0.055 - 0.038 * dusk));',

    // Heat shimmer: a slow wobble that only bites near the horizon and grows
    // with speed.
    '  float nearHz = exp(-abs(px.y - hz) / (uRes.y * 0.10));',
    '  float shimmer = sin(px.y * 0.35 + uTime * 5.0) * sin(px.x * 0.07 - uTime * 1.3);',
    '  float sx = px.x + shimmer * nearHz * (1.4 + uSpeed * 3.0);',

    '  vec3 col;',

    '  if (px.y < hz) {',
    /* ---- above the horizon ------------------------------------------- */
    '    float t = clamp(px.y / hz, 0.0, 1.0);',
    '    col = skyColour(t, dusk);',

    // Clouds, lit from the sun side by a second offset sample.
    '    vec2 cuv = vec2(sx / W * 2.4 - uScroll * 0.00006, px.y / hz * 1.35);',
    '    cuv.x += fbm(cuv * 1.6 + uTime * 0.010) * 0.22;',
    '    float cloud = fbm(cuv * vec2(1.0, 2.4));',
    '    float lit   = fbm2((cuv + vec2(0.07, 0.04)) * vec2(1.0, 2.4)) * 1.35;',
    '    float band  = smoothstep(0.16, 0.50, t) * smoothstep(1.02, 0.80, t);',
    '    float mask  = smoothstep(0.40, 0.63, cloud) * band;',
    '    vec3 cloudCol = mix(vec3(1.00, 0.96, 0.91), vec3(0.50, 0.31, 0.32), dusk);',
    '    cloudCol = mix(cloudCol * 0.58, cloudCol, smoothstep(0.38, 0.66, lit));',
    '    cloudCol += sunTint * exp(-distance(vec2(sx, px.y), sun) / (uRes.y * 0.40)) * 0.45;',
    '    col = mix(col, cloudCol, mask);',

    // Sun: broad bloom, tight core, then the disc. Drawn after the clouds so
    // it burns through their edges.
    '    float d = distance(vec2(sx, px.y), sun) / uRes.y;',
    '    col += sunTint * (0.42 * exp(-d * 6.0) + 0.75 * exp(-d * 26.0));',
    '    col = mix(col, sunTint * 1.3, smoothstep(0.036, 0.028, d));',

    // Far range: heavily hazed, so it sits behind everything.
    '    float far = skyline(sx / W, 3.0, 4.6);',
    '    if (far > 0.001 && px.y > hz - far * uRes.y * 0.075) {',
    '      vec3 rock = mix(vec3(0.55, 0.42, 0.34), vec3(0.20, 0.15, 0.23), dusk);',
    '      col = mix(rock, haze, 0.62);',
    '    }',

    // Near range: parallaxes faster, keeps more of its own colour, and has a
    // lit western face.
    '    float nr = skyline(sx / W + uScroll * 0.00020, 21.0, 3.4);',
    '    if (nr > 0.001 && px.y > hz - nr * uRes.y * 0.055) {',
    '      float face = smoothstep(0.0, 1.0, fract(sx / W * 3.4 + uScroll * 0.00020));',
    '      vec3 rock = mix(vec3(0.46, 0.33, 0.25), vec3(0.15, 0.11, 0.17), dusk);',
    '      vec3 sunny = mix(vec3(0.70, 0.52, 0.36), vec3(0.28, 0.17, 0.20), dusk);',
    '      col = mix(mix(rock, sunny, face), haze, 0.30);',
    '    }',

    // Aerial perspective over the last slice of sky.
    '    col = mix(col, haze, smoothstep(0.80, 1.0, t) * 0.65);',

    '  } else {',
    /* ---- below the horizon ------------------------------------------- */
    '    float depth = (px.y - hz) / max(1.0, uRes.y - hz);',   // 0 horizon .. 1 camera
    '    vec3 farSand  = mix(vec3(0.91, 0.74, 0.50), vec3(0.46, 0.29, 0.30), dusk);',
    '    vec3 nearSand = mix(vec3(0.52, 0.33, 0.17), vec3(0.17, 0.11, 0.12), dusk);',
    '    col = mix(farSand, nearSand, smoothstep(0.0, 0.92, depth));',

    // Three dune ranges marching towards the camera. They are drawn far to
    // near and simply overwrite, so the nearest crest always wins.
    '    for (int i = 0; i < 3; i++) {',
    '      float fi = float(i);',
    '      float band = 0.05 + fi * 0.13;',
    '      float phase = uScroll * (0.00018 + fi * 0.00046) + fi * 2.7;',
    '      float freq = 3.0 - fi * 0.7;',
    '      float crest = duneCrest(sx / W * freq, phase);',
    '      float yLine = hz + (uRes.y - hz) * band + crest * uRes.y * (0.011 + fi * 0.010);',
    '      if (px.y > yLine) {',
    '        float slope = duneCrest((sx + W * 0.035) / W * freq, phase) - crest;',
    '        float near = fi / 2.0;',
    '        vec3 lit   = mix(vec3(0.95, 0.79, 0.55), vec3(0.50, 0.31, 0.30), dusk) * (1.0 - near * 0.30);',
    '        vec3 shade = mix(vec3(0.60, 0.39, 0.22), vec3(0.20, 0.13, 0.15), dusk) * (1.0 - near * 0.28);',
    '        vec3 face = mix(shade, lit, clamp(0.5 - slope * 2.4, 0.0, 1.0));',
    '        col = mix(col, face, 0.88);',
    '        col += lit * smoothstep(uRes.y * 0.012, 0.0, px.y - yLine) * 0.22;',
    '      }',
    '    }',

    // Wind ripples, fading out as the ground approaches the camera.
    '    float ripple = fbm2(vec2(sx / W * 14.0, depth * 26.0 + uScroll * 0.004)) * 1.35;',
    '    col *= 1.0 + (ripple - 0.5) * 0.18 * (1.0 - smoothstep(0.1, 0.7, depth));',

    // Only the first slice of ground is hazed; below that it must read solid.
    '    col = mix(col, haze, (1.0 - smoothstep(0.0, 0.085, depth)) * 0.85);',

    // Dither, so the large flat areas do not band on 8-bit displays.
    '    col += (hash(px * 0.7 + uTime) - 0.5) * 0.02;',
    '  }',

    // Speed vignette.
    '  vec2 q = (px / uRes) - 0.5;',
    '  float vig = 1.0 - dot(q, q) * (0.5 + uSpeed * 0.8);',
    '  col *= clamp(vig, 0.0, 1.0);',

    '  gl_FragColor = vec4(col, 1.0);',
    '}'
  ].join('\n');

  function compile(gl, type, src) {
    var sh = gl.createShader(type);
    gl.shaderSource(sh, src);
    gl.compileShader(sh);
    if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) {
      if (global.console) console.warn('[DriftSky] shader: ' + gl.getShaderInfoLog(sh));
      gl.deleteShader(sh);
      return null;
    }
    return sh;
  }

  var Sky = {
    active: false,
    canvas: null,
    gl: null,
    // Render resolution relative to CSS pixels. The layer is all gradients and
    // noise, so under-rendering is invisible — and it is the only lever that
    // matters on a weak GPU, so the quality ladder walks down it.
    scale: 0.50,
    STEPS: [0.50, 0.36, 0.26],
    _u: {},
    _t0: 0,
    _failed: false,
    _step: 0,
    _frames: 0,
    _acc: 0,

    /** Returns true when the shader background took over. */
    start: function (canvas) {
      if (this._failed) return false;
      this.canvas = canvas;

      var opts = {
        alpha: false,
        antialias: false,
        depth: false,
        stencil: false,
        powerPreference: 'low-power',
        failIfMajorPerformanceCaveat: false,
        preserveDrawingBuffer: false
      };
      var gl = null;
      try {
        gl = canvas.getContext('webgl', opts) || canvas.getContext('experimental-webgl', opts);
      } catch (e) { gl = null; }
      if (!gl) return this.giveUp('no webgl context');

      var vs = compile(gl, gl.VERTEX_SHADER, VERT);
      var fs = compile(gl, gl.FRAGMENT_SHADER, FRAG);
      if (!vs || !fs) return this.giveUp('shader compile failed');

      var prog = gl.createProgram();
      gl.attachShader(prog, vs);
      gl.attachShader(prog, fs);
      gl.linkProgram(prog);
      if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) {
        return this.giveUp('link failed: ' + gl.getProgramInfoLog(prog));
      }
      gl.useProgram(prog);

      var buf = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, buf);
      gl.bufferData(gl.ARRAY_BUFFER, new global.Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);
      var loc = gl.getAttribLocation(prog, 'aPos');
      gl.enableVertexAttribArray(loc);
      gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);

      var names = ['uRes', 'uTime', 'uScroll', 'uHorizon', 'uDusk', 'uSpeed'];
      for (var i = 0; i < names.length; i++) this._u[names[i]] = gl.getUniformLocation(prog, names[i]);

      // A lost context in a backgrounded WebView must not leave a dead canvas.
      canvas.addEventListener('webglcontextlost', function (e) {
        e.preventDefault();
        Sky.giveUp('context lost');
      });

      this.gl = gl;
      this.active = true;
      this._t0 = (global.performance && performance.now ? performance.now() : Date.now()) / 1000;
      this._frames = -30;   // ignore the first frames: assets are still decoding
      this.resize();
      return true;
    },

    giveUp: function (why) {
      if (global.console && console.info) console.info('[DriftSky] falling back to canvas 2D: ' + why);
      this._failed = true;
      this.active = false;
      this.gl = null;
      if (this.canvas) this.canvas.style.display = 'none';
      if (this.onFallback) this.onFallback();
      return false;
    },

    resize: function () {
      if (!this.active) return;
      var rect = this.canvas.getBoundingClientRect();
      var dpr = Math.min(global.devicePixelRatio || 1, 2);
      // Deliberately under-render: this layer is all gradients and noise, so
      // the compositor's upscale is invisible but the fill rate saving is not.
      var w = Math.max(1, Math.round(rect.width * dpr * this.scale));
      var h = Math.max(1, Math.round(rect.height * dpr * this.scale));
      if (w === this.canvas.width && h === this.canvas.height) return;
      this.canvas.width = w;
      this.canvas.height = h;
      this.gl.viewport(0, 0, w, h);
    },

    /** Watch the real frame time and walk the quality down, then off.

        A shader background is a luxury: on a device that cannot afford it the
        right answer is fewer pixels, and failing that, the 2D scene. Only
        downgrades are applied, so this cannot oscillate. */
    observe: function (dtMs) {
      if (!this.active || !(dtMs > 0)) return;
      if (this._frames < 0) { this._frames++; return; }   // warm-up frames

      this._acc += dtMs;
      this._frames++;
      if (this._frames < 60) return;

      var avg = this._acc / this._frames;
      this._acc = 0;
      this._frames = 0;

      if (avg <= 26) return;
      if (this._step < this.STEPS.length - 1) {
        this._step++;
        this.scale = this.STEPS[this._step];
        this.canvas.width = 0;            // force resize() to rebuild
        this.resize();
        if (global.console && console.info) {
          console.info('[DriftSky] ' + avg.toFixed(0) + ' ms/frame — dropping to scale ' + this.scale);
        }
      } else if (avg > 38) {
        this.giveUp(avg.toFixed(0) + ' ms/frame at the lowest quality');
      }
    },

    /** state: { scroll, horizon (css px), dusk 0..1, speed 0..1 } */
    render: function (state) {
      if (!this.active) return;
      var gl = this.gl;
      var now = (global.performance && performance.now ? performance.now() : Date.now()) / 1000;
      var ratio = this.canvas.height / Math.max(1, this.canvas.getBoundingClientRect().height);

      gl.uniform2f(this._u.uRes, this.canvas.width, this.canvas.height);
      gl.uniform1f(this._u.uTime, now - this._t0);
      gl.uniform1f(this._u.uScroll, state.scroll || 0);
      gl.uniform1f(this._u.uHorizon, (state.horizon || 0) * ratio);
      gl.uniform1f(this._u.uDusk, state.dusk || 0);
      gl.uniform1f(this._u.uSpeed, state.speed || 0);
      gl.drawArrays(gl.TRIANGLES, 0, 3);
    }
  };

  global.DriftSky = Sky;
})(window);
