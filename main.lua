local ObjectState = {
	blink = "Blink",
	dissolve = "Dissolve",
	fadein = "Fadein",
	fadeOut = "Fade out",
	moveBy = "Move by",
	moveTo = "Move to",
	scaleBy = "Scale by",
	scaleTo = "Scale to"
}

local width = display.contentWidth
local height = display.contentHeight

local startX = width/6
local appendToX = width/4

local currentY = width/24
local currentX = startX

local currentScreenObject = display.newCircle(width/2, height/2, width/10)
local newFigure = display.newRect(width/2, height/2, width/5, width/5)

local function initButtons()
	local counter = 0;
	for k, v in pairs(ObjectState) do
		initOneButton(v)
		
		counter = counter + 1;
		if(counter == 4) then
			currentY = display.contentHeight - display.contentWidth/24
			currentX = startX
		else
			currentX = currentX + appendToX
		end;
	end;
	
	local refreshButton = display.newText("Refresh", startX, height/2, native.systemFont, width/24)
	refreshButton:addEventListener("touch", eventForButton)
	refreshButton:setFillColor( 0.72, 0.9, 0.16, 0.78 )
end;

function initOneButton(buttonText)		
	options = 
	{
		text = buttonText,
		x = currentX,
		y = currentY,
		width = appendToX,     --required for multi-line and alignment
		font = native.systemFont,   
		fontSize = width/21
	}
	
	local button = display.newText(options)
	button:setFillColor( 1, 0.2, 0.2 )
	button:addEventListener("touch", eventForButton)
end;

function eventForButton(event)
	if event.phase == "ended" then
		chooseEventByButtonText(event.target.text)
	end;	
end;

function chooseEventByButtonText(text)
	if text == "Blink" then
		blink()
	elseif text == "Dissolve" then
		dissolve()
	elseif text == "Fadein" then
		fadeIn()
	elseif text == "Fade out" then
		fadeOut()
	elseif text == "Move by" then
		moveBy();
	elseif text == "Move to" then
		moveTo()
	elseif text == "Scale by" then
		scaleBy()
	elseif text == "Scale to" then
		scaleTo()
	elseif text == "Refresh" then
		cancelEvent()
	end
end;

function blink()
	transition.blink( currentScreenObject, { time=1000, tag = "blink"} )
end;

function dissolve()
	transition.dissolve(currentScreenObject, newFigure, 1000, 0)
	currentScreenObject, newFigure = newFigure, currentScreenObject
end;

function fadeOut()
	transition.fadeOut( currentScreenObject, { time=2000, onCancel = cancelEvent } )
end;

function fadeIn()
	transition.fadeIn( currentScreenObject, { time=2000, onCancel = cancelEvent } )
end;

function moveBy()
	local randomX = math.random(width)
	local randomY = math.random(height)
	
	transition.moveBy(currentScreenObject,{x = randomX, y = randomY, time = 2000, onCancel = cancelEvent})
end;

function moveTo()
	local randomX = math.random(width)
	local randomY = math.random(height)
	
	transition.moveTo(currentScreenObject,{x = randomX, y = randomY, time = 2000, onCancel = cancelEvent})
end;

function scaleBy()
	transition.scaleBy(currentScreenObject, {xScale=0.5, yScale=0.5, time=2000, onCancel = cancelEvent})
end;

function scaleTo()
	transition.scaleBy(currentScreenObject, {xScale=0.5, yScale=0.5, time=2000, onCancel = cancelEvent})
end;

function cancelEvent(event)
	transition.cancel("blink")
	returnOnStartPosition(currentScreenObject)
	returnOnStartPosition(newFigure)
	fadeIn();
end;

function returnOnStartPosition(object)
	object.x = width/2
	object.y = height/2
	object.width = width/5
	object.height = width/5
end;

function main()
	initButtons()
	dissolve();
end;

--run main
main()