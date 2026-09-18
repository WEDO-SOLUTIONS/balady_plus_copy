/* Drift the Desert — the sand under the car.

   The floor is the one surface the player stares at for a whole run, so it is
   a real texture mapped onto the ground plane rather than a painted gradient.
   Getting that right in Canvas 2D turned out to be impossible, and the reason
   is worth writing down, because the first two attempts both looked wrong in
   ways that were hard to name.

   A 2D context can only fill a shape with a pattern under an affine
   transform, and perspective is not affine. The usual dodge is to cut the
   floor into horizontal bands and give each one the transform that is right
   at its middle. In a still frame that is invisible. In motion it is not: the
   texture inside a band translates at one uniform rate, the band below it at
   another, so every seam is a step in velocity, and the floor reads as a
   stack of separate conveyor belts — stripes pouring down the screen rather
   than ground going past a car. Varying the motion blur per band added a
   second set of stripes, in sharpness.

   So the plane is drawn in WebGL instead, as two triangles with the mapping
   done per pixel:

   - **Exact perspective.** With `t` running 0 at the horizon to 1 at the
     bottom of the frame, depth goes as 1/t. Every pixel computes its own
     depth and lateral offset, so there is nothing to step between.
   - **Hardware filtering.** Mipmaps and anisotropic filtering are what
     actually stop sand crawling at a grazing angle, and a pattern fill has
     neither. This is the single biggest reason the GPU path looks calmer.
   - **Motion blur in the shader**, three taps back along the direction of
     travel, the length taken from how far the car moved this frame. It
     varies smoothly with depth because a fixed offset in texels is a larger
     offset on screen the closer it is.
   - **The road in the same pass**, sampled from its own texture with the
     tile centred on the track and blended in through the same wobbling edge
     the painted track uses, so there is no clip and no second pass.

   The result is drawn into an offscreen GL canvas and blitted into the scene
   with one drawImage, which keeps the rest of the renderer untouched.

   If WebGL is missing or the context is lost, `draw` returns false and
   js/scene.js paints its own floor, as it did before any of this existed. */
(function (global) {
  'use strict';

  // How many tiles span the screen width at the bottom of the frame. With the
  // baked texture's ripple spacing this puts them about 14 cm apart, which is
  // what the real ones measure.
  var TILE_ACROSS = 2.1;

  // Texels of travel per unit of `scroll`. Tuned against the roadside props,
  // which cross the frame on the same clock, so the floor and the things
  // standing on it agree about how fast the car is going.
  var TRAVEL = 12;

  // The plane is rendered at a fraction of device resolution and blitted up.
  // It is filtered and motion blurred, so there is very little in it that
  // survives to a device pixel anyway, and a phone GPU has to sample every
  // one of these several times over.
  var RES_SCALE = 1.0;

  // …and never more than this many pixels of it, which is what keeps a 1440p
  // phone from quietly costing three times what a 1080p one does.
  var MAX_PIXELS = 1.7e6;

  // Anisotropy, which is what stops the far field either aliasing or turning
  // to mush. Past four the cost climbs faster than the picture improves.
  var ANISO = 4;

  /* How much desert the game keeps track of, and how close to the camera a
     thing can get before it wraps round to the far end again. Both are fixed
     lengths of world, in texels — about a hundred metres of band.

     They used to be derived from the depth at the bottom of the frame, which
     is a camera measurement: it moves with the horizon, the horizon moves
     with speed, and so every rock and cliff in the desert was re-laid-out
     whenever the car sped up or slowed down. That is what made them appear
     and disappear without warning. */
  var BAND = 22;            // in tiles
  var NEAR = 0.3;

  /* The road itself.

     Half its width, as a fraction of the texture's size, and constant: a road
     does not get wider the further away it is. It was drawn as a trapezoid
     fitted to the screen before, which made it nearly three times as wide in
     the world at the horizon as it was at the car — so everything placed
     against its edges drifted sideways as it came in, and the road texture
     had to stretch to fit. */
  var TRACK_HALF = 0.226;

  // How much wider the road's own tile is than the road, so its edges have
  // somewhere to fade back into open sand.
  var ROAD_MARGIN = 1.20;

  /* The track wanders, because a desert track wanders. The lateral offset
     grows from zero at the car — which is what keeps the car on the road —
     with a slope that turns over on two long periods. Both divide the wrap
     below, so the distance travelled can be reduced into it without the bend
     jumping when it does. At speed those periods come out around forty and
     ninety seconds.

     This replaces a meander that used to be baked into the road texture,
     where the longest wavelength available was one tile — about five metres
     of desert, which arrived twice a second and read as the road snaking. */
  var CURVE_WRAP = 262144;
  var CURVE_K1 = Math.PI * 4 / CURVE_WRAP;
  var CURVE_K2 = Math.PI * 2 / CURVE_WRAP;
  var CURVE_A1 = 2.05;      // amplitudes, in tiles
  var CURVE_A2 = 1.27;

  /** Where the road's centre line is, at absolute distance `z`. */
  function curveLine(z, size) {
    return (CURVE_A1 * Math.sin(z * CURVE_K1) +
            CURVE_A2 * Math.sin(z * CURVE_K2 + 1.1)) * size;
  }

  /** The bend, seen from a camera that is itself on the road: the line's
      offset at this depth minus its offset at the car. Subtracting the
      camera's own place on it is what keeps the car on the road — without
      it the road slides out from under the wheels as you drive. */
  function curveAt(depth, travelCurve, size, TD) {
    return curveLine(travelCurve + depth, size) - curveLine(travelCurve + TD, size);
  }

  var VERT = 'attribute vec2 aPos;' +
    'void main() { gl_Position = vec4(aPos, 0.0, 1.0); }';

  var FRAG = [
    'precision highp float;',
    '',
    'uniform vec2  uRes;        // device px',
    'uniform float uHorizon;    // device px from the top',
    'uniform float uSpan;       // device px, horizon to the bottom of the plane',
    'uniform float uTD;         // depth at the bottom of the frame, in texels',
    'uniform float uA0;         // device px per texel at the bottom',
    'uniform float uTravel;     // texels travelled, wrapped to the tile',
    'uniform float uCurve;      // …and wrapped to the bend\'s period',
    'uniform float uHalf;       // half the road, in texels',
    'uniform float uRoadX;      // texels of road texture per texel of world',
    'uniform float uBlur;       // texels travelled this frame',
    'uniform float uLateral;    // the car lean the track centre follows',
    'uniform float uDusk;',
    'uniform float uRoadOn;',
    'uniform float uTexSize;',
    'uniform vec3  uTint;',
    'uniform sampler2D uSand;',
    'uniform sampler2D uRoad;',
    '',
    '/* The drift of loose sand along the shoulder, as a function of where the',
    '   ground is rather than of what time it is: the wobble belongs to the',
    '   desert, so it has to come at the camera with it. Same three sines as',
    '   js/scene.js, which reads the same depth. */',
    'float edgeNoise(float depth, float side) {',
    '  float w = depth * 0.00042 + (side > 0.0 ? 31.7 : 0.0);',
    '  return sin(w) * 0.6 + sin(w * 2.7 + 1.3) * 0.3 + sin(w * 6.1) * 0.1;',
    '}',
    '',
    '/* The bend, as js/ground.js computes it. Both have to agree exactly or',
    '   the painted edges and the textured road part company. */',
    'float curveLine(float z) {',
    '  return (' + CURVE_A1 + ' * sin(z * ' + CURVE_K1 + ') +',
    '          ' + CURVE_A2 + ' * sin(z * ' + CURVE_K2 + ' + 1.1)) * uTexSize;',
    '}',
    '',
    'float curveAt(float depth) {',
    '  return curveLine(uCurve + depth) - curveLine(uCurve + uTD);',
    '}',
    '',
    'void main() {',
    '  // The canvas covers the ground only, so y is measured down from the',
    '  // horizon and everything is in its pixels rather than the frame\'s.',
    '  float x = gl_FragCoord.x;',
    '  float y = uRes.y - gl_FragCoord.y;',
    '',
    '  // Clamped rather than discarded: a branch around a texture fetch',
    '  // leaves its derivatives undefined, and the derivatives are what pick',
    '  // the mip level. Everything above the horizon comes out at alpha 0.',
    '  float t = max((y - uHorizon) / uSpan, 0.02);',
    '  float s = 0.035 + 0.965 * t;',
    '',
    '  float a = uA0 * t;                 // device px per texel across',
    '  float ty = uTD / t + uTravel;      // texels into the distance, for the tile',
    '  float bend = curveAt(uTD / t);',
    '  float cx = uRes.x * 0.5 - uLateral * uRes.x * 0.06 * (1.0 - s) + bend * a;',
    '  float tx = (x - cx) / a;',
    '',
    '  // Two taps for the sand, one for the road: the sand ripples run across',
    '  // the direction of travel and alias against it, the ruts run along it',
    '  // and cannot, and every fetch here is paid for a million times a frame.',
    '  // The small negative bias pulls the mip selection back towards sharp:',
    '  // anisotropic filtering already keeps this honest, and without it the',
    '  // grazing angle averages the sand into suede.',
    '  //',
    '  // Near the horizon it goes the other way, hard. A few rows below the',
    '  // skyline one screen pixel covers thousands of texels, and whichever',
    '  // of them the filter lands on changes fast enough to crawl — which is',
    '  // what made the horizon shimmer. Biasing up there samples what is',
    '  // effectively the tile average, and an average does not flicker.',
    '  float lod = -0.35 + smoothstep(0.14, 0.03, t) * 3.2;',
    '  vec3 sand = texture2D(uSand, vec2(tx, ty) / uTexSize, lod).rgb;',
    '  sand += texture2D(uSand, vec2(tx, ty - uBlur * 0.6) / uTexSize, lod).rgb;',
    '  sand *= 0.5;',
    '  // The road has its own lateral scale: its tile spans the road rather',
    '  // than two screen widths, which is twice the texels across the part of',
    '  // the frame the player is actually looking at.',
    '  float rx = tx * uRoadX + uTexSize * 0.5;',
    '  vec3 road = texture2D(uRoad, vec2(rx, ty - uBlur * 0.3) / uTexSize, lod).rgb;',
    '',
    '  // The track, with the same wobbling edge the painted one has.',
    '  float side = x > cx ? 1.0 : -1.0;',
    '  float halfW = uHalf * a;           // constant in the world, not on screen',
    '  float edge = halfW * (1.0 - edgeNoise(uTD / t + uCurve, side) * 0.07);',
    '',
    '  float feather = max(2.0, edge * 0.07);',
    '  float onRoad = (1.0 - smoothstep(edge - feather, edge, abs(x - cx))) * uRoadOn;',
    '',
    '  vec3 col = mix(sand, road, onRoad);',
    '  col = mix(col, col * uTint, uDusk);',
    '',
    '  // Dissolve into the haze the plates end in, starting a little lower',
    '  // than it used to: the last few rows were never more than noise.',
    // The textured plane used to be invisible until t = 0.045 and only fully
    // opaque at t = 0.21 — a 107 px band below the horizon where the only
    // ground was the painted dunes plate, sliding on its own clock. Every
    // outcrop stands in exactly that band, so they were solid rock on a
    // surface that was not there: measured, one at t = 0.076 was fully
    // opaque over ground drawn at 19%. The LOD bias above already blurs this
    // strip to near-flat sand, which is what makes it safe to draw it.
    '  float fade = clamp((t - 0.008) / 0.075, 0.0, 1.0);',
    '  gl_FragColor = vec4(col * fade, fade);',
    '}'
  ].join('\n');

  var Ground = {
    /* Where the ground is, in the units everything else on it has to use.

       Depth is measured in the texture's own texels and shrinks as the world
       comes at you, so a thing standing on the ground is a depth and a
       lateral offset, and its place on screen falls out of the same two
       lines the shader uses. Everything here works whether or not WebGL
       came up, because the props have to move the same way either way. */
    metrics: function (o) {
      var span = o.h * 1.04 - o.horizon;
      var A0 = TILE_ACROSS * o.w / this.size;   // css px per texel at t = 1
      var travel = o.scroll * TRAVEL;
      return {
        span: span,
        A0: A0,
        TD: span / A0,                          // depth at the bottom of the frame
        travel: travel,
        travelPerScroll: TRAVEL,
        halfTexels: TRACK_HALF * this.size,     // the road, in world texels
        size: this.size,
        band: BAND * this.size,                 // how much desert is tracked
        near: NEAR * this.size,
        // Reduced into the bend's period, so the sines stay in range and the
        // road does not jump when the number wraps.
        travelCurve: travel % CURVE_WRAP
      };
    },

    /** Where the road's centre line is at this depth, in texels off straight
        ahead. `worldZ` is depth plus the distance travelled. */
    curveAt: curveAt,

    ready: false,
    roadReady: false,
    budget: 1,        // pixel budget, cut back on a device that cannot keep up
    slow: 0,

    canvas: null,
    gl: null,
    prog: null,
    uni: {},
    tex: {},
    size: 2048,
    pending: 0,

    /** `urls` is {sand, road} — file paths, or data URIs in the single-file
        build. The road is optional; without it the track stays painted. */
    load: function (urls, onDone) {
      var self = this;
      var images = {};
      var names = urls.road ? ['sand', 'road'] : ['sand'];
      var left = names.length;

      names.forEach(function (name) {
        var img = new global.Image();
        img.onload = function () {
          images[name] = img;
          if (--left === 0) finish();
        };
        img.onerror = function () { if (--left === 0) finish(); };
        img.src = urls[name];
      });

      function finish() {
        try {
          self.init(images);
        } catch (e) {
          self.ready = false;
          self.roadReady = false;
        }
        if (onDone) onDone(self.ready);
      }
    },

    init: function (images) {
      if (!images.sand) return;

      var canvas = global.document.createElement('canvas');
      canvas.width = 2;
      canvas.height = 2;
      var gl = canvas.getContext('webgl', {
        alpha: true, premultipliedAlpha: true, antialias: false,
        depth: false, stencil: false
      }) || canvas.getContext('experimental-webgl');
      if (!gl) return;

      var prog = gl.createProgram();
      gl.attachShader(prog, compile(gl, gl.VERTEX_SHADER, VERT));
      gl.attachShader(prog, compile(gl, gl.FRAGMENT_SHADER, FRAG));
      gl.linkProgram(prog);
      if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) {
        throw new Error(gl.getProgramInfoLog(prog));
      }
      gl.useProgram(prog);

      var buf = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, buf);
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);
      var loc = gl.getAttribLocation(prog, 'aPos');
      gl.enableVertexAttribArray(loc);
      gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);

      this.uni = {};
      ['uRes', 'uHorizon', 'uSpan', 'uTD', 'uA0', 'uTravel', 'uBlur', 'uLateral',
       'uDusk', 'uRoadOn', 'uTexSize', 'uTint', 'uSand', 'uRoad',
       'uCurve', 'uHalf', 'uRoadX'
      ].forEach(function (n) { Ground.uni[n] = gl.getUniformLocation(prog, n); });

      this.tex.sand = upload(gl, images.sand);
      this.tex.road = images.road ? upload(gl, images.road) : this.tex.sand;
      this.size = images.sand.naturalWidth || 2048;

      gl.activeTexture(gl.TEXTURE0);
      gl.bindTexture(gl.TEXTURE_2D, this.tex.sand);
      gl.uniform1i(this.uni.uSand, 0);
      gl.activeTexture(gl.TEXTURE1);
      gl.bindTexture(gl.TEXTURE_2D, this.tex.road);
      gl.uniform1i(this.uni.uRoad, 1);

      canvas.addEventListener('webglcontextlost', function (e) {
        e.preventDefault();
        Ground.ready = false;
        Ground.roadReady = false;
      });

      this.canvas = canvas;
      this.gl = gl;
      this.prog = prog;
      this.ready = true;
      this.roadReady = !!images.road;
    },

    /** Frame time, from the scene. A phone that cannot hold 60 gets fewer
        ground pixels rather than a slideshow; two steps down and it stops,
        because past that the picture costs more than it is worth. */
    pace: function (dt) {
      if (dt > 0.028) {
        if (++this.slow > 90 && this.budget > 0.5) {
          this.budget *= 0.66;
          this.slow = 0;
        }
      } else if (this.slow > 0) {
        this.slow--;
      }
    },

    /** Draw the plane and blit it into the scene's 2D context. `o` is
        {w, h, dpr, horizon, scroll, dScroll, lateral, dusk, tint}. */
    draw: function (ctx, o) {
      if (!this.ready) return false;
      var gl = this.gl;

      // Only the ground is drawn, so the canvas starts at the horizon rather
      // than at the top of the frame: nearly half the pixels, for free. The
      // top is where the horizon is at its highest, not where it is now — it
      // rises with speed, and resizing a GL canvas every time it crossed a
      // pixel cost a reallocation and showed as a flicker along the skyline.
      var top = Math.floor(o.top);
      var full = o.w * o.dpr * (o.h - top) * o.dpr;
      var px = o.dpr * Math.min(RES_SCALE,
                                Math.sqrt(MAX_PIXELS * this.budget / Math.max(1, full)));
      var w = Math.max(1, Math.round(o.w * px));
      var h = Math.max(1, Math.round((o.h - top) * px));
      if (this.canvas.width !== w || this.canvas.height !== h) {
        this.canvas.width = w;
        this.canvas.height = h;
      }
      gl.viewport(0, 0, w, h);

      var horizon = (o.horizon - top) * px;
      var span = (o.h * 1.04 - top) * px - horizon;
      if (span <= 1) return false;

      var A0 = TILE_ACROSS * w / this.size;   // canvas px per texel at t = 1
      var TD = span / A0;                     // depth at the bottom, in texels
      // Same number the scene's props run on: the canvas is a scaled copy of
      // the frame, and the scale cancels out of span/A0.


      // Wrapped to the tile so a long run cannot walk the coordinates out of
      // float precision — the texture repeats, so this is exact.
      var travel = (o.scroll * TRAVEL) % this.size;

      gl.useProgram(this.prog);
      gl.uniform2f(this.uni.uRes, w, h);
      gl.uniform1f(this.uni.uHorizon, horizon);
      gl.uniform1f(this.uni.uSpan, span);
      gl.uniform1f(this.uni.uTD, TD);
      gl.uniform1f(this.uni.uA0, A0);
      gl.uniform1f(this.uni.uTravel, travel);
      gl.uniform1f(this.uni.uCurve, (o.scroll * TRAVEL) % CURVE_WRAP);
      gl.uniform1f(this.uni.uHalf, TRACK_HALF * this.size);
      gl.uniform1f(this.uni.uRoadX, 1 / (2 * TRACK_HALF * ROAD_MARGIN));
      gl.uniform1f(this.uni.uBlur, Math.min(o.dScroll || 0, (o.speed || 0) / 30) * TRAVEL);
      gl.uniform1f(this.uni.uLateral, o.lateral || 0);
      gl.uniform1f(this.uni.uDusk, o.dusk || 0);
      gl.uniform1f(this.uni.uRoadOn, this.roadReady ? 1 : 0);
      gl.uniform1f(this.uni.uTexSize, this.size);
      gl.uniform3f(this.uni.uTint, o.tint[0], o.tint[1], o.tint[2]);

      gl.clearColor(0, 0, 0, 0);
      gl.clear(gl.COLOR_BUFFER_BIT);
      gl.drawArrays(gl.TRIANGLES, 0, 3);

      ctx.drawImage(this.canvas, 0, top, o.w, o.h - top);
      return true;
    }
  };

  function compile(gl, type, src) {
    var sh = gl.createShader(type);
    gl.shaderSource(sh, src);
    gl.compileShader(sh);
    if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) {
      throw new Error(gl.getShaderInfoLog(sh));
    }
    return sh;
  }

  /** A repeating, mipmapped texture. Anisotropy is the whole point of doing
      this on the GPU: the ground is seen at a grazing angle, and without it
      the far field either aliases or turns to mush. */
  function upload(gl, img) {
    var tex = gl.createTexture();
    gl.bindTexture(gl.TEXTURE_2D, tex);
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, false);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.generateMipmap(gl.TEXTURE_2D);

    var ext = gl.getExtension('EXT_texture_filter_anisotropic') ||
              gl.getExtension('WEBKIT_EXT_texture_filter_anisotropic') ||
              gl.getExtension('MOZ_EXT_texture_filter_anisotropic');
    if (ext) {
      var max = gl.getParameter(ext.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
      gl.texParameterf(gl.TEXTURE_2D, ext.TEXTURE_MAX_ANISOTROPY_EXT, Math.min(ANISO, max));
    }
    return tex;
  }

  global.DriftGround = Ground;
})(window);
