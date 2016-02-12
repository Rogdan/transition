local ObjectState

local width = display.contentWidth
local height = display.contentHeight

local startX = width/6
local appendToX = width/4

local currentY = width/24
local currentX = startX

local currentScreenObject = display.newCircle(width/2, height/2, width/10)
local newFigure = display.newRect(width/2, height/2, width/5, width/5)
local currentTransition
local status

function initObjectState()
	ObjectState = {
		blink = blinkFunc,
		dissolve = dissolveFunc,
		fadein = fadeInFunc,
		fadeOut = fadeOutFunc,
		moveBy = moveByFunc,
		moveTo = moveToFunc,
		scaleBy = scaleByFunc,
		scaleTo = scaleToFunc,
	}
end

function initButtons()
	local counter = 0;
	for k, v in pairs(ObjectState) do
		initOneButton(k)
		
		counter = counter + 1;
		if(counter == 4) then
			currentY = display.contentHeight - display.contentWidth/24
			currentX = startX
		else
			currentX = currentX + appendToX
		end
	end
	
	local refreshButton = display.newText("Refresh", startX, height/2, native.systemFont, width/24)
	refreshButton:addEventListener("touch", cancelEvent)
	refreshButton:setFillColor( 0.72, 0.9, 0.16, 0.78 )
end

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
end

function eventForButton(event)
	if event.phase == "ended" then
		ObjectState[event.target.text]()
	end	
end

blinkFunc = function()
	currentTransition = transition.blink( currentScreenObject, { time=1000, tag = "blink",
		onStart = startEvent, onComplete = endEvent} )
end

dissolveFunc = function()
	currentTransition = transition.dissolve(currentScreenObject, newFigure, 1000, 0)
	currentScreenObject, newFigure = newFigure, currentScreenObject
end

fadeOutFunc = function()
	currentTransition = transition.fadeOut( currentScreenObject, { time=2000,
		onCancel = cancelEvent, onStart = startEvent, onComplete = endEvent } )
end

fadeInFunc = function()
	currentTransition = transition.fadeIn( currentScreenObject, { time=2000, onCancel = cancelEvent,
		onStart = startEvent, onComplete = endEvent} )
end

moveByFunc = function()
	local randomX = math.random(width)
	local randomY = math.random(height)
	
	currentTransition = 
		transition.moveBy(currentScreenObject,{x = randomX, y = randomY, time = 2000,
		onCancel = cancelEvent, onStart = startEvent, onComplete = endEvent})
end

moveToFunc = function()
	local randomX = math.random(width)
	local randomY = math.random(height)
	
	currentTransition = 
		transition.moveTo(currentScreenObject,{x = randomX, y = randomY, time = 2000,
		onCancel = cancelEvent, onStart = startEvent, onComplete = endEvent})
end

scaleByFunc = function()
	currentTransition = 
		transition.scaleBy(currentScreenObject, {xScale=0.5, yScale=0.5, time=2000,
		onCancel = cancelEvent, onStart = startEvent, onComplete = endEvent})
end

scaleToFunc = function()
	currentTransition = 
		transition.scaleBy(currentScreenObject, {xScale=0.5, yScale=0.5, time=2000,
		onCancel = cancelEvent, onStart = startEvent, onComplete = endEvent})
end

function cancelEvent(event)
	transition.cancel("blink")
	returnOnStartPosition(currentScreenObject)
	returnOnStartPosition(newFigure)
	fadeInFunc();
end

function returnOnStartPosition(object)
	object.x = width/2
	object.y = height/2
	object.width = width/5
	object.height = width/5
end

function startEvent(event)
	status.text = "status: started"
end

function endEvent()
	status.text = "status: ended"
end

function initStatus()
	status = display.newText("Status", width*3/4, height/4, native.systemFont, width/21)
	status:setFillColor(0.2, 0.7, 0.4)
end

function initResumeButton()
	resumeButton = display.newText("Resume", width*4/5, height/2, native.systemFont, width/21)
	resumeButton:setFillColor(0.2, 0.7, 0.4)
	resumeButton:addEventListener("touch", resumeEvent)
end

function resumeEvent(event)
	if event.phase == "ended" then
		transition.resume(currentTransition)
		status.text = "status: resume"
	end
end

function initPauseButton()
	pauseButton = display.newText("Pause", width*3/5, height/2, native.systemFont, width/21)
	pauseButton:setFillColor(0.2, 0.7, 0.4)
	pauseButton:addEventListener("touch", pauseEvent)
end

function pauseEvent(event)
	if event.phase == "ended" then
		transition.pause(currentTransition)
		status.text = "status: pause"
	end
end

function main()
	initObjectState()
	initButtons()
	initPauseButton()
	initResumeButton()
	initStatus()
	dissolveFunc()
end

--run main
main()