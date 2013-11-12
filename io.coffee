$ = jQuery

($ "body").append "<p>test</p>"

###
jQueryKey should be a string like
#myID
###
setVisible = (jQueryKey) ->
	($ jQueryKey).css "visibility", "visible"
setHidden = (jQueryKey) ->
	($ jQueryKey).css "visibility", "hidden"

#Button presses
@help = ->
	root.helpShown = !root.helpShown
	root.paused = root.helpShown
	
	if helpShown
		setVisible ".helpBox"
	else
		setHidden ".helpBox"

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
		if not root.userHasCreatedCells
			root.userHasCreatedCells = true
			setHidden "#tutorialCreateCells"
			if not root.userHasChangedRules
				setVisible "#tutorialChangeRules"

		for x in [gridX-d...gridX+1+d]
			for y in [gridY-d...gridY+1+d]
				inc(ages, x, y)
				
	#If dragging with the right mouse button, kill cells
	if mouse.down[3]
		root.userHasDeletedCells = true

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

($ ".ruleButton").click ->
	($ this).toggleClass "down"

	if not root.userHasChangedRules
		root.userHasChangedRules = true
		setHidden "#tutorialChangeRules"
		
		setTimeout (-> setVisible "#tutorialLeftCol"), 1000
		setTimeout (-> setHidden "#tutorialLeftCol"), 5000
		
		setTimeout (-> setVisible "#tutorialRightCol"), 5000
		setTimeout (-> setHidden "#tutorialRightCol"), 9000