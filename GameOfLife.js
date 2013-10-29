// Generated by CoffeeScript 1.6.3
/*
This is Game Of Life
Author Rafael Cosman
*/


(function() {
  var ages, background, c, circle, context, fillRect, fillStyle, run, translate;

  c = document.getElementById("myCanvas");

  context = c.getContext("2d");

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
    return context;
  };

  fillStyle = function(string) {
    return context.fillStyle = string;
  };

  console.log("setup");

  fillRect(100, 100);

  translate(50, 50);

  circle(100);

  ages = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];

  setTimeout("run()", 1);

  console.log("end setup");

  run = function() {
    var x, y, _i, _results;
    _results = [];
    for (x = _i = 0; _i <= 3; x = ++_i) {
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (y = _j = 0; _j <= 3; y = ++_j) {
          fillStyle("FFFF00");
          fillRect(10 * x, 10 * y);
          _results1.push(console.log("LOL"));
        }
        return _results1;
      })());
    }
    return _results;
  };

}).call(this);
