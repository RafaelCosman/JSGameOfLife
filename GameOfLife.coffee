###
This is Game Of Life
Author Rafael Cosman
This code is Maddy approved.
###

root = exports ? this

#Get the canvas
#---------------
canvas = document.getElementById "myCanvas"
context = canvas.getContext "2d"


@setDelay = (newDelay) ->
	root.delay = newDelay

#Wrappers
#---------------
background = ->
	bigNum = 100000
	context.fillRect -bigNum, -bigNum, 2*bigNum, 2*bigNum



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
			Math.floor(Math.random() + 0.4)
@randomizeGrid = ->
	for x in [0...gridWidth]
		for y in [0...gridHeight]
			ages[x][y] = Math.floor(Math.random() + 0.4)

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
				hue *= 0.2
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
		context.fillStyle = rgba(255, 255, 255, 0.7)
		context.fillRect(mouse.getGridX() * gridSpacing, mouse.getGridY() * gridSpacing, gridSpacing-border, gridSpacing-border)
	
	setTimeout(draw, root.delay)

#Setup
#----------
root.delay = 0

#Tutorial stuff:
root.userHasCreatedCells = false
root.userHasChangedRules = false
root.userHasDeletedCells = false

setTimeout (-> setVisible "#tutorialCreateCells"), 1000

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

root.helpShown = false
root.paused = false

context.font="20px Georgia";
draw()