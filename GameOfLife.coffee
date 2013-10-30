###
This is Game Of Life
Author Rafael Cosman
###

#Get the canvas
#---------------
c=document.getElementById("myCanvas");
context=c.getContext("2d");

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
			Math.floor(Math.random() + .1)
			
#Run
#----------------
draw = () -> 
	numNeighbors = makeNewGrid()
	
	#Count up the number of neighbors each cell has
	for x in [0...gridWidth-1]
		for y in [0..gridHeight-1]
			if ages[x][y] != 0
				numNeighbors[x-1][y-1]++
				numNeighbors[x-1][y]++
				numNeighbors[x-1][y+1]++
				
				numNeighbors[x1][y-1]++
				numNeighbors[x1][y+1]++
				
				numNeighbors[x+1][y-1]++
				numNeighbors[x+1][y]++
				numNeighbors[x+1][y+1]++
	
	console.log(ages)
	console.log(rules)
	console.log(numNeighbors)
	
	#Apply the current rules
	for x in [0...gridWidth-1]
		for y in [0..gridHeight-1]
			println(ages[x][y])
			if rules[ages[x][y] != 0][numNeighbors[x][y]]
				ages[x][y]++
			else
				ages[x][y] = 0
			
	#Display the cells to the screen
	background(0)

	for x in [0...gridWidth-1]
		for y in [0..gridHeight-1]
			save()

			translate(10 * x, 10 * y)
			
			if ages[x][y] != 0
				fillStyle("FFFF00")
				fillRect(5, 5)

			restore()

	setTimeout(draw, 1000)
			
#Setup
#----------
gridWidth = 300
gridHeight = 300

context.shadowBlur = 20

ages = makeNewGrid()
rules = [[false, false, false, true, false, false, false, false, false], [false, false, true, true, false, false, false, false, false]]

draw()
