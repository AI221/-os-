--a modified fork of the desktop
local p={}
p[1]={}
p[1].arr = {}
p[1].mArr={}
p[1].xPos =1
p[1].maxXPos = math.floor(term.getSize()/2)
p[1].histSpot = 1
p[1].hist = {} 
p[1].hist[p[1].histSpot] = "/"
p[1].scroll = 0
p[1].menuY = 1
local desktopMode,forwarded,deskBack = false,false,colors.white


local bg = game.loadMapOld("library/defDesk", 0, 0,false,colors.white,colors.black,"?",51,18)
local function refrshDeskBack(pnum)
	term.setBackgroundColor(deskBack)
	local x,y=term.getSize()
	local str = ""
	for i=1,p[pnum].maxXPos-1 do 
		str=str.." "
	end
	for i=5,y do
		term.setCursorPos(p[pnum].xPos,i)
		term.write(str)
	end --sleep(2)
	if desktopMode then 
		bg:render(1,1,1,1)
	end 
end 
local args = {...}
--[[if not args[1] then 
	args = osStuff.getArgs()
end ]]
----game.l("Files got args "..textutils.serialize(args))

if (args or {})[1] then 
	if args[1] == "-desktop" then 
		desktopMode = true 
		p[1].histSpot = 1
		p[1].hist = {} 
		p[1].hist[p[1].histSpot] = args[2]
		p[1].maxXPos=term.getSize()+1
		p[1].menuY = -3
		--game.l"--FILES IN DESKTOP MODE--"
		deskBack = osStuff.settings.desktop.textBackColor
	else 

		p[1].histSpot = 1
		p[1].hist = {} 
		p[1].hist[p[1].histSpot] = args[1]

				
	end
end
if not desktopMode then 
	p[2]={}
	p[2].arr = {}
	p[2].mArr={}
	p[2].xPos = math.floor(term.getSize()/2)+1
	p[2].maxXPos = term.getSize()
	p[2].hist={}
	p[2].histSpot=1
	p[2].hist[p[2].histSpot]= (args or{})[2] or "/"
	p[2].scroll=1
	p[2].menuY=3
	osStuff.changeMenuColor(osStuff.settings.desktop.titleMenuBColor)
end 
term.clear()
term.setCursorPos(1,1)
local icns = {}
local folderIcn = game.loadMapOld("library/icon/folder", 0, 0,true)
local wtf = game.loadMapOld("library/icon/unknown", 0, 0,true)
for i,o in pairs(osStuff.settings.fileTypeDefIcons) do 
	icns[i] = game.loadMapOld(o, 0, 0,true)
end 
--make buttons
p[1].guiButs = game.addButton(" < ",term.getSize()-12,1,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor)
game.addButton(" > ",term.getSize()-7,1,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor,p[1].guiButs)
game.addButton(" ^ ",term.getSize()-2,1,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor,p[1].guiButs)

if p[2] then 
	p[2].guiButs = game.addButton(" < ",term.getSize()-12,3,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor)
	game.addButton(" > ",term.getSize()-7,3,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor,p[2].guiButs)
	game.addButton(" ^ ",term.getSize()-2,3,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor,p[2].guiButs)
	game.addButton(">",1,4,osStuff.settings.desktop.titleMenuButBColor,osStuff.settings.desktop.titleMenuButTColor,p[2].guiButs)
	--game.addButton(">",1,4,colors.blue,colors.black,p[2].guiButs)
end 
local function renderIcons(pnum,xPos,maxXPos)
	
	
	--temo:
	--pnum,xPos,maxXPos = 1,1,19
	--[[p[pnum].hist = {}
	p[pnum].histSpot=1
	p[pnum].hist[p[pnum].histSpot]="/testing"]]
 	
	----game.l("files rendering for "..p[pnum].hist[p[pnum].histSpot])
	if not fs.isDir(p[pnum].hist[p[pnum].histSpot]) then --wtf?
		game.e("Files was not given a valid directory ("..p[pnum].hist[p[pnum].histSpot].."). Going to root directory(/)")
		p[pnum].hist[p[pnum].histSpot] = "/"
	end 
	local stuff = fs.list(p[pnum].hist[p[pnum].histSpot])
	if not stuff then return false end 
	----game.l"ALIVE"v
	--folderIcn.render.blit(1,1)
	--[[
	local tx,ty=term.getSize()
	for x=1,tx do 
		if p[pnum].arr[x] then 
			for y=p[pnum].scroll+1,ty+p[pnum].scroll do 
				if p[num].arr[x][y] then --have a table in settings or something of all file type icons
					exedef.render.blit(1,1,x,y-p[pnum].scroll)
					--name will be u
				end 
			end 
		end 
	end ]]



	local _,ty = term.getSize()
	for i=1,table.maxn(stuff) do 
 
		if string.sub(stuff[i],1,1)~="." and ((p[pnum].arr[stuff[i]] or {}).y or 1)+p[pnum].scroll+4 > ( ( ((p[2] or {}).menuY or p[1].menuY)+1) or 0) and ((p[pnum].arr[stuff[i]] or {}).y or 1)+p[pnum].scroll  <= ty    then 
			if not p[pnum].arr[stuff[i]] then 
				game.e"1"
			end 
			p[pnum].arr[stuff[i]] = p[pnum].arr[stuff[i]] or {}
			if not p[pnum].arr[stuff[i]].x then
				game.e"2" 
			end  
			p[pnum].arr[stuff[i]].x = p[pnum].arr[stuff[i]].x or 1
			p[pnum].arr[stuff[i]].y = p[pnum].arr[stuff[i]].y or 1
			local renderx,rendery = 4,3 
			renderx = renderx - (4 - math.max( (p[pnum].maxXPos - p[pnum].arr[stuff[i]].x) , 0) )
			local yl = math.max( ((p[2] or {}).menuY or p[1].menuY) + 2 , 1)
			rendery = math.max (  3-(    (p[pnum].arr[stuff[i]].y+p[pnum].scroll+3)-yl        )  , 0)
			if (p[pnum].arr[stuff[i]].x+1 > p[pnum].maxXPos or p[pnum].arr[stuff[i]].x+p[pnum].xPos < p[pnum].xPos) then
				p[pnum].arr[stuff[i]].x = p[pnum].maxXPos-1
			end 
			if (p[pnum].mArr[stuff[i]] or {}).icn then --fs.exists( fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],stuff[i]) ,"iconOld") ) then 
				term.setBackgroundColor(colors.black)
				term.setTextColor(colors.white)
				p[pnum].mArr[stuff[i]].icn:render(1,1+rendery,p[pnum].arr[stuff[i]].x,p[pnum].arr[stuff[i]].y+p[pnum].scroll+rendery,renderx)
			elseif icns[string.lower(osStuff.getExt(stuff[i]) )] then 
				  (icns[string.lower( osStuff.getExt(stuff[i] ) )].render or function()end)(icns[string.lower( osStuff.getExt(stuff[i] ) )],1,1+rendery,p[pnum].arr[stuff[i]].x+xPos-1    ,p[pnum].arr[stuff[i]].y+p[pnum].scroll+rendery,renderx)
			elseif fs.isDir( fs.combine(p[pnum].hist[p[pnum].histSpot],stuff[i]) ) then --this is last because some extensions are folders
				folderIcn:render(1,1+rendery,p[pnum].arr[stuff[i]].x+p[pnum].xPos-1    ,p[pnum].arr[stuff[i]].y+p[pnum].scroll+rendery,renderx)
			else 
				wtf:render(1,rendery+1,p[pnum].arr[stuff[i]].x+p[pnum].xPos-1   ,p[pnum].arr[stuff[i]].y+p[pnum].scroll+rendery,renderx)
			end 
			local y=p[pnum].arr[stuff[i]].y+3+p[pnum].scroll
			------game.l("Y WAS "..y.." ON "..stuff[i])
			if y >= yl then 
				--render the text below
				local txt = stuff[i]
				if string.sub(txt,#txt-3,#txt-3) == "." and (not osStuff.settings.desktop.showExtension) then 
					txt=string.sub(txt,1,#txt-4)
				end 
				if #txt >= osStuff.settings.desktop.maxIcnLength then 
					txt=string.sub(txt,1,osStuff.settings.desktop.maxIcnLength-2)..".."
				end 
				----game.l"PASSED"
				term.setBackgroundColor(deskBack)
				term.setTextColor(colors.black)
				term.setCursorPos(math.floor((4-#txt)/2)+p[pnum].arr[stuff[i]].x+p[pnum].xPos-1    ,y)
				
				for i=1,#txt do 
					if term.getCursorPos() >= p[pnum].xPos and term.getCursorPos() <= p[pnum].maxXPos-1 then 
						term.setBackgroundColor(deskBack)
						term.write(txt:sub(i,i))
					else 
						term.setCursorPos(term.getCursorPos()+1,y)
					end 
				end 
			end 
		end 
	end 
	--render the GUI
	--render background
	
	osStuff.renderMe()

end 
local function refreshLocation()
	paintutils.drawLine(3,1,term.getSize()-15,1,colors.white)
	term.setCursorPos(3,1)    
	term.write"/"
	term.setCursorPos(3,1)  
	term.write(  string.sub( p[1].hist[p[1].histSpot],  math.max( 1, #p[1].hist[p[1].histSpot]-(term.getSize()-18) ), #p[1].hist[p[1].histSpot]  )  )
	if #p[1].hist[p[1].histSpot]-(term.getSize()-18) > 1 then 
		term.setCursorPos(2,1)
		term.setBackgroundColor(colors.cyan)
		term.setTextColor(colors.black)
		term.write"<"
	else 
		term.setCursorPos(2,1)
		term.setBackgroundColor(osStuff.settings.desktop.titleMenuBColor)
		term.write" "
	end 
	paintutils.drawLine(3,3,term.getSize()-15,3,colors.white)
	term.setCursorPos(3,3)    
	term.write"/"
	term.setCursorPos(3,3)  
	term.write(  string.sub( p[2].hist[p[2].histSpot],  math.max( 1, #p[2].hist[p[2].histSpot]-(term.getSize()-18) ), #p[2].hist[p[2].histSpot]  )  )
	if #p[2].hist[p[2].histSpot]-(term.getSize()-18) > 1 then 
		term.setCursorPos(2,p[2].menuY)
		term.setBackgroundColor(colors.cyan)
		term.setTextColor(colors.black)
		term.write"<"
	else 
		term.setCursorPos(2,p[2].menuY)
		term.setBackgroundColor(osStuff.settings.desktop.titleMenuBColor)
		term.write" "
	end 
end 
term.setTextColor(colors.black)
if not desktopMode then 
	
	paintutils.drawLine(1,1,term.getSize(),1,osStuff.settings.desktop.titleMenuBColor)
	paintutils.drawLine(1,2,term.getSize(),2,osStuff.settings.desktop.titleMenuBColor)
	
	game.drawButtons(p[1].guiButs)
	paintutils.drawLine(1,3,term.getSize(),3,osStuff.settings.desktop.titleMenuBColor)
	paintutils.drawLine(1,4,term.getSize(),4,osStuff.settings.desktop.titleMenuBColor)
	game.drawButtons(p[2].guiButs)
	refreshLocation()
end 

local function refreshSidebar() 
	if not desktopMode then 
		local x,y =term.getSize()
		term.setBackgroundColor(osStuff.settings.desktop.splitterColor)
		for i=5,y do 
			term.setCursorPos(math.floor(x/2),i)
			term.write" "
		end 
	end 
end 
refreshSidebar()
local function saveArrange(pnum)
	------game.l("~~arr: "..tostring(pnum))
	local savePos = fs.combine(p[pnum].hist[p[pnum].histSpot],".arrange")
	if desktopMode then 
		savePos=savePos.."desktop"
	end 
	if fs.isReadOnly(savePos) then 
		game.e("Files - Couldn't save to "..savePos..", file is read-only or no-access.")
		return
	end
	local f = fs.open(  savePos  ,"w")
	if not f then game.e("Couldn't open "..savePos.."/.arrange!") return false end 
	local ser 
	--[[local serializedArr = {}
	for i,o in pairs(p[pnum].arr) do 
		serializedArr[i]={}
		for j,k in pairs(o) do 
			if j~= "icn" then 
				serializedArr[i][j]=k
			end
		end  
	end ]]
	ser = textutils.serialize(p[pnum].arr)
	if not ser then game.e"Failed to serialize p[pnum].arrangement!" end 
	f.write(ser)
	f.close()
end 
local function sortArrange(pnum)
	--game.l"getSortArrange"
	local stuff = fs.list(p[pnum].hist[p[pnum].histSpot])
	local lastX,lastY = p[pnum].maxXPos,1
	if desktopMode then 
		lastY = -4
	end
	for i=1,table.maxn(stuff) do 
		if stuff[i] and string.sub(tostring(stuff[i]),1,1) ~="." then 
			lastX = lastX+osStuff.settings.desktop.maxIcnLength
			if lastX+osStuff.settings.desktop.maxIcnLength >= p[pnum].maxXPos then 
				lastX=osStuff.settings.desktop.maxIcnLength/2
				lastY=lastY+6
			end 
			p[pnum].arr[stuff[i]] = {}
			p[pnum].arr[stuff[i]].x = lastX 
			p[pnum].arr[stuff[i]].y = lastY 
			--[[ p[pnum].mArr[stuff[i] ] = {}
			p[pnum].mArr[stuff[i] ].x = lastX 
			p[pnum].mArr[stuff[i] ].y=lastY]]
		end  
	end 
	saveArrange(pnum)
end 


local function loadArrange(pnum,forceSort)
	p[pnum].arr,p[pnum].mArr = {},{}
	if forceSort then 
		sortArrange(pnum)
	else 
		local loadSpot = fs.combine(p[pnum].hist[p[pnum].histSpot],".arrange")
		if desktopMode then 
			loadSpot=loadSpot.."desktop"
		end 
		if fs.isReadOnly(loadSpot) == "noAccess" then 
			game.e("Couldn't load "..loadSpot.." as the file is no-access")
			forceSort=true
		end 
		local f = fs.open(  loadSpot,"r")
		local ser 
		if f then 
		
			ser=f.readAll()
			f.close()
			ser = textutils.unserialize(ser)
		else 
			game.e("Couldn't open "..loadSpot.."/.arrange!") 
			forceSort = true 
		end 
		if ser then 
			
			p[pnum].arr=ser
			if not p[pnum].arr then 
				p[pnum].arr = {}
			end 
		else 
			game.e"Failed to unserialize p[pnum].arrangement!" 
			sortArrange(pnum) 
		end 
		if forceSort then 
			sortArrange(pnum)
		end 
		--game.l"getToEnd"
	end 
	--game.l"afterEnd"
	--load icons & settings
	local remtab = {}
	for i,o in pairs(p[pnum].arr or {}) do 
		----game.l(i)
		if not fs.exists(fs.combine(p[pnum].hist[p[pnum].histSpot],i)) then 
			remtab[#remtab+1] = i
			------game.l("nop "..i)
		elseif string.sub(i,1,1)=="." then
			----game.l("caughtDot")
			remtab[#remtab+1]=i
		end  
		if fs.exists( fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],i) ,"iconOld") ) then 
			p[pnum].mArr[i]=p[pnum].mArr[i]or{}
			p[pnum].mArr[i].icn = game.loadMapOld(fs.combine(fs.combine(p[pnum].hist[p[pnum].histSpot],i),"iconOld"), 0, 0,true)
		elseif fs.exists( fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],i) ,"config.lua")  ) then 
			p[pnum].mArr[i]=p[pnum].mArr[i]or{}
			local conf,unSerCont = fs.open(fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],i) ,"config.lua") ,"r")
			--game.l"s"
			if conf then 
				--game.l"2"
				unSerCont = conf.readAll()
				conf.close() 
				if unSerCont then 
					p[pnum].mArr[i].cfg=textutils.unserialize(unSerCont)
				end
			end  
		end 
	end  
	for i=1,#remtab do 
		p[pnum].arr[remtab[i] ] = nil 
		p[pnum].mArr[remtab[i] ] = nil 
	end 
end
local function dragIntoOther(evts,theP,op,noScrolly)
	if (evts[3] > p[theP].maxXPos and theP == 1) or (evts[3] < p[theP].xPos and theP==2) then 
		--can we move it over?
		if fs.isReadOnly(p[theP].pressing) then 
			p[theP].pressing = nil 
			p[theP].dragged = nil
		else
			local spot = fs.combine( p[op].hist[p[op].histSpot] ,  p[theP].pressing )
			while true do 
				if fs.exists(spot) then 
					spot=spot.."-"
				else 
					break 
				end 
			end 
			fs.move(fs.combine( p[theP].hist[p[theP].histSpot],p[theP].pressing ),spot)
			p[op].arr[osStuff.prgName(spot)] = {}
			if theP==1 then 
				p[op].arr[osStuff.prgName(spot)].x = evts[3]-p[op].xPos
				p[op].arr[osStuff.prgName(spot)].y = noScrolly-p[op].scroll
			else 
				p[op].arr[osStuff.prgName(spot)].x = p[op].maxXPos-2
				p[op].arr[osStuff.prgName(spot)].y = noScrolly-p[op].scroll
			end 
			p[op].pressing = osStuff.prgName(spot)
			p[op].dragged=true
			refrshDeskBack(op)
			renderIcons(op,p[op].xPos,p[op].maxXPos)
			p[theP].pressing = nil 
			p[theP].dragged = nil
		end
	else 
		return true 
	end
end 



local function main() 
	term.setCursorBlink(false)
	loadArrange(1)
	refrshDeskBack(1)
	renderIcons(1,p[1].xPos,p[1].maxXPos)
	if p[2] then 
		loadArrange(2)
		refrshDeskBack(2)
		renderIcons(2,p[2].xPos,p[2].maxXPos)
	end 
	saveArrange(1)
	--p[1].pressing,p[1].dragged,p[1].rcBox,p[1].rObj = 
	local function run() 
		shell.run(osStuff.settings.extensions[osStuff.getExt(p[pnum].pressing)][1].." "..p[pnum].pressing) 
	end 
	while true do
		local evts = {coroutine.yield()}
		local resetY = evts[4]
		------game.l(textutils.serialize(evts))
		----game.l"cy"
		if evts[1]=="mouse_scroll"  or (evts[1]=="key" and (evts[2]==200 or evts[2]==208 or evts[2] == 199 or evts[2] == 207)) and not desktopMode then 
			local whichSide
			if evts[1]=="key" then 
				if evts[2]==200 then 
					evts[2]=-1 
					whichSide=1
				elseif evts[2]==208 then 
					evts[2]=1
					whichSide=1
				elseif evts[2]==199 then 
					evts[2]=-1
					whichSide=2
				elseif evts[2] == 207 then 
					evts[2]=1
					whichSide=2
				end 
			end 
			if osStuff.settings.scrollCorrectly then 
				evts[2] = evts[2] *-1
			end
			if evts[2] ==1 then 
				evts[2] = evts[2] + osStuff.settings.scrollAdd
			else 
				evts[2]=evts[2]-osStuff.settings.scrollAdd
			end
			if whichSide == 1  or  ((not whichSide) and evts[3] < p[1].maxXPos) then --I love how or/and/not statements work like this. If 'and' sees the first statement is false, it doesn't even bother to check the other statement.
				--game.l"gotScroll"
				p[1].scroll = p[1].scroll+evts[2]
				refrshDeskBack(1)
				renderIcons(1,p[1].xPos,p[1].maxXPos)
				if p[1].rcBox and p[2] then 
					refrshDeskBack(2)
					renderIcons(2,p[2].xPos,p[2].maxXPos)
				end 
				p[1].rcBox = nil 
				p[1].rObj=nil
				if p[2] then 
					p[2].rcBox = nil 
					p[2].rObj=nil
				end 
			elseif p[2] then 
				p[2].scroll = p[2].scroll+evts[2]
				refrshDeskBack(2)
				renderIcons(2,p[2].xPos,p[2].maxXPos)
				p[1].rcBox = nil 
				p[1].rObj=nil
				p[2].rcBox = nil 
				p[2].rObj=nil
			end 
		else 
			for pnum=1,#p do 
				evts[4]=resetY
				if evts[1] == "mouse_click" then --3  = x | 4 = y 
					--add p[pnum].scroll
					local noScrolly = evts[4]
					evts[4] = (evts[4] or 0) - p[pnum].scroll
					--game.l"click"
					if (noScrolly <= ((p[2] or {}).menuY or 1)+1) and (not desktopMode) then 
						if ( (not p[1].rcBox )and (not (p[2] or {}).rcBox) ) then 
							evts[4]=noScrolly
							local bTxt,bNum = game.checkButtons(p[pnum].guiButs,evts)
							if bNum == 3 then 
								--[[for i=pastPos+1,#pastFold do 
									pastFold[i] = nil 
								end 
								pastFold[pastPos] = p[pnum].hist[p[pnum].histSpot]
								p[pnum].hist[p[pnum].histSpot] = osStuff.getDir(p[pnum].hist[p[pnum].histSpot])]]
								p[pnum].hist[p[pnum].histSpot+1] = osStuff.getDir(p[pnum].hist[p[pnum].histSpot])
								p[pnum].histSpot = p[pnum].histSpot+1
								p[pnum].scroll = 0
								refrshDeskBack(pnum)
								loadArrange(pnum)
								refreshLocation()
								renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
							elseif bNum == 1 and p[pnum].histSpot > 1 then 
								p[pnum].histSpot = p[pnum].histSpot-1
								refrshDeskBack(pnum)
								loadArrange(pnum)
								refreshLocation()
								renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
							elseif bNum ==2 and p[pnum].histSpot < #p[pnum].hist then 
								p[pnum].histSpot=p[pnum].histSpot+1
								refrshDeskBack(pnum)
								loadArrange(pnum)
								refreshLocation()
								renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)

							else 
								if noScrolly ==p[pnum].menuY and evts[3] > 2 and evts[3] <= term.getSize()-15 then  ---Textbox, where the file dir is
									--game.l"clickedTextbox"
									term.setCursorPos(3,p[pnum].menuY)
									term.setTextColor(colors.black)
									term.setBackgroundColor(colors.white)
									if p[pnum].hist[p[pnum].histSpot]:sub(#p[pnum].hist[p[pnum].histSpot],#p[pnum].hist[p[pnum].histSpot])~="/" then 
										p[pnum].hist[p[pnum].histSpot]=p[pnum].hist[p[pnum].histSpot].."/"
									end
									--[[pastPos = pastPos+1
									pastFold[pastPos] = p[pnum].hist[p[pnum].histSpot]]
									
									local maybeCfold=osStuff.readRecolored(nil,p[pnum].hist,nil,colors.gray,colors.black,p[pnum].hist[p[pnum].histSpot],term.getSize()-14,p[pnum].histSpot)
									if fs.isDir(maybeCfold) then 
										--pastFold[#pastFold+1] = p[pnum].hist[p[pnum].histSpot]
										p[pnum].hist[p[pnum].histSpot] = maybeCfold
										p[pnum].scroll = 0
										refrshDeskBack(pnum)
										loadArrange(pnum)
									else 
										game.e("Did not specify folder!")
									end
									refreshLocation()
									renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
									
								end 
							end 
						end 
					elseif ( evts[2]==2 and evts[3] >= p[pnum].xPos and evts[3] < p[pnum].maxXPos) and ( not ((p[pnum].rcBox or {}).check or function()end)(p[pnum].rcBox, evts) )  then --open right click menu
						if p[pnum].rcBox then 
							refrshDeskBack(pnum)
							renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
						end 
						p[pnum].rObj = nil 
						for i,o in pairs(p[pnum].arr) do 
							if evts[3] < p[pnum].maxXPos and evts[3] > p[pnum].xPos-1 then 
								if p[pnum].arr[i].x+(p[pnum].xPos-1) <= evts[3] then 
									if p[pnum].arr[i].y <= evts[4] then 
										if p[pnum].arr[i].x+4+(p[pnum].xPos-1) >= evts[3] then 
											if p[pnum].arr[i].y+3>= evts[4] then 
												p[pnum].rObj = i
												break
											end 
										end 
									end 
								end 
							end 
						end 
						----game.l("Right clicked "..tostring(p[pnum].rObj))
						if (not p[pnum].rcBox) or not p[pnum].rcBox:check(evts) then 
							refreshSidebar()
							if p[pnum].rObj then 
								p[pnum].rcBox = osStuff.rightClick({"Full name >", "WIP-Properties >","Copy >","Run >","Run with >",nil,"Rename >","Duplicate >","Delete >"},evts[3]+1,noScrolly,colors.blue,colors.black)
							else 
								p[pnum].rcBox = osStuff.rightClick({"New file","New Folder",nil,"Sort"},evts[3]+1,noScrolly,colors.blue,colors.black)
							end 
							refrshDeskBack(1)
							renderIcons(1,p[1].xPos,p[1].maxXPos)
							if p[2] then 
								refrshDeskBack(2)
								renderIcons(2,p[2].xPos,p[2].maxXPos)
							end 
							p[pnum].rcBox:draw()
							osStuff.renderMe()
						end 
					elseif evts[2]==1 then 
						if p[pnum].rcBox then 
							--game.l"hasRightClickBox"
							evts[4] = evts[4]+p[pnum].scroll
							local check = p[pnum].rcBox:check(evts)
							if check then 
								----game.l("clicked "..check)
								if p[pnum].rObj then 
									if check==0 then --Full Name
										osStuff.popup(nil,9,25,nil,tostring(p[pnum].rObj),"Full Name",false)
									elseif check==1 then --properties

									elseif check==2 then --Copy to clipbaord
										osStuff.copyToClipboard("File://"..fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj ))
									elseif check==3 then --Run 
										game.l(fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj))
										local realname = osStuff.spawnApp(p[pnum].rObj,loadfile(  fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj)   ),colors.white,colors.black,"R",false) 
										osStuff.legacyMakeActive(realname)
									elseif check==4 then --Run with 
										
									elseif check==6 then --Rename
										if fs.isReadOnly(p[pnum].rObj) then 
											osStuff.popup(nil,9,25,nil,tostring(p[pnum].rObj).." is read-only or no-access and cannot be renamed.","Cannot rename",false)
										else 
											local res = osStuff.textPopup(nil,9,25,{{x=2,txt=p[pnum].rObj}},"Enter the new name:","Rename",false)
											if res and (res or {})[1]~=p[pnum].rObj then 
												p[pnum].arr[res[1] ]  =   p[pnum].arr[p[pnum].rObj] 
												p[pnum].mArr[res[1] ]  =   p[pnum].mArr[p[pnum].rObj] 
												p[pnum].arr[p[pnum].rObj] =nil
												p[pnum].mArr[p[pnum].rObj] =nil
												fs.move(fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj), fs.combine( p[pnum].hist[p[pnum].histSpot] , res[1]))
											end 
										end 
									elseif check==7 then --Duplicate
										local name = fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj )
										if fs.isReadOnly(name) == 'noAccess' then 
											osStuff.popup(nil,9,25,nil,"The file "..tostring(p[pnum].rObj).." is no-access. Cannot copy without elevated permissions.","Failed to copy file")
										else 
											local cName = name.."-Duplo"
											while true do 
												if fs.exists(cName) then 
													cName=cName.."-"
												else 
													break 
												end 
											end 
											----game.l(cName)
											fs.copy(name,cName)
										end 
									elseif check ==8 then --Delete
										local res = osStuff.popup(nil,9,25,{{txt="Yes",x=10},{txt="No",x=15}},"Do you want to delete "..tostring(p[pnum].rObj).."?","Delete File",false)
										if res ==1 then 
											if fs.isReadOnly(fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj  )) then 
												osStuff.popup(nil,9,25,nil,"The file "..tostring(p[pnum].rObj).." is read-only or no-access. Cannot delete without elevated permissions.","Failed to delete file")
											else 
												fs.delete(fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj  ))
											end 
										end 
									end 
								else 
									if check == 1 or check==0 then 
										local name = "New File"
										if check ==1 then name="New Folder" end 
										while true do 
											if fs.exists(fs.combine(p[pnum].hist[p[pnum].histSpot],name)) then 
												name=name.."-"
											else 
												break 
											end 
										end 
										----game.l(name)
										if check ==1 then 
											fs.makeDir(fs.combine(p[pnum].hist[p[pnum].histSpot],name))
										else 
											local file = fs.open(fs.combine(p[pnum].hist[p[pnum].histSpot],name),"w")
											file.write("")
											file.close()
										end 
										p[pnum].arr[name] = {}
										p[pnum].arr[name].x = (evts[3]+1)-p[pnum].xPos
										p[pnum].arr[name].y = evts[4]
										--p[pnum].mArr = {}
									elseif check==3 then 
										loadArrange(pnum,true)
									end 
								end 
								p[pnum].rcBox = nil 
								p[pnum].rObj=nil
								refreshSidebar()
								refrshDeskBack(1)
								renderIcons(1,p[1].xPos,p[1].maxXPos)
								if p[2] then 
									refrshDeskBack(2)
									renderIcons(2,p[2].xPos,p[2].maxXPos)
								end 
								

							else 
								p[pnum].rcBox = nil 
								p[pnum].rObj=nil
								refreshSidebar()
								refrshDeskBack(1)
								renderIcons(1,p[1].xPos,p[1].maxXPos)
								if p[2] then 
									refrshDeskBack(2)
									renderIcons(2,p[2].xPos,p[2].maxXPos)
								end 
								
							end 
						else 
							for i,o in pairs(p[pnum].arr) do 
								if evts[3] < p[pnum].maxXPos and evts[3] > p[pnum].xPos-1 then 
									if p[pnum].arr[i].x+(p[pnum].xPos-1) <= evts[3] then 
										if p[pnum].arr[i].y <= evts[4] then 
											if p[pnum].arr[i].x+4+(p[pnum].xPos-1) >= evts[3] then 
												if p[pnum].arr[i].y+3>= evts[4] then 
													p[pnum].pressing = i
													break
												end 
											end 
										end 
									end 
								end 
							end 
						end
					end 
				elseif evts[1] == "mouse_drag" and p[pnum].pressing then 
					local noScrolly = evts[4]
					evts[4] = (evts[4] or 0) - p[pnum].scroll
					local Do = true 
					local op 
					if pnum==1 then 
						op =2
					else 
						op=1 
					end 
					Do = dragIntoOther(evts,pnum,op,noScrolly)

					if Do then 
						p[pnum].arr[p[pnum].pressing].x=evts[3]-(p[pnum].xPos-1)
						p[pnum].arr[p[pnum].pressing].y=evts[4]
					end 
					refrshDeskBack(pnum)
					renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
					p[pnum].dragged=true 
				elseif evts[1] == "mouse_up" and p[pnum].pressing then 
					evts[4] = (evts[4] or 0) - p[pnum].scroll
					if p[pnum].dragged then 
						p[pnum].dragged = false
						saveArrange(pnum)
					else 

						if osStuff.getExt(p[pnum].pressing) == "exe" then 
							local prg = loadfile(fs.combine(p[pnum].hist[p[pnum].histSpot],fs.combine(p[pnum].pressing,"main.lua")))
							if prg then 

								--game.l"laucnh exe from filexplore"
								local realname =osStuff.spawnApp(p[pnum].pressing,prg,( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).taskBackColor or colors.white,( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).taskTextColor or colors.black,( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).taskText or "?",( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).selfRender)
								os.queueEvent("makeLegAct",realname)

							else 
								game.e("Missing main.lua in executable "..p[pnum].pressing)
							end  

						else
							local bgcolor,tcolor,txt = colors.white,colors.black,"?"
							if (osStuff.settings.extensions[osStuff.getExt(p[pnum].pressing)] or {})[1] then 
								local realname = osStuff.spawnApp(osStuff.prgName( osStuff.settings.extensions[osStuff.getExt(p[pnum].pressing)][1] ),loadfile( osStuff.settings.extensions[osStuff.getExt(p[pnum].pressing)][1] ),colors.white,colors.black,"?",false,{fs.combine(p[pnum].hist[p[pnum].histSpot],p[pnum].pressing)}) 
								osStuff.legacyMakeActive(realname)
							else 
								if fs.isDir(fs.combine(p[pnum].hist[p[pnum].histSpot],p[pnum].pressing)) then 
									if desktopMode then 
										local realname=osStuff.spawnApp("Files.exe",loadfile("desktop/Files.exe/main.lua"),colors.orange,colors.black,"F",true,{fs.combine(p[pnum].hist[p[pnum].histSpot],p[pnum].pressing)})
										os.queueEvent("makeLegAct",realname)
									else 
										
										p[pnum].hist[p[pnum].histSpot+1] = fs.combine(p[pnum].hist[p[pnum].histSpot],p[pnum].pressing)
										p[pnum].histSpot = p[pnum].histSpot+1
										p[pnum].scroll = 0
										refrshDeskBack(pnum)
										loadArrange(pnum)
										refreshLocation()
										renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)

									end 
								else 
									local realname = osStuff.spawnApp(osStuff.prgName( osStuff.settings.extensions.none[1] ),loadfile( osStuff.settings.extensions.none[1] ),colors.white,colors.black,"?",false,{fs.combine(p[pnum].hist[p[pnum].histSpot],p[pnum].pressing)}) 
									osStuff.legacyMakeActive(realname)
								end 
							end 
						end 
					end 
					p[pnum].pressing=false
				end 
			end 
		end 
	end 
end 
main()
