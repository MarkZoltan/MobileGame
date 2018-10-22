---------------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require( "physics" )
physics.start()
halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5
local bg = display.newImage("ima/sky.jpg.jpg",halfW,halfH)
score = 0
scoreText = display.newText(score, halfW, 50)
local bgMusic = audio.loadStream("music/music.mp3");
audio.play(bgMusic, {loops =- 1});
audio.setVolume(0.2)

local function balloonTouched(event)
    if ( event.phase == "began" ) then
	Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
	score = score + 1
	scoreText.text = score
    end
end
local function bombTouched(event)
    if ( event.phase == "began" ) then
        Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
        score = math.floor(score * 0.5)
        scoreText.text = score
    end
end
local function offscreen(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	end
end
local function addNewBalloonOrBomb()
	local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	if(math.random(1,5)==1) then
		-- Boooooommmmbeeee!!!
		local bomb = display.newImage( "ima/bomb.png", startX, -100)
		bomb:scale(0.3,0.3)
		physics.addBody( bomb )
		bomb.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", bomb )
		bomb:addEventListener( "touch", bombTouched )
	else
		-- Baloane!!
		local balloon = display.newImage( "ima/balloon.png", startX, -50)
		balloon:scale(0.2,0.2)
		physics.addBody( balloon )
		balloon.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", balloon )
		balloon:addEventListener( "touch", balloonTouched )
	end
end
local widget = require( "widget" )
local button1
local button2
-- Function to handle button events
local function handleButtonEvent( event )
	
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
		display.remove( button1 )
		button1= nil
		button2.x=25
		button2.y=25
		addNewBalloonOrBomb()
timer.performWithDelay( 1000, addNewBalloonOrBomb, 0 )
    end
end

button1 = widget.newButton(
    {
        width = 140,
        height = 140,
        defaultFile = "ima/play.png",
        overFile = "ima/play.png",
        label = "button",
        onEvent = handleButtonEvent
    }
)
button2=widget.newButton(
	{
		width = 50,
        height = 50,
        defaultFile = "ima/stop.png",
		 x=160,
		 y=400,
	}
)

local function closeapp()
       if  system.getInfo("platformName")=="Android" then
           native.requestExit()
       else
           os.exit() 
      end
		
end

function button2:tap( event )


     timer.performWithDelay(50,closeapp)
end    


button2:addEventListener( "tap", button2 )

button1.x = display.contentCenterX
button1.y = display.contentCenterY


button1:setLabel( "Play" )

