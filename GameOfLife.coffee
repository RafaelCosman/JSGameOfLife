###
This is Game Of Life
Author Rafael Cosman
###

#Get the canvas
#---------------
canvas = document.getElementById("myCanvas");
context = canvas.getContext("2d");

#Wrappers
#---------------
translate = (x, y) ->
	context.translate(x, y)

fillRect = (width, height) ->
	context.fillRect(0, 0, width, height)

circle = (radius) ->
	context.arc(0, 0, radius, 0, 2 * Math.PI, false);

background = () ->
	bigNum = 100000
	context.fillRect(-bigNum, -bigNum, 2*bigNum, 2*bigNum)

fillStyle = (string) ->
	context.fillStyle = string
	
save = () ->
	context.save()
restore = () ->
	context.restore()
	
println = (obj) ->
	console.log(obj)

#More serious functions
#------------------------	
createArray = (length) ->
  arr = new Array(length or 0)
  i = length
  if arguments_.length > 1
    args = Array::slice.call(arguments_, 1)
    arr[length - 1 - i] = createArray.apply(this, args)  while i--
  arr

makeNewGrid = () ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			0
			
randomizeGrid = () ->
	ages = randomGrid
			
randomGrid = () ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			Math.floor(Math.random() + .5)
			
getBinaryThingey = (num) ->
	if num == 0
		return 0
	else
		return 1
		
inc = (arr, x, y) ->
	if x >= 0 and y >= 0 and x < arr.length and y < arr[0].length
		arr[x][y]++

HSVtoRGB = (h, s, v) ->
  r = undefined
  g = undefined
  b = undefined
  i = undefined
  f = undefined
  p = undefined
  q = undefined
  t = undefined
  if h and s is `undefined` and v is `undefined`
    s = h.s
    v = h.v
    h = h.h
  i = Math.floor(h * 6)
  f = h * 6 - i
  p = v * (1 - s)
  q = v * (1 - f * s)
  t = v * (1 - (1 - f) * s)
  switch i % 6
    when 0
      r = v
      g = t
      b = p
    when 1
      r = q
      g = v
      b = p
    when 2
      r = p
      g = v
      b = t
    when 3
      r = p
      g = q
      b = v
    when 4
      r = t
      g = p
      b = v
    when 5
      r = v
      g = p
      b = q
  
  convertTo2DigitHex(r * 255) + convertTo2DigitHex(g * 255) + convertTo2DigitHex(b * 255)
			
convertTo2DigitHex = (number) ->
	string = "" + Math.floor(number).toString(16)
	if string.length == 1
		return "0" + string
	else
		return string
			
#Run
#----------------
draw = () -> 
	numNeighbors = makeNewGrid()
	
	#Count up the number of neighbors each cell has
	for x in [0...gridWidth-1]
		for y in [0..gridHeight-1]
			if ages[x][y] != 0
				inc(numNeighbors, x-1, y-1)
				inc(numNeighbors, x-1, y)
				inc(numNeighbors, x-1, y+1)
				
				inc(numNeighbors, x, y-1)
				inc(numNeighbors, x, y+1)
				
				inc(numNeighbors, x+1, y-1)
				inc(numNeighbors, x+1, y)
				inc(numNeighbors, x+1, y+1)
	
	#Apply the current rules
	for x in [0...gridWidth-1]
		for y in [0..gridHeight-1]
			if rules[getBinaryThingey(ages[x][y])][numNeighbors[x][y]]
				ages[x][y]++
			else
				ages[x][y] = 0
			
	#Clear the background
	fillStyle("#000000")
	background()
	
	#Display the cells to the screen
	for x in [0...gridWidth-1]
		for y in [0..gridHeight-1]
			age = ages[x][y]
			
			if age != 0
				ageTillLoop = 50
				context.fillStyle = HSVtoRGB(age%ageTillLoop / ageTillLoop, 1, 1)
				border = 3
				context.fillRect(gridSpacing * x, gridSpacing * y, gridSpacing - border, gridSpacing - border)

	setTimeout(draw, 0)
			
#Setup
#----------
gridSpacing = 10
canvas.width = window.innerWidth
gridWidth = canvas.width / gridSpacing

canvas.height = window.innerHeight
gridHeight = canvas.width / gridSpacing

context.shadowBlur = 20

ages = randomGrid()
rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]]

draw()