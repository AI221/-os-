--[[
Description:
This contains functions that really don't need to be in kernel space.
Author:
Jackson McNeill
Version: 
1; for OS 0.6
]]


function osStuff.menuBar()
	
end














function osStuff.cRun(file,args)
    assert(type(file)=="string","osStuff.cRun - expected string,table got ~~need a function to tell this")
    if not type(args)=="table" then args = {} end
    if not fs.exists(file) then 
        game.e("cRun - File("..file..") doesn't exist!")
        return 1
    elseif fs.isReadOnly(file)=="noAccess"then 
        game.e("cRun - File("..file..") readonly status not false, was "..tostring(fs.isReadOnly(file)))
        return 2
    end 
    local f=fs.open(file,"r")
    if not f then 
        game.e("cRun - Error opening file "..file)
        return 3 
    end 
    local cont = f.readAll()
    f.close()
    if not cont then 
        game.e("cRun - File "..file.." had no contents!")
        return 4
    end 
    local func,er = loadstring(cont)
    if func then 
        local res = {pcall(func,unpack(args) )}
        if not res[1] then 
            game.e("cRun - File "..file.." got runtime error "..tostring(res[2]))
            return 6
        end 
        table.remove(res,1)
        return res
    else 
        game.l("cRun - File "..file.." had compiling error "..er)
        return 5 
    end 
end 


        

function osStuff.rightClick(tabl,x,y,backColor,textColor)
    local maxWidth,str = 0,""
    for i=1,table.maxn(tabl) do 
    maxWidth = math.max(maxWidth,#( tabl[i] or "" ) )
    end 
    for i=1,maxWidth do 
    str=str.."-"
    end 
    for i=1,table.maxn(tabl) do 
    tabl[i]=tabl[i] or str 
    end 
    local terx,tery = term.getSize()
    if y+#tabl > tery then 
    y=y-((y+#tabl)-tery)
    end 
    if x+maxWidth > terx then 
    x=(x-((x+maxWidth)-terx))+1
    end 
    local rBox = game.makeConfigBox(tabl,x,y,maxWidth,#tabl,backColor,textColor)
    --rBox:draw()
    return rBox
end 
local function bwrite( sText,w,newLnStart,width,extra)--ripped from bios.lua
    local _,h = term.getSize()        
    local x,y = term.getCursorPos()
    local str =""
    for i=0,width do 
        str=str.." "
    end
    term.write(str)
    term.setCursorPos(x,y)
    local nLinesPrinted = 0
    local function newLine()
        if y + 1 <= h then
            term.setCursorPos(newLnStart, y + 1)
            term.write(str)
            term.setCursorPos(newLnStart, y + 1)
        else
            term.setCursorPos(newLnStart, h)
            term.scroll(1)
        end
        x, y = term.getCursorPos()
        nLinesPrinted = nLinesPrinted + 1

    end
    
    -- Print the line with proper word wrapping
    while string.len(sText) > 0 do
        local whitespace = string.match( sText, "^[ \t]+" )
        if whitespace then
            -- Print whitespace
            --term.write( whitespace )
            local gx,gy=term.getCursorPos()
            term.setCursorPos(gx+#whitespace,gy)
            x,y = term.getCursorPos()
            sText = string.sub( sText, string.len(whitespace) + 1 )
        end
        
        local newline = string.match( sText, "^\n" )
        if newline then
            -- Print newlines
            newLine()
            sText = string.sub( sText, 2 )
        end
        
        local text = string.match( sText, "^[^ \t\n]+" )
        if text then
            sText = string.sub( sText, string.len(text) + 1 )
            if string.len(text) > w then
                -- Print a multiline word                
                while string.len( text ) > 0 do
                    if x > w then
                        newLine()
                    end
                    term.write( text )
                    text = string.sub( text, (w-x) + 2 )
                    x,y = term.getCursorPos()
                end
            else
                -- Print a word normally
                if x + string.len(text) - 1 > w then
                    newLine()
                end
                term.write( text )
                x,y = term.getCursorPos()
            end
        end
    end
    local x,y=term.getCursorPos()
    for i=1,extra or 2 do 
        term.setCursorPos(newLnStart,y+i)
        term.write(str)
        term.setCursorPos(newLnStart,y+i)
    end 

    return y
end
local function popup(x,y,width,text,topText,extra)
    if type(x)~="number" then --might do with y later
        local tx,ty=term.getSize()
        x=math.floor((tx-width)/2)
    end 
    local buttonX = width+x
    if not osStuff.settings.windows.buttonsOnCorrectSide then 
        buttonX = x 
    end
    term.setTextColor(osStuff.settings.windows.windowsTextColor)
    paintutils.drawLine(x,y,width+x,y,osStuff.settings.windows.windowsTopColor)
    term.setCursorPos(((width-#topText)/2)+x,y)
    term.write(topText)
    term.setBackgroundColor(osStuff.settings.windows.windowsMiddleColor)
    term.setCursorPos(x,y+1)
    return x,buttonX,bwrite(text,width+x,x,width,extra)
end

function osStuff.popup(x,y,width,buttons,text,topText,dontuseXButton)
      --make the top of the window
    local buttonX
    x,buttonX=popup(x,y,width,text,topText)
    local _,by = term.getCursorPos()
    local butts={}
    if type(buttons)=="table" then 
        for i=1,#buttons do 
            --term.setCursorPos(1,1)
            game.addButton(buttons[i].txt,buttons[i].x+x-1,by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)
        end 

    else 
        game.addButton("Okay",((width-4)/2)+x,by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)
    end 
    if not dontuseXButton then 
        game.addButton(osStuff.settings.windows.tbuttonX,buttonX,y,osStuff.settings.windows.cbuttonX,osStuff.settings.windows.windowsTextColor,butts)
    end
    game.drawButtons(butts)
    osStuff.renderMe() -- for apps using the self-rendering method
    while true do 
        local evts={coroutine.yield()}
        if evts[1]=="mouse_click" then 
            local txt,num=game.checkButtons(butts,evts)
            if num == #butts and (not dontuseXButton) then 
                return 
            elseif num then 
                return num 
            end 
        elseif evts[1]=="key" then 
            if evts[2]==28 then 
                return
            elseif evts[2]==1 and (not dontuseXButton) then 
                return 
            end 
        end 
    end 
end 
function osStuff.textPopup(x,y,width,buttons,text,topText,dontuseXButton,astrickChar)
      --make the top of the window
    local buttonX
    x,buttonX=popup(x,y,width,text,topText,4)
    local _,by = term.getCursorPos()
    local butts={}
    if type(buttons)=="table" then 
        term.setBackgroundColor(osStuff.settings.windows.textboxBgColor)
        for i=1,#buttons do 
            --term.setCursorPos(1,1)
            --game.addButton(buttons[i].txt,buttons[i].x+x-1,by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)
            buttons[i].txt,buttons[i].length,buttons[i].y=buttons[i].txt or "", buttons[i].length or (width-buttons[i].x)-2,buttons[i].y or 0
            buttons[i].y = buttons[i].y+by-2
            local txt = buttons[i].txt
            for o=#buttons[i].txt,buttons[i].length do 
                txt=txt.." "
            end 
            term.setCursorPos(buttons[i].x+x,buttons[i].y)
            term.write(txt)
        end 

    end
    game.addButton("Okay",  ((width-11)/2)+x,  by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)--this should be 12 but for some reason 11 works better. idk why.
    game.addButton("Cancel",((width-11)/2)+x+6,by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)
    if not dontuseXButton then 
        game.addButton(osStuff.settings.windows.tbuttonX,buttonX,y,osStuff.settings.windows.cbuttonX,osStuff.settings.windows.windowsTextColor,butts)
    end
    game.drawButtons(butts)
    osStuff.renderMe() -- for apps using the self-rendering method        


    term.setCursorPos(buttons[1].x+x,buttons[1].y)
    term.setBackgroundColor(osStuff.settings.windows.textboxBgColor)
    buttons[1].txt = osStuff.readRecolored(astrickChar, nil, nil,osStuff.settings.windows.windowsTextColor,osStuff.settings.windows.windowsMiddleColor,buttons[1].txt,buttons[1].length+x+buttons[1].x)--w is the limit for the size

    while true do 

        local evts={coroutine.yield()}
        if evts[1]=="mouse_click" then
            local txt,num=game.checkButtons(butts,evts)
            if ( num == 3 and (not dontuseXButton) ) or num==2 then 
                return 
            elseif num == 1 then 
                local ta ={}
                for i=1,#buttons do 
                    ta[i]=buttons[i].txt
                end 
                return ta 
            else
                for i=1,#buttons do 
                    if evts[3]>=buttons[i].x+x and evts[3] <=buttons[i].x+x+buttons[i].length and evts[4]==buttons[i].y then 
                        term.setCursorPos(buttons[i].x+x,buttons[i].y)
                        term.setBackgroundColor(osStuff.settings.windows.textboxBgColor)
                        buttons[i].txt=osStuff.readRecolored(astrickChar, nil, nil,osStuff.settings.windows.windowsTextColor,osStuff.settings.windows.windowsMiddleColor,buttons[i].txt,buttons[i].length+x+buttons[i].x)--w is the limit for the size
                    end 
                end 
            end 
        elseif evts[1]=="key" then 
            if evts[2]==28 then 
                local ta ={}
                for i=1,#buttons do 
                    ta[i]=buttons[i].txt
                end 
                return ta 
            elseif evts[2]==1 then 
                return 
            end 
        end 
    end 
end 

function osStuff.configPopup(x,y,width,buttons,text,topText,dontuseXButton)
      --make the top of the window
    local buttonX,bety
    x,buttonX,bety=popup(x,y,width,text,topText,buttons.ly+buttons.x+(x-1))
    local _,by = term.getCursorPos()
    local butts=game.makeConfigBox(buttons,x+buttons.x-1,bety+1,buttons.lx,buttons.ly,osStuff.settings.windows.configBack,osStuff.settings.windows.configText)
    
    game.addButton("Okay",  ((width-11)/2)+x,  by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)--this should be 12 but for some reason 11 works better. idk why.
    game.addButton("Cancel",((width-11)/2)+x+6,by,osStuff.settings.windows.buttonColor,osStuff.settings.windows.windowsTextColor,butts)
    if not dontuseXButton then 
        game.addButton(osStuff.settings.windows.tbuttonX,buttonX,y,osStuff.settings.windows.cbuttonX,osStuff.settings.windows.windowsTextColor,butts)
    end
    game.drawButtons(butts)
    butts:draw()
    osStuff.renderMe() -- for apps using the self-rendering method        
    local shiftPressed=false 
    while true do 

        local evts={coroutine.yield()}
        if evts[1]=="mouse_click" then
            local txt,num=game.checkButtons(butts,evts)
            if ( num == 3 and (not dontuseXButton) ) or num==2 then 
                return 
            elseif num == 1 then 
                return 
            else
		local res = butts:check(evts)
		if res then 
			return res 
		end
            end 
	elseif evts[1] == "key" and evts[2]==42 then --shift
		shiftPressed=true
	elseif evts[1]=="key_up" and evts[2]==42 then 
		shiftPressed=false 
	elseif evts[1]=="mouse_scroll" then
--		evts[1]="mouse_click"
		if butts:check(evts) then 
			if not osStuff.settings.scrollCorrectly then
				evts[2]=evts[2]*-1 
			end 
			if shiftPressed then 
				butts:addScroll(evts[2])
			else 
				butts:addScroll(0,evts[2])
			end
			butts:draw()
		end
        elseif evts[1]=="key" and evts[2]==1 then 
        	return 
        end 
    end 
end 

-- Add [os] help to the help app 
local nativeLookup = help.lookup 
local nativeTopics = help.topics
function help.lookup(topic)
    -- Favor [os] help
    help.setPath"library/help"
    local a = nativeLookup(topic)
    help.setPath"rom/help"
    local b = nativeLookup(topic)
    return a or b 
end 
function help.topics()
    --Favoring [os] help
    help.setPath"library/help"
    local a = nativeTopics()
    help.setPath"rom/help"
    local b = nativeTopics() 
    for i,o in pairs(a) do 
    table.insert(b,i,o)
    end 
    return b
end 
