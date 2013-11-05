###
This is Game Of Life
Author Rafael Cosman
This code is Maddy approved.
###

#$ = jQuery

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

#More serious functions
#------------------------
makeNewGrid = () ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			0
			
randomizeGrid = () ->
	ages = randomGrid
			
randomGrid = () ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			Math.floor(Math.random() + .4)
			
getBinaryThingey = (num) ->
	if num == 0
		return 0
	else
		return 1
		
inc = (arr, x, y) ->
	if x >= 0 and y >= 0 and x < arr.length and y < arr[0].length
		arr[x][y]++
zero = (arr, x, y) ->
	if x >= 0 and y >= 0 and x < arr.length and y < arr[0].length
		arr[x][y] = 0

#hsl doesn't seem to work :(
rgb = (r, g, b) ->
	"rgb(" + r + "," + g + "," + b + ")"
rgba = (r, g, b, a) ->
	"rgba(" + r + "," + g + "," + b + "," + a + ")"
		
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
  
  rgb(Math.floor(r*255), Math.floor(g*255), Math.floor(b*255))
			
#Run
#----------------
draw = () -> 
	numNeighbors = makeNewGrid()
	
	#Count up the number of neighbors each cell has
	for x in [0...gridWidth]
		for y in [0...gridHeight]
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
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			if rules[getBinaryThingey(ages[x][y])][numNeighbors[x][y]]
				ages[x][y]++
			else
				ages[x][y] = 0
			
	#Clear the background
	context.fillStyle = rgb(0, 0, 0)
	background()
	
	#Display the cells to the screen
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			age = ages[x][y]
			
			if age != 0
				ageTillLoop = 50
				context.fillStyle = HSVtoRGB(age%ageTillLoop / ageTillLoop, 1, 1)
				border = 3
				context.fillRect(gridSpacing * x, gridSpacing * y, gridSpacing - border, gridSpacing - border)

	setTimeout(draw, 0)
	
	#Draw the buttons
	for x in [0...1+1] #this corresponds to life or death
		for y in [0...8+1] #this is the number of neighbors
			if rules[x][y]
				context.fillStyle = rgba(255, 255, 255, .6)
			else
				context.fillStyle = rgba(0, 0, 0, .5)
				
			context.fillRect(buttonWidth * x, buttonHeight * y, buttonWidth, buttonHeight)
	
	context.save()
	tutorial()
	context.restore()
	
tutorial = () ->
	switch tutorialLevel
		when 0 then
			#2 seconds
		when 1
			context.translate(canvas.width-250, 70)
			
			context.fillStyle = rgb(100, 100, 100)
			context.fillRect(-10, -20, 200, 50)
			
			context.fillStyle = rgb(255, 255, 255) 
			context.fillText("Left-click and drag", 0, 0)
			context.fillText("to create new cells", 0, 20)
			#We'll wait until the user makes some cells
		when 2 then
			#1 second
		when 3
			context.translate(200, 70)
			
			context.fillStyle = rgb(100, 100, 100)
			context.fillRect(-10, -20, 220, 50)
		
			context.fillStyle = rgb(255, 255, 255)
			context.fillText("Click on these buttons", 0, 0)
			context.fillText("to change the rules", 0, 20)
			#We'll wait until the user changes the rules
		when 4 then
			#now we need to explain the rules!
	
createTutorialBox = () ->
	context.fillStyle = "#FFFFFF"
	context.fillRect(100, 100, 100, 100)
		
advanceTutorial = () ->
	tutorialLevel++
	
tutorialLevel = 0
setTimeout(advanceTutorial, 0)
		
#Setup
#----------
canvas.width = window.innerWidth
canvas.height = window.innerHeight

buttonWidth = 50
buttonHeight = canvas.height / 9

gridSpacing = 15
gridWidth = canvas.width / gridSpacing
gridHeight = canvas.width / gridSpacing

mouseX = 0
mouseY = 0

#context.shadowBlur = 20

ages = randomGrid()
rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]]

context.font="20px Georgia";
draw()

#Mouse IO
#-------------------
mouseDown = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
mouseDownCount = 0
document.body.onmousedown = (event) ->
	++mouseDown[event.button]
	++mouseDownCount
  
	if event.button is 0
		if event.clientX < 2 * buttonWidth
			buttonGridX = Math.floor(event.clientX / buttonWidth)
			buttonGridY = Math.floor(event.clientY / buttonHeight)
			
			rules[buttonGridX][buttonGridY] = !rules[buttonGridX][buttonGridY]
			
			if tutorialLevel == 3
				tutorialLevel++
				setTimeout(advanceTutorial, 0)

document.body.onmouseup = (event) ->
	--mouseDown[event.button]
	--mouseDownCount
  
document.body.onmousemove = (event) ->
	d = 2

	#If dragging with the left mouse button, create cells
	if mouseDown[0]
		if tutorialLevel == 1
			tutorialLevel++
			setTimeout(advanceTutorial, 0)
	
		gridX = Math.floor(event.clientX / gridSpacing)
		gridY = Math.floor(event.clientY / gridSpacing)
		for x in [gridX-d...gridX+1+d]
			for y in [gridY-d...gridY+1+d]
				inc(ages, x, y)
				
	#If dragging with the right mouse button, kill cells
	if mouseDown[2]
		gridX = Math.floor(event.clientX / gridSpacing)
		gridY = Math.floor(event.clientY / gridSpacing)
		for x in [gridX-d...gridX+1+d]
			for y in [gridY-d...gridY+1+d]
				zero(ages, x, y)
				
#Keyboard io
#------------------------
#I want to add space clears board