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
background = ->
	bigNum = 100000
	context.fillRect(-bigNum, -bigNum, 2*bigNum, 2*bigNum)

"""
jQueryKey should be a string like
#myID
"""
setVisible = (jQueryKey) ->
	$(jQueryKey).css("visibility", "visible")
setHidden = (jQueryKey) ->
	$(jQueryKey).css("visibility", "hidden")

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
	
	if helpShown
		setVisible(".helpBox")
	else
		setHidden(".helpBox")

@pause = ->
	root.paused = !root.paused

@toggleRule = (x, y) ->
	rules[x][y] = !rules[x][y]
	
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
			if not userHasChangedRules
				userHasChangedRules = true
				setHidden("#tutorialChangeRules")
				
				setTimeout(setVisible("#tutorialLeftCol"), 1000)
				setTimeout(setHidden("#tutorialLeftCol"), 3000)
				
				setTimeout(setVisible("#tutorialRightCol"), 3000)
				setTimeout(setHidden("#tutorialRightCol"), 5000)

				setTimeout(setVisible("#tutorial"))

			rules[mouse.getButtonX()][mouse.getButtonY()] = !rules[mouse.getButtonX()][mouse.getButtonY()]

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
		userHasCreatedCells = true
		setHidden("#tutorialCreateCells")
		if not userHasChangedRules
			setVisible("#tutorialChangeRules")

		for x in [gridX-d...gridX+1+d]
			for y in [gridY-d...gridY+1+d]
				inc(ages, x, y)
				
	#If dragging with the right mouse button, kill cells
	if mouse.down[3]
		userHasDeletedCells = true

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
	
	setTimeout(draw, 0)

#Setup
#----------
$ ->
  $(".ruleButton").click ->
    $(this).toggleClass "down"
    console.log("TEST")

#Tutorial stuff
userHasCreatedCells = false
userHasChangedRules = false
userHasDeletedCells = false

setTimeout(setVisible("#tutorialCreateCells"), 1000)

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
$("#ruleTable").item(1 * 9 + 3).click()
###
for x in [0...1+1]
	for y in [0...9+1]
		if rules[x][y]
			$("#ruleTable").cells[x * 9 + y]
			console.log(x * 9 + y)
###
root.helpShown = false
root.paused = false

context.font="20px Georgia";
draw()