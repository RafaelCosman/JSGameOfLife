###
This file contains everything that uses JQuery
###

$ = jQuery

rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]]

neighborhood =
	[[false, false, false, false, false],
	 [false, true,  true,  true, false],
	 [false, true,  false, true, false],
	 [false, true,  true,  true, false],
	 [false, false, false, false, false]]

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

@toggleRule = (x, y) ->
	rules[x][y] = not rules[x][y]
@toggleNeighborhood = (x, y) ->
	neighborhood[x][y] = not neighborhood[x][y]

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
				inc ages, x, y
				
	#If dragging with the right mouse button, kill cells
	if mouse.down[3]
		root.userHasDeletedCells = true

		for x in [gridX-root.brushSize...gridX+1+root.brushSize]
			for y in [gridY-root.brushSize...gridY+1+root.brushSize]
				zero ages, x, y

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
	# ---------- Make the header of the rule table ------------
	($ "#ruleTable").append """
	<tr>
		<th title="This column determines how dead cells can come to life" style="height:30px;" class="tableHeader">Dead</th>
		<th title="This column determines how live cells can stay alive" style="height:30px;" class="tableHeader">Alive</th>
	</tr>
	"""

	# ----------- Make the body of the ruletable ------------
	for numNeighbors in [0...8+1]
		deadClasses = "ruleButton"
		if rules[0][numNeighbors]
			deadClasses += " down"

		liveClasses = "ruleButton"
		if rules[1][numNeighbors]
			liveClasses += " down"

		($ "#ruleTable").append """
			<tr>
				<td title="When this button is illuminated, dead cells with """ + numNeighbors + """ neighbors will come to life.\nWhen this button is dark, dead cells with """ + numNeighbors + """ neighbors will stay dead."
				type="button" class=" """ + deadClasses + """ " onclick="toggleRule(0, """ + numNeighbors + """)">""" + numNeighbors + """</td>
				<td title="When this button is illuminated, live cells with """ + numNeighbors + """ neighbors will stay alive.\nWhen this button is dark, live cells with """ + numNeighbors + """ neighbors will die."
				type="button" class=" """ + liveClasses + """ " onclick="toggleRule(1, """ + numNeighbors + """)">""" + numNeighbors + """</td>
			</tr>
		"""

	# ---------- Make the neighborhood options table ---------------
	tableBody = ($ "#neighborhoodOptionsTable>tbody")
	for y in [0...maxNeighborhoodSize].reverse()
		tableBody.append """
			<tr>
		"""

		for x in [0...maxNeighborhoodSize].reverse()
			classes = "neighborhoodButton"
			if neighborhood[x][y]
				classes += " down"

			tableBody.append """
				<td type="button" class=" """ + classes + """ " onclick="toggleNeighborhood( """ + x + """,""" + y + """ )"></td>
			"""

		tableBody.append """
			</tr>
		"""

	# ------------ Add the rule button click listeners -----------
	($ ".ruleButton").click ->
		if not root.userHasChangedRules
			root.userHasChangedRules = true
			setHidden "#tutorialChangeRules"
			
			time = 1000

			setTimeout (-> setVisible "#tutorialLeftCol"), time
			setTimeout (-> setHidden "#tutorialLeftCol"), time += 4000
			
			setTimeout (-> setVisible "#tutorialRightCol"), time
			setTimeout (-> setHidden "#tutorialRightCol"), time += 4000

			setTimeout (-> setVisible "#tutorialRow"), time
			setTimeout (-> setHidden "#tutorialRow"), time += 4000

			setTimeout (-> setVisible "#tutorialMouseOver"), time
			setTimeout (-> setHidden "#tutorialMouseOver"), time += 4000

	###
	($ "#ruleTableMinButton").click ->
		($ this).toggleClass "down"
		($ "#ruleTableDiv").slideToggle()
	###
	# ------------ These are all of the minimization buttons -------------
	($ ".minButton").click ->
		($ this).parent().children("div").slideToggle()

	# ---------- Canvas listeners -----------
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

	# ------------- Pause button ------------
	($ "#pauseButton").click ( ->
		root.paused = not root.paused

		if root.paused
			($ this).html "Play"
		else
			($ this).html "Pause"
		)

	# ------------ Brush options --------------
	($ "#1x1").click ( ->
		root.brushSize = 0
		)
	($ "#2x2").click ( ->
		root.brushSize = .5 #doesn't work
		)
	($ "#3x3").click ( ->
		root.brushSize = 1
		)
	($ "#5x5").click ( ->
		root.brushSize = 2
		)
	($ "#9x9").click ( ->
		root.brushSize = 4
		)

	# --------------- Toggles ---------------
	($ ".neighborhoodButton,.minButton,.ruleButton").addClass "toggle"
	($ ".toggle").click ( ->
		($ this).toggleClass "down"
		)

	# ------------- Radio Buttons ---------
	($ ".radio").click ( -> 
		($ this).siblings().removeClass "down"
		($ this).addClass "down"
		)

	# ------------ Initialization :D --------------
	($ "#5x5").click()
	($ "#fast").click()
	
