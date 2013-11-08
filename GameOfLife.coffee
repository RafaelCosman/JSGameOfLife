###
This is Game Of Life
Author Rafael Cosman
This code is Maddy approved.
###

$ = jQuery
root = exports ? this

#Get the canvas
#---------------
canvas = document.getElementById("myCanvas");
context = canvas.getContext("2d");

#Wrappers
#---------------
circle = (radius) ->
	context.arc(0, 0, radius, 0, 2 * Math.PI, false);

background = () ->
	bigNum = 100000
	context.fillRect(-bigNum, -bigNum, 2*bigNum, 2*bigNum)

#More serious functions
#------------------------
makeNewGrid = ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			0
@clearGrid = ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			ages[x][y] = 0
	
randomGrid = ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			Math.floor(Math.random() + .4)
randomizeGrid = ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			ages[x][y] = Math.floor(Math.random() + .4)
			
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

#Button presses
@help = ->
	root.helpShown = !root.helpShown
	root.paused = root.helpShown
	
@pause = ->
	root.paused = !root.paused
	
#Mouse IO
#-------------------
mouse = {
	x: 0
	y: 0
	down: [ false, false, false, false, false, false, false, false, false ]
	
	getX: -> @x
	getY: -> @y
	
	getButtonX: -> Math.floor(@x / buttonWidth)
	getButtonY: -> Math.floor(@y / buttonHeight)
	
	getGridX: -> Math.floor(@x / gridSpacing)
	getGridY: -> Math.floor(@y / gridSpacing)
	
	distanceTo: (otherX, otherY) -> Math.sqrt(Math.pow(otherX - @x, 2) + Math.pow(otherY - @y, 2))
	}
	
$("#myCanvas").mousedown (event) ->
	mouse.down[event.which] = true
  
	if event.which is 1
		if mouse.x < 2 * buttonWidth
			rules[mouse.getButtonX()][mouse.getButtonY()] = !rules[mouse.getButtonX()][mouse.getButtonY()]
			
			if tutorialLevel == 3
				tutorialLevel++
				setTimeout(advanceTutorial, 1000)
				setTimeout(advanceTutorial, 4000)
				setTimeout(advanceTutorial, 5000)
				setTimeout(advanceTutorial, 8000)

$("#myCanvas").mouseup (event) ->
	mouse.down[event.which] = false

$("#myCanvas").mousemove (event) ->
	mouse.x = event.pageX
	mouse.y = event.pageY

	gridX = mouse.getGridX()
	gridY = mouse.getGridY()
	
	d = 2 #this is the size of the users brush to kill or create cells
	
	#If dragging with the left mouse button, create cells
	if mouse.down[1]
		if tutorialLevel == 1
			tutorialLevel++
			setTimeout(advanceTutorial, 1000)
	
		for x in [gridX-d...gridX+1+d]
			for y in [gridY-d...gridY+1+d]
				inc(ages, x, y)
				
	#If dragging with the right mouse button, kill cells
	if mouse.down[3]
		for x in [gridX-d...gridX+1+d]
			for y in [gridY-d...gridY+1+d]
				zero(ages, x, y)

#Keyboard io
#------------------------
#I want to add space clears board

#Window Resize event
$(window).resize ->
	canvas.width = window.innerWidth
	canvas.height = window.innerHeight

	buttonWidth = 50
	buttonHeight = canvas.height / 9

	gridWidth = canvas.width / gridSpacing
	gridHeight = canvas.width / gridSpacing


#Run
#----------------
computeNextGeneration = ->
	numNeighbors = makeNewGrid()
	
	#Count up the number of neighbours each cell has
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

drawCells = ->
	#Display the cells to the screen
	timeModifier = new Date().getTime()/10000
	
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			age = ages[x][y]
			
			if age != 0
				hue = Math.sqrt(age)
				hue *= .2
				context.fillStyle = HSVtoRGB((hue + timeModifier) % 1, 1, 1)
				context.fillRect(gridSpacing * x, gridSpacing * y, gridSpacing - border, gridSpacing - border)
				
drawButtons = ->
	#Draw the buttons
	for x in [0...1+1] #this corresponds to life or death
		for y in [0...8+1] #this is the number of neighbours
			if x == mouse.getButtonX() and y == mouse.getButtonY()
				alpha = 1
			else
				alpha = .5
			
			if rules[x][y]
				context.fillStyle = rgba(255, 255, 255, alpha)
			else
				context.fillStyle = rgba(0, 0, 0, alpha)
				
			context.fillRect(buttonWidth * x, buttonHeight * y, buttonWidth, buttonHeight)
				
draw = -> 
	if !root.paused
		computeNextGeneration()
			
	#Clear the background
	context.fillStyle = rgb(0, 0, 0)
	background()
	
	drawCells()
	
	#Highlight the cell the mouse is over
	if ages[mouse.getGridX()][mouse.getGridY()] != 0
		context.fillStyle = rgba(255, 255, 255, .7)
		context.fillRect(mouse.getGridX() * gridSpacing, mouse.getGridY() * gridSpacing, gridSpacing-border, gridSpacing-border)
	
	drawButtons()
	
	context.save()
	tutorial()
	context.restore()
	
	setTimeout(draw, 0)
	
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
			#1 second
		when 5
			context.translate(200, 70)
			
			context.fillStyle = rgb(100, 100, 100)
			context.fillRect(-10, -20, 320, 70)
		
			context.fillStyle = rgb(255, 255, 255)
			context.fillText("The left column tells", 0, 0)
			context.fillText("how many neighbours a dead cell", 0, 20)
			context.fillText("needs in order to come to life", 0, 40)
			#2 seconds
		when 6 then
			#half a second
		when 7
			context.translate(200, 70)
			
			context.fillStyle = rgb(100, 100, 100)
			context.fillRect(-10, -20, 320, 70)
		
			context.fillStyle = rgb(255, 255, 255)
			context.fillText("The right column tells", 0, 0)
			context.fillText("how many neighbours a live cell", 0, 20)
			context.fillText("needs in order to stay alive", 0, 40)
			#2 seconds
		
advanceTutorial = () ->
	tutorialLevel++
	
tutorialLevel = 0
setTimeout(advanceTutorial, 2000)

#Setup
#----------
canvas.width = window.innerWidth
canvas.height = window.innerHeight

buttonWidth = 50
buttonHeight = canvas.height / 9

gridSpacing = 15
border = 3

gridWidth = canvas.width / gridSpacing
gridHeight = canvas.width / gridSpacing

mouseX = 0
mouseY = 0

ages = randomGrid()
rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]]

root.helpShown = false
root.paused = false

#Arrange rule buttons
$("#ruleButton00").offset({position:absolute, top:0, left:0})

context.font="20px Georgia";
draw()