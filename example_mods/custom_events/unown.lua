
--[[ setting stuffs ]]

local sprite_dir = "Unown_Alphabet"

local bg_color = "FF0A0A"
local bg_alpha = 0.35

local letter_y = 100
local letter_padding = 50
local screen_padding = 50

local input_color = "000000"
local input_y = 575
local input_height = 8

local countdown_size = 100

local texts = {
    "UNLEASHED",
    "LEGENDARIES",
    "PERISHED",
    "POKEDEX",
    "CELEBI IS GONE",
    "MOLTRES IS GONE",
    "LUGIA IS GONE",
    "MEW IS GONE",
    "SACRAFICE",
    "LIBERATION",
    "INSTRUCTIONS",
    "AWAKENING",
    "FEROCIOUS",
    "THEY ALL DIED!",
    "SAVE GAME",
    "SUICUNE IS GONE",
    "CHRISTMAS",
    "CAESAR",
    "WAKE UP!",
    "YOU LOST!",
    "SILVER",
    "GAMEBOY",
    "CURSED",
    "ALPHA RUINS",
    "CARTRIDGE",
    "DELICIOUS",
    "UNOWN RADIO",
    "YOU FREED THE BEAST",
    "SUSEJ IS DEAD",
    "PANDORA BOX"
}

--[[ code stuffs ]]

local selected_text = nil
local current_character = 1
local countdown_end = nil

function onCreate()
	precacheImage(sprite_dir)
	
	setPropertyFromClass("ClientPrefs", "noReset", true)
end

local function remove_stuffs()
	removeLuaSprite("unown_bg", false)
	removeLuaText("unown_countdown", false)
	
	for i = 1, #selected_text do
		local character = selected_text:sub(i, i)
		if character ~= " " then
			removeLuaSprite("unown_letter" .. i, false)
			removeLuaSprite("unown_input" .. i, false)
		end
	end
	
	countdown_end = nil
	selected_text = nil
end

function onEvent(name, value_1, value_2)
	if name == "unown" then
		if getPropertyFromClass('ClientPrefs', 'mechanics', true) then
			if selected_text then
				remove_stuffs()
			end
			
			local bg_sprite = "unown_bg"
			makeLuaSprite(bg_sprite, "", 0, 0)
			makeGraphic(bg_sprite, 1280, 720, bg_color)
			addLuaSprite(bg_sprite, true)
			setProperty(bg_sprite .. ".alpha", bg_alpha)
			setObjectCamera(bg_sprite, "other")
			
			if value_2 == "" then
				if 1 == getRandomInt(1, 5) then
					if 1 == getRandomInt(1, 10 / 5) then
						selected_text = texts[getRandomInt(1, #texts)]
					else
						selected_text = texts[getRandomInt(1, #texts)]
					end
				else
					selected_text = texts[getRandomInt(1, #texts)]
				end
			else
				selected_text = value_2:upper()
			end
			
			current_character = 1
			
			local letter_width = 0
			local letter_placement = -letter_padding
			
			for i = 1, #selected_text do
				letter_placement = letter_placement + letter_width + letter_padding
				
				local character = selected_text:sub(i, i)
				if character == " " then
					letter_width = letter_padding * 2
				else
					local letter_sprite = "unown_letter" .. i
					letter_y = 200
					makeAnimatedLuaSprite(letter_sprite, sprite_dir, letter_placement, letter_y)
					addAnimationByPrefix(letter_sprite, character, character, 24, true)
					objectPlayAnimation(letter_sprite, character, true)
					addLuaSprite(letter_sprite, true)
					setProperty(letter_sprite .. ".y", letter_y - (getProperty(letter_sprite .. ".frameHeight") / 2) + getRandomInt(-100, 100))
					setObjectCamera(letter_sprite, "other")
					
					letter_width = getProperty(letter_sprite .. ".frameWidth")
				end
			end
			
			letter_placement = letter_placement + letter_width
			
			local scale = 1
			local threshold = 1280 - (screen_padding * 2)
			if letter_placement > threshold then
				repeat
					scale = scale - 0.05
					if scale > 0 then
						letter_width = 0
						letter_placement = -(letter_padding * scale)
						
						for i = 1, #selected_text do
							letter_placement = letter_placement + letter_width + (letter_padding * scale)
							
							if selected_text:sub(i, i) == " " then
								letter_width = (letter_padding * 2) * scale
							else
								local letter_sprite = "unown_letter" .. i
								
								scaleObject(letter_sprite, scale, scale)
								setProperty(letter_sprite .. ".x", letter_placement)
								
								letter_width = getProperty(letter_sprite .. ".frameWidth") * scale
							end
						end
						
						letter_placement = letter_placement + letter_width
					else
						break
					end
				until letter_placement < threshold
			end
			
			for i = 1, #selected_text do
				local character = selected_text:sub(i, i)
				if character ~= " " then
					local letter_sprite = "unown_letter" .. i
					setProperty(letter_sprite .. ".x", getProperty(letter_sprite .. ".x") + ((1280 - letter_placement) / 2))
					--setProperty(letter_sprite .. ".angle", getRandomInt(-70, 70))
					
					local input_sprite = "unown_input" .. i
					makeLuaSprite(input_sprite, "", getProperty(letter_sprite .. ".x"), input_y)
					makeGraphic(input_sprite, getProperty(letter_sprite .. ".frameWidth") * scale, input_height, input_color)
					addLuaSprite(input_sprite, true)
					setObjectCamera(input_sprite, "other")
				end
			end
			
			local song_pos = getPropertyFromClass("Conductor", "songPosition")
			countdown_end = song_pos + (value_1 * stepCrochet)
			makeLuaText("unown_countdown", tostring(math.floor((countdown_end - song_pos) / 1000)), countdown_size, 640, 360)
			addLuaText("unown_countdown")
			setObjectCamera("unown_countdown", "other")
		end
	end
end

function onUpdatePost()
	if getPropertyFromClass('ClientPrefs', 'mechanics', true) then
		songPos = getSongPosition()
		local currentBeat = (songPos/1000)*(bpm/200)
		for i = 1, #selected_text do
			if (i % 2 == 0) then
				setProperty("unown_letter" .. i ..".y",letter_y + 40*math.sin((currentBeat*0.75)*math.pi))
				setProperty("unown_letter" .. i ..".angle",0 + 20*math.sin((currentBeat*0.75)*math.pi))
			else
				setProperty("unown_letter" .. i ..".y",letter_y - 40*math.sin((currentBeat*0.75) * math.pi)) --not working
				setProperty("unown_letter" .. i ..".angle",0 - 20*math.sin((currentBeat*0.75)*math.pi))
			end
		end
	end
end

function onUpdate()
	if getPropertyFromClass('ClientPrefs', 'mechanics', true) then
		if selected_text then
			local song_pos = getPropertyFromClass("Conductor", "songPosition")
			if song_pos <= countdown_end then
				setTextString("unown_countdown", tostring(math.floor((countdown_end - song_pos) / 1000)))
				
				if getPropertyFromClass("flixel.FlxG", "keys.justPressed." .. selected_text:sub(current_character, current_character)) then
					setProperty("unown_input" .. current_character .. ".alpha", 0)
					current_character = current_character + 1
				end
				
				if current_character > #selected_text then
					remove_stuffs()
				end
			else
				remove_stuffs()
				
				setProperty("health", 0)
			end
		end
	end
end

function onStepHit()
	if getPropertyFromClass('ClientPrefs', 'mechanics', true) then
		if selected_text then
			if botPlay then
				setProperty("unown_input" .. current_character .. ".alpha", 0)
				current_character = current_character + 1
			end
		end
	end
end
