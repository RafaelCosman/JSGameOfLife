// Generated by CoffeeScript 1.6.3
/*
This is Game Of Life
Author Rafael Cosman
*/


(function() {
  var HSVtoRGB, ages, background, canvas, circle, context, convertTo2DigitHex, createArray, draw, fillRect, fillStyle, getBinaryThingey, gridHeight, gridSpacing, gridWidth, inc, makeNewGrid, println, randomGrid, randomizeGrid, restore, rules, save, translate;

  canvas = document.getElementById("myCanvas");

  context = canvas.getContext("2d");

  translate = function(x, y) {
    return context.translate(x, y);
  };

  fillRect = function(width, height) {
    return context.fillRect(0, 0, width, height);
  };

  circle = function(radius) {
    return context.arc(0, 0, radius, 0, 2 * Math.PI, false);
  };

  background = function() {
    var bigNum;
    bigNum = 100000;
    return context.fillRect(-bigNum, -bigNum, 2 * bigNum, 2 * bigNum);
  };

  fillStyle = function(string) {
    return context.fillStyle = string;
  };

  save = function() {
    return context.save();
  };

  restore = function() {
    return context.restore();
  };

  println = function(obj) {
    return console.log(obj);
  };

  createArray = function(length) {
    var args, arr, i;
    arr = new Array(length || 0);
    i = length;
    if (arguments_.length > 1) {
      args = Array.prototype.slice.call(arguments_, 1);
      while (i--) {
        arr[length - 1 - i] = createArray.apply(this, args);
      }
    }
    return arr;
  };

  makeNewGrid = function() {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
          _results1.push(0);
        }
        return _results1;
      })());
    }
    return _results;
  };

  randomizeGrid = function() {
    var ages;
    return ages = randomGrid;
  };

  randomGrid = function() {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
          _results1.push(Math.floor(Math.random() + .5));
        }
        return _results1;
      })());
    }
    return _results;
  };

  getBinaryThingey = function(num) {
    if (num === 0) {
      return 0;
    } else {
      return 1;
    }
  };

  inc = function(arr, x, y) {
    if (x >= 0 && y >= 0 && x < arr.length && y < arr[0].length) {
      return arr[x][y]++;
    }
  };

  HSVtoRGB = function(h, s, v) {
    var b, f, g, i, p, q, r, t;
    r = void 0;
    g = void 0;
    b = void 0;
    i = void 0;
    f = void 0;
    p = void 0;
    q = void 0;
    t = void 0;
    if (h && s === undefined && v === undefined) {
      s = h.s;
      v = h.v;
      h = h.h;
    }
    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    switch (i % 6) {
      case 0:
        r = v;
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        g = v;
        b = p;
        break;
      case 2:
        r = p;
        g = v;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        b = v;
        break;
      case 4:
        r = t;
        g = p;
        b = v;
        break;
      case 5:
        r = v;
        g = p;
        b = q;
    }
    return convertTo2DigitHex(r * 255) + convertTo2DigitHex(g * 255) + convertTo2DigitHex(b * 255);
  };

  convertTo2DigitHex = function(number) {
    var string;
    string = "" + Math.floor(number).toString(16);
    if (string.length === 1) {
      return "0" + string;
    } else {
      return string;
    }
  };

  draw = function() {
    var age, ageTillLoop, border, numNeighbors, x, y, _i, _j, _k, _l, _m, _n, _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
    numNeighbors = makeNewGrid();
    for (x = _i = 0, _ref = gridWidth - 1; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
      for (y = _j = 0, _ref1 = gridHeight - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
        if (ages[x][y] !== 0) {
          inc(numNeighbors, x - 1, y - 1);
          inc(numNeighbors, x - 1, y);
          inc(numNeighbors, x - 1, y + 1);
          inc(numNeighbors, x, y - 1);
          inc(numNeighbors, x, y + 1);
          inc(numNeighbors, x + 1, y - 1);
          inc(numNeighbors, x + 1, y);
          inc(numNeighbors, x + 1, y + 1);
        }
      }
    }
    for (x = _k = 0, _ref2 = gridWidth - 1; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; x = 0 <= _ref2 ? ++_k : --_k) {
      for (y = _l = 0, _ref3 = gridHeight - 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; y = 0 <= _ref3 ? ++_l : --_l) {
        if (rules[getBinaryThingey(ages[x][y])][numNeighbors[x][y]]) {
          ages[x][y]++;
        } else {
          ages[x][y] = 0;
        }
      }
    }
    background(0);
    for (x = _m = 0, _ref4 = gridWidth - 1; 0 <= _ref4 ? _m < _ref4 : _m > _ref4; x = 0 <= _ref4 ? ++_m : --_m) {
      for (y = _n = 0, _ref5 = gridHeight - 1; 0 <= _ref5 ? _n <= _ref5 : _n >= _ref5; y = 0 <= _ref5 ? ++_n : --_n) {
        age = ages[x][y];
        if (age !== 0) {
          ageTillLoop = 50;
          context.fillStyle = HSVtoRGB(age % ageTillLoop / ageTillLoop, 1, 1);
          border = 3;
          context.fillRect(gridSpacing * x, gridSpacing * y, gridSpacing - border, gridSpacing - border);
        }
      }
    }
    return setTimeout(draw, 0);
  };

  gridSpacing = 10;

  canvas.width = window.innerWidth;

  gridWidth = canvas.width / gridSpacing;

  canvas.height = window.innerHeight;

  gridHeight = canvas.width / gridSpacing;

  context.shadowBlur = 20;

  ages = randomGrid();

  rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]];

  draw();

}).call(this);
