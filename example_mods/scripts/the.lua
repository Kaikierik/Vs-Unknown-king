local shadname = 'ntsc'
function onCreatePost()
    if getPropertyFromClass('ClientPrefs', 'shaders', true) then
        initLuaShader(shadname)
        
        makeLuaSprite("temporaryShader")
        makeGraphic("temporaryShader", screenWidth, screenHeight)
        
        setSpriteShader("temporaryShader", shadname)
        
        addHaxeLibrary("ShaderFilter", "openfl.filters")
        runHaxeCode([[
            trace(ShaderFilter);
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
        ]])
    end
end