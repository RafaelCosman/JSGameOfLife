#Classes
#-----------------
class Circle
    constructor: (@loc, @radius, @fillColor) ->
        
    mouseIsOver: () ->
        getMouse().dist(@getLoc()) < @getRadius()
        
    getLoc: () ->
        @loc
        
    getRadius: () ->
        @radius
        
    show: () ->
        if @mouseIsOver()
            radius = @getRadius() * 1.1
        else
            radius = @getRadius()
        
        #first make a drop-shadow
        pushMatrix()
        translate(1, 1)
        fill(0, 0, 0, 50)
        strokeWeight(0)
        ellipseByRadius(radius)
        popMatrix()
        
        fill(@fillColor)
        ellipseByRadius(radius)
        
        
class RunButton
    constructor: () ->
        @circle = new Circle(new PVector(1500, 100), 100, color(0, 100, 0))
        
    run: () ->
        
    show: () ->
        stroke(0)
        @circle.show()
        
        fill(100)
        text("Run all tests", 0, 0)
        
    clicked: () ->
        if @circle.mouseIsOver()
            for gameObject in currentLevel.gameObjects
                if gameObject instanceof UnitTest
                    gameObject.runTest()
            
    unclicked: () ->
        
    getLoc: () ->
        @circle.getLoc()
        
class Draggable
    constructor: () ->
        @dragging = false
        @rotating = false
        
        @indeces = new PVector(-1, random(0, 9))
        
        @circle = new Circle(computeLocationFromIndeces(@indeces), gridSquareWidth / 2 - 2 * border)
        @rotationCircle = new Circle(computeLocationFromIndeces(@indeces), gridSquareWidth / 2 - 2 * border + 20)
        
        @rotation = 0
        @offset = new PVector()
    
    run: () ->
        if @dragging
            @circle.loc.set(PVector.add(getMouse(), @offset))
            @rotationCircle.loc.set(PVector.add(getMouse(), @offset))
        if @rotating
            @rotation = @mouseAngle() + @rotationOffset
            
    clicked: () ->
        if @circle.mouseIsOver()
            @dragging = true
            @offset.set(PVector.sub(@getLoc(), getMouse()))
        else if @rotationCircle.mouseIsOver()
            @rotating = true
            @rotationOffset = @mouseAngle() - @rotation
            
    unclicked: () ->
        @dragging = false
        @rotating = false
        
        #Quantize location based on grid
        @indeces = computeIndecesFromLocation(@getLoc())
        @circle.loc = computeLocationFromIndeces(@indeces)
        
        #Quantize rotation to one of the four cardinal directions
        @rotation = Math.round(@rotation / HALF_PI) * HALF_PI
        
    mouseAngle: () ->
        heading(PVector.sub(getMouse(), @getLoc()))
        
    show: () ->
        #first draw the circle
        rotate(@rotation)
        stroke(100)
        @circle.show()
        
        #Now let's draw the arrow
        strokeWeight(10)
        stroke(0, 200, 0)
        line(0, 0, 0, -@circle.radius)
        translate(0, -@circle.radius)
        
        dx = 7
        dy = 5
        triangle(0, -5, dx, dy, -dx, dy)
        
    getLoc: () ->
        return @circle.getLoc()
        
class LogicBox extends Draggable     
    processString: (s) ->
        s
        
class CopyBox extends LogicBox
    constructor: () ->
        super
        @circle.fillColor = color(0, 0, 255)
        
    processString: (input) ->
        input += input[0]

class DeleteBox extends LogicBox
    constructor: () ->
        super
        @circle.fillColor = color(255, 0, 0)
        
    processString: (input) ->
        input.substring(1)
        
class StartBox extends LogicBox
    constructor: () ->
        super
        @circle.fillColor = color(0)
		
    processString: (input) ->
        input