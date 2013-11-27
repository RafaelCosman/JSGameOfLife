###
This file only contains little helper function that I probably shouldn't really need anyway.
If these can all be replaced by builtins, that's be great.
###

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

### --------------------------------------------
     Begin io.coffee
-------------------------------------------- ###

###
This file contains everything that uses JQuery
###

$ = jQuery

rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]]

($ "#ruleTable").append """
<tr>
	<th title="This column determines how dead cells can come to life" style="height:30px;" class="tableHeader">Dead</th>
	<th title="This column determines how live cells can stay alive" style="height:30px;" class="tableHeader">Alive</th>
</tr>
"""

for numNeighbors in [0...8+1]
	deadClasses = "ruleButton"
	if rules[0][numNeighbors]
		deadClasses += " down"

	liveClasses = "ruleButton"
	if rules[1][numNeighbors]
		liveClasses += " down"

	($ "#ruleTable").append """
		<tr>
			<td title="When this button is illuminated, dead cells with """ + numNeighbors + """ neighbors will come to life.\nWhen this button is dark, dead cells with """ + numNeighbors + """ neighbors will stay dead." type="button" class=" """ + deadClasses + """ " onclick="toggleRule(0, """ + numNeighbors + """)">""" + numNeighbors + """</td>
			<td title="When this button is illuminated, live cells with """ + numNeighbors + """ neighbors will stay alive.\nWhen this button is dark, live cells with """ + numNeighbors + """ neighbors will die." type="button" class=" """ + liveClasses + """ " onclick="toggleRule(1, """ + numNeighbors + """)">""" + numNeighbors + """</td>
		</tr>
	"""

###
jQueryKey should be a string like
#myID
###
setVisible = (jQueryKey) ->
	($ jQueryKey).css {visibility: "visible", opacity: 0}
	($ jQueryKey).animate {opacity: 1.0}
setHidden = (jQueryKey) ->
	($ jQueryKey).animate {opacity: 0}, (-> ($ jQueryKey).css {visibility: "hidden"})

#Button presses
@help = ->
	root.helpShown = !root.helpShown
	root.paused = root.helpShown
	
	if root.helpShown
		setVisible ".helpBox"
	else
		setHidden ".helpBox"

<<<<<<< HEAD
@pause = ->
	root.paused = !root.paused

	($ "#pauseButton").html "Play"

=======
>>>>>>> develop
@toggleRule = (x, y) ->
	rules[x][y] = !rules[x][y]

@moreCells = ->
	root.gridSpacing *= .9
	border *= .9
	
	root.gridWidth = canvas.width / gridSpacing
	root.gridHeight = canvas.width / gridSpacing
	extendAges()

@fewerCells = ->
	root.gridSpacing /= .9
	border /= .9

	root.gridWidth = canvas.width / gridSpacing
	root.gridHeight = canvas.width / gridSpacing
	
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
	
makeCells = (event) ->
	mouse.x = event.pageX
	mouse.y = event.pageY

	gridX = mouse.getGridX()
	gridY = mouse.getGridY()
	
	#If dragging with the left mouse button, create cells
	if mouse.down[1]
		if not root.userHasCreatedCells
			root.userHasCreatedCells = true
			setHidden "#tutorialCreateCells"
			if not root.userHasChangedRules
				setVisible "#tutorialChangeRules"

		for x in [gridX-root.brushSize...gridX+1+root.brushSize]
			for y in [gridY-root.brushSize...gridY+1+root.brushSize]
				inc(ages, x, y)
				
	#If dragging with the right mouse button, kill cells
	if mouse.down[3]
		root.userHasDeletedCells = true

		for x in [gridX-root.brushSize...gridX+1+root.brushSize]
			for y in [gridY-root.brushSize...gridY+1+root.brushSize]
				zero(ages, x, y)	

#Keyboard io
#------------------------
#I want to add space clears board

extendAges = () ->
	root.ages = randomGrid()

#Window Resize event
$(window).resize ->
	canvas.width = window.innerWidth
	canvas.height = window.innerHeight

	buttonWidth = 50
	buttonHeight = canvas.height / 9

	root.gridWidth = canvas.width / gridSpacing
	root.gridHeight = canvas.width / gridSpacing

	extendAges()

$ ->
	($ ".ruleButton").click ->
		($ this).toggleClass "down"

		if not root.userHasChangedRules
			root.userHasChangedRules = true
			setHidden "#tutorialChangeRules"
			
			setTimeout (-> setVisible "#tutorialLeftCol"), 1000
			setTimeout (-> setHidden "#tutorialLeftCol"), 5000
			
			setTimeout (-> setVisible "#tutorialRightCol"), 5000
			setTimeout (-> setHidden "#tutorialRightCol"), 9000
	###
	($ "#ruleTableMinButton").click ->
		($ this).toggleClass "down"
		($ "#ruleTableDiv").slideToggle()
	###
	#These are all of the minimization buttons
	($ "#speedOptionsMinButton").click ->
		($ this).toggleClass "down"
		($ "#speedOptionsDiv").slideToggle()
	($ "#gridSizeOptionsMinButton").click ->
		($ this).toggleClass "down"
		($ "#gridSizeOptionsDiv").slideToggle()
	($ "#brushOptionsMinButton").click ->
		($ this).toggleClass "down"
		($ "#brushOptionsDiv").slideToggle()


	$("#myCanvas").mousedown (event) ->
		mouse.down[event.which] = true
		makeCells(event)
		
	$("#myCanvas").mouseup (event) ->
		mouse.down[event.which] = false

		if root.help
			root.help = false
			root.paused = false

	$("#myCanvas").mousemove (event) ->
		makeCells(event)

	#Pause button
	($ "#pauseButton").click ( ->
		root.paused = not root.paused

		if root.paused
			($ this).html "Play"
		else
			($ this).html "Pause"
		)

	#Brush options
	($ "#1x1").click ( ->
		root.brushSize = 0
		)
	($ "#3x3").click ( ->
		root.brushSize = 1
		)
	($ "#5x5").click ( ->
		root.brushSize = 2
		)


### --------------------------------------------
     Begin GameOfLife.coffee
-------------------------------------------- ###

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
	for x in [0...root.gridWidth]
		for y in [0...root.gridHeight]
			0
@clearGrid = ->
	for x in [0...root.gridWidth]
		for y in [0...root.gridHeight]
			root.ages[x][y] = 0


randomGridWithDimensions = (width, height) ->
	console.log(root.gridWidth)

	for x in [0...width]
		for y in [0...height]
			Math.floor(Math.random() + 0.4)
randomGrid = ->
	randomGridWithDimensions(root.gridWidth, root.gridHeight)
	
@randomizeGrid = ->
	for x in [0...root.gridWidth]
		for y in [0...root.gridHeight]
			root.ages[x][y] = Math.floor(Math.random() + 0.4)

#Run
#----------------
computeNextGeneration = ->
	numNeighbors = makeNewGrid()
	
	#Count up the number of neighbours each cell has
	for x in [0...root.gridWidth]
		for y in [0...root.gridHeight]
			if root.ages[x][y] != 0
				inc numNeighbors, x-1, y-1
				inc numNeighbors, x-1, y
				inc numNeighbors, x-1, y+1
				
				inc numNeighbors, x, y-1
				inc numNeighbors, x, y+1
				
				inc numNeighbors, x+1, y-1
				inc numNeighbors, x+1, y
				inc numNeighbors, x+1, y+1
	
	#Apply the current rules
	for x in [0...root.gridWidth]
		for y in [0...root.gridHeight]
			if rules[getBinaryThingey(root.ages[x][y])][numNeighbors[x][y]]
				root.ages[x][y]++
			else
				root.ages[x][y] = 0

drawCells = ->
	#Display the cells to the screen
	timeModifier = new Date().getTime()/10000
	
	for x in [0...root.gridWidth]
		for y in [0...root.gridHeight]
			age = root.ages[x][y]
			
			if age != 0
				hue = Math.sqrt(age)
				hue *= 0.2
				context.fillStyle = HSVtoRGB((hue + timeModifier) % 1, 1, 1)
				context.fillRect(root.gridSpacing * x, root.gridSpacing * y, root.gridSpacing - border, root.gridSpacing - border)

draw = -> 
	if !root.paused
		computeNextGeneration()
			
	#Clear the background
	context.fillStyle = rgb(0, 0, 0)
	background()
	
	drawCells()
	
	#Highlight the cell the mouse is over
	if root.ages[mouse.getGridX()][mouse.getGridY()] != 0
		context.fillStyle = rgba(255, 255, 255, 0.7)
		context.fillRect(mouse.getGridX() * root.gridSpacing, mouse.getGridY() * root.gridSpacing, root.gridSpacing-border, root.gridSpacing-border)
	
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

root.gridSpacing = 15
border = root.gridSpacing * .2

root.gridWidth = canvas.width / root.gridSpacing
root.gridHeight = canvas.width / root.gridSpacing

mouseX = 0
mouseY = 0

root.ages = randomGrid()

root.brushSize = 2 #this is the size of the users brush to kill or create cells

root.helpShown = false
root.paused = false

context.font="20px Georgia";
draw()