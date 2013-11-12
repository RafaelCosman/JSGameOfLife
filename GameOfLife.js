// Generated by CoffeeScript 1.6.3
(function() {
  var $, HSVtoRGB, ages, background, border, buttonHeight, buttonWidth, canvas, computeNextGeneration, context, draw, drawCells, getBinaryThingey, gridHeight, gridSpacing, gridWidth, inc, makeNewGrid, mouse, mouseX, mouseY, randomGrid, randomizeGrid, rgb, rgba, root, rules, setHidden, setVisible, zero;

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

  zero = function(arr, x, y) {
    if (x >= 0 && y >= 0 && x < arr.length && y < arr[0].length) {
      return arr[x][y] = 0;
    }
  };

  rgb = function(r, g, b) {
    return "rgb(" + r + "," + g + "," + b + ")";
  };

  rgba = function(r, g, b, a) {
    return "rgba(" + r + "," + g + "," + b + "," + a + ")";
  };

  HSVtoRGB = function(h, s, v) {
    var b, f, g, i, p, q, r, t;
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
    return rgb(Math.floor(r * 255), Math.floor(g * 255), Math.floor(b * 255));
  };

  /* --------------------------------------------
       Begin io.coffee
  --------------------------------------------
  */


  $ = jQuery;

  ($("body")).append("<p>test</p>");

  /*
  jQueryKey should be a string like
  #myID
  */


  setVisible = function(jQueryKey) {
    return ($(jQueryKey)).css("visibility", "visible");
  };

  setHidden = function(jQueryKey) {
    return ($(jQueryKey)).css("visibility", "hidden");
  };

  this.help = function() {
    root.helpShown = !root.helpShown;
    root.paused = root.helpShown;
    if (helpShown) {
      return setVisible(".helpBox");
    } else {
      return setHidden(".helpBox");
    }
  };

  this.pause = function() {
    return root.paused = !root.paused;
  };

  this.toggleRule = function(x, y) {
    return rules[x][y] = !rules[x][y];
  };

  mouse = {
    x: 0,
    y: 0,
    down: [false, false, false, false, false, false, false, false, false],
    getX: function() {
      return this.x;
    },
    getY: function() {
      return this.y;
    },
    getButtonX: function() {
      return Math.floor(this.x / buttonWidth);
    },
    getButtonY: function() {
      return Math.floor(this.y / buttonHeight);
    },
    getGridX: function() {
      return Math.floor(this.x / gridSpacing);
    },
    getGridY: function() {
      return Math.floor(this.y / gridSpacing);
    },
    distanceTo: function(otherX, otherY) {
      return Math.sqrt(Math.pow(otherX - this.x, 2) + Math.pow(otherY - this.y, 2));
    }
  };

  $("#myCanvas").mousedown(function(event) {
    return mouse.down[event.which] = true;
  });

  $("#myCanvas").mouseup(function(event) {
    mouse.down[event.which] = false;
    if (root.help) {
      root.help = false;
      return root.paused = false;
    }
  });

  $("#myCanvas").mousemove(function(event) {
    var d, gridX, gridY, x, y, _i, _j, _k, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _results;
    mouse.x = event.pageX;
    mouse.y = event.pageY;
    gridX = mouse.getGridX();
    gridY = mouse.getGridY();
    d = 2;
    if (mouse.down[1]) {
      if (!root.userHasCreatedCells) {
        root.userHasCreatedCells = true;
        setHidden("#tutorialCreateCells");
        if (!root.userHasChangedRules) {
          setVisible("#tutorialChangeRules");
        }
      }
      for (x = _i = _ref = gridX - d, _ref1 = gridX + 1 + d; _ref <= _ref1 ? _i < _ref1 : _i > _ref1; x = _ref <= _ref1 ? ++_i : --_i) {
        for (y = _j = _ref2 = gridY - d, _ref3 = gridY + 1 + d; _ref2 <= _ref3 ? _j < _ref3 : _j > _ref3; y = _ref2 <= _ref3 ? ++_j : --_j) {
          inc(ages, x, y);
        }
      }
    }
    if (mouse.down[3]) {
      root.userHasDeletedCells = true;
      _results = [];
      for (x = _k = _ref4 = gridX - d, _ref5 = gridX + 1 + d; _ref4 <= _ref5 ? _k < _ref5 : _k > _ref5; x = _ref4 <= _ref5 ? ++_k : --_k) {
        _results.push((function() {
          var _l, _ref6, _ref7, _results1;
          _results1 = [];
          for (y = _l = _ref6 = gridY - d, _ref7 = gridY + 1 + d; _ref6 <= _ref7 ? _l < _ref7 : _l > _ref7; y = _ref6 <= _ref7 ? ++_l : --_l) {
            _results1.push(zero(ages, x, y));
          }
          return _results1;
        })());
      }
      return _results;
    }
  });

  $(window).resize(function() {
    var buttonHeight, buttonWidth, gridHeight, gridWidth;
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    buttonWidth = 50;
    buttonHeight = canvas.height / 9;
    gridWidth = canvas.width / gridSpacing;
    return gridHeight = canvas.width / gridSpacing;
  });

  ($(".ruleButton")).click(function() {
    ($(this)).toggleClass("down");
    if (!root.userHasChangedRules) {
      root.userHasChangedRules = true;
      setHidden("#tutorialChangeRules");
      setTimeout((function() {
        return setVisible("#tutorialLeftCol");
      }), 1000);
      setTimeout((function() {
        return setHidden("#tutorialLeftCol");
      }), 5000);
      setTimeout((function() {
        return setVisible("#tutorialRightCol");
      }), 5000);
      return setTimeout((function() {
        return setHidden("#tutorialRightCol");
      }), 9000);
    }
  });

  /* --------------------------------------------
       Begin GameOfLife.coffee
  --------------------------------------------
  */


  /*
  This is Game Of Life
  Author Rafael Cosman
  This code is Maddy approved.
  */


  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  canvas = document.getElementById("myCanvas");

  context = canvas.getContext("2d");

  background = function() {
    var bigNum;
    bigNum = 100000;
    return context.fillRect(-bigNum, -bigNum, 2 * bigNum, 2 * bigNum);
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

  this.clearGrid = function() {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
          _results1.push(ages[x][y] = 0);
        }
        return _results1;
      })());
    }
    return _results;
  };

  randomGrid = function() {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
          _results1.push(Math.floor(Math.random() + 0.4));
        }
        return _results1;
      })());
    }
    return _results;
  };

  randomizeGrid = function() {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
          _results1.push(ages[x][y] = Math.floor(Math.random() + 0.4));
        }
        return _results1;
      })());
    }
    return _results;
  };

  computeNextGeneration = function() {
    var numNeighbors, x, y, _i, _j, _k, _results;
    numNeighbors = makeNewGrid();
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
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
    _results = [];
    for (x = _k = 0; 0 <= gridWidth ? _k < gridWidth : _k > gridWidth; x = 0 <= gridWidth ? ++_k : --_k) {
      _results.push((function() {
        var _l, _results1;
        _results1 = [];
        for (y = _l = 0; 0 <= gridHeight ? _l < gridHeight : _l > gridHeight; y = 0 <= gridHeight ? ++_l : --_l) {
          if (rules[getBinaryThingey(ages[x][y])][numNeighbors[x][y]]) {
            _results1.push(ages[x][y]++);
          } else {
            _results1.push(ages[x][y] = 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  drawCells = function() {
    var age, hue, timeModifier, x, y, _i, _results;
    timeModifier = new Date().getTime() / 10000;
    _results = [];
    for (x = _i = 0; 0 <= gridWidth ? _i < gridWidth : _i > gridWidth; x = 0 <= gridWidth ? ++_i : --_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; 0 <= gridHeight ? _j < gridHeight : _j > gridHeight; y = 0 <= gridHeight ? ++_j : --_j) {
          age = ages[x][y];
          if (age !== 0) {
            hue = Math.sqrt(age);
            hue *= 0.2;
            context.fillStyle = HSVtoRGB((hue + timeModifier) % 1, 1, 1);
            _results1.push(context.fillRect(gridSpacing * x, gridSpacing * y, gridSpacing - border, gridSpacing - border));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  draw = function() {
    if (!root.paused) {
      computeNextGeneration();
    }
    context.fillStyle = rgb(0, 0, 0);
    background();
    drawCells();
    if (ages[mouse.getGridX()][mouse.getGridY()] !== 0) {
      context.fillStyle = rgba(255, 255, 255, 0.7);
      context.fillRect(mouse.getGridX() * gridSpacing, mouse.getGridY() * gridSpacing, gridSpacing - border, gridSpacing - border);
    }
    return setTimeout(draw, 0);
  };

  root.userHasCreatedCells = false;

  root.userHasChangedRules = false;

  root.userHasDeletedCells = false;

  setTimeout((function() {
    return setVisible("#tutorialCreateCells");
  }), 1000);

  canvas.width = window.innerWidth;

  canvas.height = window.innerHeight;

  buttonWidth = 50;

  buttonHeight = canvas.height / 9;

  gridSpacing = 15;

  border = 3;

  gridWidth = canvas.width / gridSpacing;

  gridHeight = canvas.width / gridSpacing;

  mouseX = 0;

  mouseY = 0;

  ages = randomGrid();

  rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]];

  root.helpShown = false;

  root.paused = false;

  context.font = "20px Georgia";

  draw();

}).call(this);
