local r,rl,rMenu,rMenuY
local str,scroll = "",0
local tx,ty = term.getSize()
for i=1,term.getSize() do 
	str=str.." "
end 
term.setBackgroundColor(colors.white)
term.setTextColor(osStuff.settings.gc.menuTColor)
term.setCursorPos(1,1)
term.clear()
term.setBackgroundColor(osStuff.settings.gc.menuBColor)
--print(str)
term.setBackgroundColor(colors.white)
term.write(" Process")
term.setCursorPos(tx-6,1)
print"Active"
term.setBackgroundColor(osStuff.settings.gc.menuBColor)
print(str)
paintutils.drawLine(1,1,1,ty,osStuff.settings.gc.menuBColor)
paintutils.drawLine(1,ty,tx,ty,osStuff.settings.gc.menuBColor)
local function redraw()
	rl = osStuff.listRoutines()

	r = game.makeConfigBox(rl,2,3,tx-9,ty-3,colors.white,osStuff.settings.gc.menuTColor)
	r:setScroll(1,scroll)
	r:draw()
	paintutils.drawLine(tx,1,tx,ty,osStuff.settings.gc.menuBColor)
	paintutils.drawLine(tx-7,1,tx-7,ty,osStuff.settings.gc.menuBColor)
	local secondBox = {}
	for i=1,#rl do 
		secondBox[i] = tostring(osStuff.isActive(rl[i]) or false)
	end 
	local bx = game.makeConfigBox(secondBox,tx-6,3,5,ty-3,colors.white,osStuff.settings.gc.menuTColor)
	bx:setScroll(1,scroll)
	bx:draw()
	--[[for i=1,#rl do 
		local _,cy=term.getCursorPos()
		term.setCursorPos(tx-5,cy)
		print(tostring(osStuff.isActive(r[i]) or false )) -- or false means it won't be nil if not active
	end]]

end 
redraw()
while true do 
	local evts= {coroutine.yield()}
	if evts[1]=="mouse_click" then 
		if rMenu then 
			local check = rMenu:check(evts)
			if check then 
				if check==0 and rMenuY then 
					osStuff.killRoutine(rMenuY)
					os.queueEvent"taskYield"
					coroutine.yield"taskYield"
					redraw()
				elseif check==1 then 
					redraw()
				end 
			end 
			rMenu=false 
			redraw()
		elseif evts[2]==2  and evts[4] > 2 and evts[4] < ty-1 and evts[3] > 1 and evts[3] < tx-7 then
			rMenu = osStuff.rightClick({"Kill Task","Refresh"},evts[3]+1,evts[4],colors.blue,colors.black)
			rMenu:draw()
			--evts[4] = evts[4]-3
			rMenuY=rl[(r:check(evts) or -1337)+1]
			--game.l("GET "..tostring(textutils.serialize({r:check(evts)})))
			--game.l("GET "..tostring(rl[])
		end 
	elseif evts[1] =="mouse_scroll" then 
		if not osStuff.settings.scrollCorrectly then 
			evts[2]=evts[2]*-1 
		end 
		if (evts[2]==-1 and scroll>0) or  ( ( scroll < #rl-(ty-3) ) and evts[2]==1) then 
			scroll=scroll+evts[2]
			redraw()
		end
	elseif evts[1] == "timer" and (not rMenu) then --The time daemon is already creating a timer every second. If the time daemon dies, just leave it to the user to refresh the screen.
		redraw()
	end 
end 
