###
This file only contains little helper function that I probably shouldn't really need anyway.
If these can all be replaced by builtins, that's be great.
###

getBinaryThingey = (num) ->
	if num == 0
		return 0
	else
		return 1
		
incModeDead = (arr, x, y) ->
	if x >= 0 and y >= 0 and x < arr.length and y < arr[0].length
		arr[x][y]++
incModeWrap = (arr, x, y) ->
	arr[(x + arr.length) % arr.length][(y + arr[1].length) % arr[1].length]++
inc = incModeWrap

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