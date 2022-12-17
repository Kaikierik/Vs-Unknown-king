

ratingVariable = 0

function onCreatePost()
	setProperty('camHUD.alpha',0)
	setProperty('dad.alpha',0)
	setProperty('boyfriend.alpha',0)
	setProperty('healthBar.flipX', true)
    setProperty('iconP1.flipX', true)
    setProperty('iconP2.flipX', true)
	if not middlescroll then
		for i = 0, 3 do
			setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX' .. i])
		end
		for i = 0, 3 do
            setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX' .. i])
        end
	end
	setProperty('gf.alpha',0)

	makeLuaSprite('Up_Bar', 'empty', -110, -250)
	makeGraphic('Up_Bar', 1500, 350, '000000')
	setObjectCamera('Up_Bar', 'camHUD')
	addLuaSprite('Up_Bar', false)

	makeLuaSprite('Low_Bar', 'empty', -110, 620)
	makeGraphic('Low_Bar', 1500, 350, '000000')
	setObjectCamera('Low_Bar', 'camHUD')
	addLuaSprite('Low_Bar', false)
	setPropertyFromClass('flixel.FlxG', 'autoPause', false)
end

function opponentNoteHit()
	if getPropertyFromClass('ClientPrefs', 'mechanics', true) then
		setProperty('health',getProperty('health') - 0.01)
	end
end

function onUpdatePost()
	setProperty('camIcon.alpha',getProperty('camHUD.alpha'))

    x1 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) + (150 * getProperty('iconP2.scale.x') - 150) / 2 - 26
    x2 = getProperty('healthBar.x') + (getProperty('healthBar.width') * (((100 - (100 - (getProperty('healthBar.percent'))))) * 0.01)) - (150 * getProperty('iconP1.scale.x')) / 2 - 26 * 2
    setProperty('iconP1.x', x2)
    setProperty('iconP2.x', x1)

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
        doTweenAlpha('fadeOut','Guide',0,1,'linear')
        doTweenAlpha('fadeOut2','backing',0,0.75,'linear')	
    end

	if getProperty('health') > 1.6 then
		setHealthBarColors('18161E', '31B0D1')
	else
		setHealthBarColors('292534', '31B0D1')
	end
	setProperty('debugKeysChart', null);
end

function onEvent(name, value1, value2)
    if name == 'Alt Idle Animation' then
    	if value1 == 'Dad' then
			runTimer('delay',0.2)
		end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'delay' then
		doTweenAlpha('eyego','eye',0,0.5,'linear')
	end
end

function onCreate()
	setProperty('skipCountdown', true)

	stagedir = 'maybe'
	durationlol = 0.2

	-- background shit
	makeLuaSprite('stageback', stagedir..'/bg', 0, -500);
	setScrollFactor('stageback', 0.6, 0.6)
	scaleObject('stageback',1.3,1.3)

	makeLuaSprite('ground', stagedir..'/ground', 600, -550);
	setScrollFactor('ground', 1, 1)
	scaleObject('ground',1.3,1.3)

	makeLuaSprite('moon', stagedir..'/moonsweep', 220, -550);
	setScrollFactor('moon', 0.75, 0.75)
	scaleObject('moon',1.3,1.3)

	makeLuaSprite('overlay', stagedir..'/overlay', 600, -550);
	setScrollFactor('overlay', 1, 1)
	scaleObject('overlay',1.3,1.3)
	setBlendMode('overlay','add')

	makeLuaSprite('overlay2', stagedir..'/overlayactualoverlayshader', 600, -550);
	setScrollFactor('overlay2', 1, 1)
	scaleObject('overlay2',1.3,1.3)
	setProperty('overlay2.alpha',0.3)

	makeLuaSprite('rain', stagedir..'/rain', 1000, -600);
	setScrollFactor('rain', 1.1, 1.1)
	scaleObject('rain',1.3,1.3)
	setProperty('rain.alpha',0.45)

	makeAnimatedLuaSprite('eye', 'eyes', 720, 267);
	addAnimationByPrefix('eye', 'open', 'eyes1', 24, false);
	addLuaSprite('eye', true); -- false = add behind characters, true = add over characters
	setObjectCamera('eye','camOther')
	scaleObject('eye',0.65,0.65)
	setProperty('eye.alpha',0)

	makeAnimatedLuaSprite('text', 'textbox', 0, 350);
	addAnimationByPrefix('text', 'arrive', 'appear', 24, false);
	addLuaSprite('text', true); -- false = add behind characters, true = add over characters
	setObjectCamera('text','camOther')
	scaleObject('text',0.7,0.7)
	setProperty('text.alpha',0)

	--makeSprite('backing', 'mechanobacking', nil, nil, 'camOther')
    --makeSprite('Guide', 'mechano', nil, nil, 'camOther')    
    setProperty('backing.alpha',0.6)
	setObjectOrder('backing', getObjectOrder('text') + 1)
	setObjectOrder('Guide', getObjectOrder('backing') + 1)

	addLuaSprite('stageback', false);
	addLuaSprite('overlay2', true);
	addLuaSprite('ground', false);
	addLuaSprite('overlay', true);
	addLuaSprite('moon', false);
	addLuaSprite('rain', true);

	breasts = getProperty('rain.y')
	breasts2 = getProperty('rain.x')

	rainmove(durationlol)

	setBackground('alpha',0)
	setProperty('moon.alpha',0)
	setBackground('color',getColorFromHex('5254B2'))
	setProperty('boyfriend.color',getColorFromHex('5254B2'))
end


function setBackground(whattodo, whatto)
	setProperty('stageback.'..whattodo,whatto)
	setProperty('overlay2.'..whattodo,whatto)
	setProperty('overlay.'..whattodo,whatto)
	setProperty('ground.'..whattodo,whatto)
	--setProperty('moon.'..whattodo,whatto)
	setProperty('rain.'..whattodo,whatto);
end

function rainmove(duration)
	doTweenY('rainMove','rain',getProperty('rain.y') + 250, duration, 'linear')
	doTweenX('rainMove2','rain',getProperty('rain.x') - 500, duration + 0.05, 'linear')
end

function onTweenCompleted(tag)
	if tag == 'rainMove' then
		setProperty('rain.x',breasts2)
		setProperty('rain.y',breasts)
		rainmove(durationlol)
	end
end

function makeSprite(tag, directory, x, y, cam)
    makeLuaSprite(tag, directory, x, y)
    addLuaSprite(tag)
    setObjectCamera(tag, cam)
    precacheImage(directory)
end

function onPause()
	return Function_Stop
end

function onBeatHit()
	--debugPrint(ratingVariable)
	if curBeat == 8 then
		setProperty('text.alpha',1)
		objectPlayAnimation('text', 'arrive');
		playSound('popup',5)
	end
	if curBeat == 24 then
		playSound('away',5)
		doTweenY('fuck','text',getProperty('text.y') + 500,0.75,'sineOut')
	end
	if curBeat == 25 then
        doTweenAlpha('fadeOut','Guide',0,1,'linear')
        doTweenAlpha('fadeOut2','backing',0,0.75,'linear')
	end
	if curBeat == 32 then
		setProperty('eye.alpha',1)
		objectPlayAnimation('eye', 'open');
	end
	if curBeat == 38 then
		doTweenAlpha('dad2s','dad',1,1,'linear')
		setProperty('text.alpha',0)
		doTweenAlpha('showHUD','camHUD',1,1,'linear')
		doTweenAlpha('bf2s','boyfriend',1,1,'linear')
	end
	if curBeat == 40 then
		doTweenAlpha('thing1','stageback',1,2.5,'linear')
		doTweenAlpha('thing2','overlay2',0.3,2.5,'linear')
		doTweenAlpha('thing3','ground',1,2.5,'linear')
		doTweenAlpha('thing4','moon',1,2.5,'linear')
		doTweenAlpha('thing5','rain',1,2.5,'linear')
		doTweenAlpha('thing6','overlay',1,2.5,'linear')
	end
	if curBeat == 428 then
		ratingVariable = round(rating * 100, 2)
		doTweenAlpha('hidehud','camGame',0,2,'linear')
		doTweenAlpha('hidehud2','camHUD',0,2,'linear')
	end
end

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end