local active = false
local fine = true

SPEEEED = 0
Amount = 3
ease = 'sineIn'

zoomNumber = 1
zoomDodge = 1.2

actualZoom = 0.85

require('mods/scripts/t_tweeningService');

function onUpdatePost()
    zoomDodge = zoomNumber + 0.2
    update_tweens()
	if get_tween_value("scale") then
        setProperty('dodge.scale.x', get_tween_value("scale"));
        setProperty('dodge.scale.y', get_tween_value("scale"));
    end
    if mustHitSection then
        zoomNumber = actualZoom
    else
        zoomNumber = actualZoom - 0.15
    end
    if curStep == 416 then
        actualZoom = 0.75
    end
    if curStep == 664 then
        actualZoom = 0.85
    end
    if curStep == 1120 then
        actualZoom = 0.75
    end
    if curStep == 1408 then
        actualZoom = 0.85
    end
    if curStep == 1456 then
        actualZoom = 0.75
    end
    --MAYBES
    if curStep == 1568 then
        actualZoom = 0.85
    end
    if curStep == 1584 then
        actualZoom = 0.75
    end
    if curStep == 1600 then
        actualZoom = 0.85
    end
    if curStep == 1616 then
        actualZoom = 0.75
    end
    --end of maybes
    if curStep == 1712 then
        actualZoom = 0.85
    end
end	

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if not isSustainNote then
        if noteData == 0 then
            doTweenAngle('gs','camGame',Amount,SPEEEED,ease)
        elseif noteData == 1 then
            doTweenZoom('zs','camGame',zoomNumber - 0.035,SPEEEED,ease)
        elseif noteData == 2 then
            doTweenZoom('zs','camGame',zoomNumber + 0.035,SPEEEED,ease)
        else
            doTweenAngle('gs','camGame',-Amount,SPEEEED,ease)
        end
    end
end

function onEvent(name, value1, value2)
    if name == 'beatDodge' then
        if getPropertyFromClass('ClientPrefs', 'mechanics', true) then
            active = true
            beatThing = curBeat % 2
        end
    end
end

function math.clamp(x,min,max)return math.max(min,math.min(x,max))end

function onBeatHit()
    if active then
        if curBeat % 2 == math.clamp(beatThing + 1,0,1) then
            setProperty('time.alpha',1)
        else
            doTweenAlpha('hideTime','time',0,0.3,'linear')
        end
    end
end

function onUpdate()
    if not (string.find(getProperty('dad.animation.curAnim.name'), 'idle') == nil) then
        doTweenAngle('gs2','camGame',0,SPEEEED,'linear')
        doTweenZoom('zs','camGame',zoomNumber,SPEEEED,'linear')
    end
    --setProperty(botPlay,true)
    if botPlay and getProperty('time.alpha') == 1 and active then
        
        if curBeat % 2 == math.clamp(beatThing + 1,0,1) then
            active = false
            tween_value("scale", 0.75, 1, 0.1, 'linear')
            fine = true
            playSound('claw',1)
            triggerEvent('Play Animation','claw','Dad')
            triggerEvent('Play Animation','dodge','BF')
            cancelTimer("active")
            cameraShake("hud", 0.01, 0.2)
            cameraShake("game", 0.01, 0.2)
            cameraShake("camIcon", 0.02, 0.2)
        end
    end
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and active then
        if getProperty('time.alpha') >= 0.7 and getProperty('time.alpha') <= 1 then
            active = false
            tween_value("scale", 0.75, 1, 0.1, 'linear')
            fine = true
            playSound('claw',1)
            triggerEvent('Play Animation','claw','Dad')
            triggerEvent('Play Animation','dodge','BF')
            cancelTimer("active")
            setProperty('time.alpha',0)
            cameraShake("hud", 0.01, 0.2)
            cameraShake("camIcon", 0.01, 0.2)
            cameraShake("game", 0.02, 0.2)
        else
            cancelTimer("active")
            active = false
            fine = true
            setProperty('time.alpha',0)
            playSound('claw',1)
            triggerEvent('Play Animation','claw','Dad')
            setProperty('health',getProperty('health')-1)
            doTweenAlpha('hello2', 'dodge', 0, 0.5, 'linear');
            doTweenZoom('bruh', 'camGame', zoomNumber, 0.3, 'linear')
            setProperty('defaultCamZoom', zoomNumber)
        end
    end
    if active then
        if fine then
            fine = false
            tween_value("scale", 1.5, 1, 0.2, 'linear')
            doTweenAlpha('hello1', 'dodge', 1, 0.2, 'linear');
            runTimer("active", 1)
            doTweenZoom('bruh', 'camGame', zoomDodge, 0.2, 'linear')
            setProperty('defaultCamZoom', zoomDodge)
        end
    else
        doTweenAlpha('hello1', 'dodge', 0, 0.2, 'linear');
        doTweenAlpha('hello12', 'time', 0, 0.2, 'linear');

        doTweenZoom('bruh', 'camGame', zoomNumber, 0.2, 'linear')
        setProperty('defaultCamZoom', zoomNumber)
    end
end



function onTimerCompleted(tag, loop, loopsLeft)
    if tag == "active" then
        active = false
        fine = true
        playSound('claw',1)
        triggerEvent('Play Animation','claw','Dad')
        setProperty('health',getProperty('health')-1)
        doTweenAlpha('hello2', 'dodge', 0, 0.5, 'linear');
        doTweenZoom('bruh', 'camGame', 0.7, 0.3, 'linear')
        setProperty('defaultCamZoom', 0.7)
    end
end

function onCreate()
    SPEEEED = 0.5

    precacheImage("dodge2")

    makeLuaSprite('time', 'dodge2', 0, 500)
    setObjectCamera('time', 'camOther')

    addLuaSprite('time', true)
    screenCenter('time', 'x')
    setProperty('time.scale.x', 1);
    setProperty('time.scale.y', 1);
    setProperty('time.alpha',0)

    precacheImage("unowndodge")

    makeLuaSprite('dodge', 'unowndodge', 0, 500)
    setObjectCamera('dodge', 'camOther')

    addLuaSprite('dodge', true)
    screenCenter('dodge', 'x')
    setProperty('dodge.scale.x', 1);
    setProperty('dodge.scale.y', 1);
    setProperty('dodge.alpha',0)
end