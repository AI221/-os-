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


local bg = game.loadMapOld("library/defDesk", 0, 0,colors.white,colors.black,"?",51,18)
local function refrshDeskBack(pnum)
	if (type(pnum)=="number") then else 
		error("lel",2) end
	term.setBackgroundColor(deskBack)
	local x,y=term.getSize()
	local str = ""
	for i=1,p[pnum].maxXPos do 
		str=str.." "
	end
	for i=5,y do
		term.setCursorPos(p[pnum].xPos,i)
		term.write(str)
	end --sleep(2)
	if desktopMode then 
		bg.render.blit(1,1,1,1)
	end 
end 
local args = {...}
--[[if not args[1] then 
	args = osStuff.getArgs()
end ]]
game.l("Files got args "..textutils.serialize(args))

if (args or {})[1] then 
	if args[1] == "-desktop" then 
		desktopMode = true 
		p[1].histSpot = 1
		p[1].hist = {} 
		p[1].hist[p[1].histSpot] = args[2]
		p[1].maxXPos=term.getSize()
		game.l"--FILES IN DESKTOP MODE--"
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
end 
term.clear()
term.setCursorPos(1,1)
local icns = {}
local folderIcn = game.loadMapOld("library/icon/folder", 0, 0,colors.white,colors.black,"?",4,3)
local wtf = game.loadMapOld("library/icon/unknown", 0, 0,colors.white,colors.black,"?",4,3)
for i,o in pairs(osStuff.settings.fileTypeDefIcons) do 
	icns[i] = game.loadMapOld(o, 0, 0,colors.white,colors.black,"?",4,3)
end 
--make buttons
p[1].guiButs = game.addButton(" < ",term.getSize()-12,1,colors.blue,colors.black)
game.addButton(" > ",term.getSize()-7,1,colors.blue,colors.black,p[1].guiButs)
game.addButton(" ^ ",term.getSize()-2,1,colors.blue,colors.black,p[1].guiButs)

if p[2] then 
	p[2].guiButs = game.addButton(" < ",term.getSize()-12,3,colors.blue,colors.black)
	game.addButton(" > ",term.getSize()-7,3,colors.blue,colors.black,p[2].guiButs)
	game.addButton(" ^ ",term.getSize()-2,3,colors.blue,colors.black,p[2].guiButs)
	game.addButton(">",1,4,colors.blue,colors.black,p[2].guiButs)
	--game.addButton(">",1,4,colors.blue,colors.black,p[2].guiButs)
end 
local function renderIcons(pnum,xPos,maxXPos)
	
	
	--temo:
	--pnum,xPos,maxXPos = 1,1,19
	--[[p[pnum].hist = {}
	p[pnum].histSpot=1
	p[pnum].hist[p[pnum].histSpot]="/testing"]]
 	
	game.l("files rendering for "..p[pnum].hist[p[pnum].histSpot])
	if not fs.isDir(p[pnum].hist[p[pnum].histSpot]) then --wtf?
		game.e("Files was not given a valid directory ("..p[pnum].hist[p[pnum].histSpot].."). Going to root directory(/)")
		p[pnum].hist[p[pnum].histSpot] = "/"
	end 
	local stuff = fs.list(p[pnum].hist[p[pnum].histSpot])
	if not stuff then return false end 
	--game.l"ALIVE"
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




	for i=1,table.maxn(stuff) do 
 
		if string.sub(stuff[i],1,1)~="." then 
			p[pnum].arr[stuff[i]] = p[pnum].arr[stuff[i]] or {}
			p[pnum].arr[stuff[i]].x = p[pnum].arr[stuff[i]].x or 1
			p[pnum].arr[stuff[i]].y = p[pnum].arr[stuff[i]].y or 1
			if (p[pnum].arr[stuff[i]].x+2 > maxXPos or p[pnum].arr[stuff[i]].x+xPos < xPos) then
				p[pnum].arr[stuff[i]].x = 1
			end 
			if (p[pnum].mArr[stuff[i]] or {}).icn then --fs.exists( fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],stuff[i]) ,"iconOld") ) then 
				term.setBackgroundColor(colors.black)
				term.setTextColor(colors.white)
				p[pnum].mArr[stuff[i]].icn.render.blit(1,1,p[pnum].arr[stuff[i]].x,p[pnum].arr[stuff[i]].y+p[pnum].scroll)
			elseif icns[string.lower(osStuff.getExt(stuff[i]) )] then 
				 ( (icns[string.lower( osStuff.getExt(stuff[i] ) )].render or {}).blit or function()end)(1,1,p[pnum].arr[stuff[i]].x+xPos-1    ,p[pnum].arr[stuff[i]].y+p[pnum].scroll)
			elseif fs.isDir( fs.combine(p[pnum].hist[p[pnum].histSpot],stuff[i]) ) then --this is last because some extensions are folders
				folderIcn.render.blit(1,1,p[pnum].arr[stuff[i]].x+xPos-1    ,p[pnum].arr[stuff[i]].y+p[pnum].scroll)
			else 
				wtf.render.blit(1,1,p[pnum].arr[stuff[i]].x+xPos-1   ,p[pnum].arr[stuff[i]].y+p[pnum].scroll)
			end 
			--render the text below
			local txt = stuff[i]
			if string.sub(txt,#txt-3,#txt-3) == "." and (not osStuff.settings.desktop.showExtension) then 
				txt=string.sub(txt,1,#txt-4)
			end 
			if #txt >= osStuff.settings.desktop.maxIcnLength then 
				txt=string.sub(txt,1,osStuff.settings.desktop.maxIcnLength-2)..".."
			end 
			term.setBackgroundColor(deskBack)
			term.setTextColor(colors.black)
			term.setCursorPos(math.floor((4-#txt)/2)+p[pnum].arr[stuff[i]].x+xPos-1    ,p[pnum].arr[stuff[i]].y+3+p[pnum].scroll)
			term.write(txt)		
		end 
	end 
	--render the GUI
	--render background
	if not desktopMode then 
		if pnum then 
		local x,y =term.getSize()
		term.setBackgroundColor(colors.gray)
		for i=5,y do 
			term.setCursorPos(math.floor(x/2),i)
			term.write" "
		end  end--for pnum
		paintutils.drawLine(1,1,term.getSize(),1,colors.lightBlue)
		paintutils.drawLine(1,2,term.getSize(),2,colors.lightBlue)
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
		end 
		game.drawButtons(p[1].guiButs)
		paintutils.drawLine(1,3,term.getSize(),3,colors.lightBlue)
		paintutils.drawLine(1,4,term.getSize(),4,colors.lightBlue)
		paintutils.drawLine(3,3,term.getSize()-15,3,colors.white)
		term.setCursorPos(3,3)    
		term.write"/"
		term.setCursorPos(3,3)  
		term.write(  string.sub( p[2].hist[p[2].histSpot],  math.max( 1, #p[2].hist[p[2].histSpot]-(term.getSize()-18) ), #p[2].hist[p[2].histSpot]  )  )
		if #p[2].hist[p[2].histSpot]-(term.getSize()-18) > 1 then 
			term.setCursorPos(2,p[pnum].menuY)
			term.setBackgroundColor(colors.cyan)
			term.setTextColor(colors.black)
			term.write"<"
		end 
		game.drawButtons(p[2].guiButs)
	end 

	osStuff.renderMe()

end 
local function saveArrange(pnum)
	--game.l("~~arr: "..tostring(pnum))
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
local function loadArrange(pnum)
	p[pnum].arr,p[pnum].mArr = {},{}
	local loadSpot = fs.combine(p[pnum].hist[p[pnum].histSpot],".arrange")
	if desktopMode then 
		loadSpot=loadSpot.."desktop"
	end 
	if fs.isReadOnly(loadSpot) == "noAccess" then 
		game.e("Couldn't load "..loadSpot.." as the file is no-access")
		return 
	end 
	local f = fs.open(  loadSpot,"r")
	if not f then game.e("Couldn't open "..loadSpot.."/.arrange!") return false end 
	local ser 
	ser=f.readAll()
	ser = textutils.unserialize(ser)
	if not ser then game.e"Failed to serialize p[pnum].arrangement!" end 
	f.close()
	p[pnum].arr=ser
	if not p[pnum].arr then 
		p[pnum].arr = {}
	end 
	--load icons & settings
	local remtab = {}
	for i,o in pairs(p[pnum].arr or {}) do 
		if not fs.exists(fs.combine(p[pnum].hist[p[pnum].histSpot],i)) then 
			remtab[#remtab+1] = i
			--game.l("nop "..i)
		end 
		if fs.exists( fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],i) ,"iconOld") ) then 
			p[pnum].mArr[i]=p[pnum].mArr[i]or{}
			p[pnum].mArr[i].icn  = game.loadMapOld(fs.combine(fs.combine(p[pnum].hist[p[pnum].histSpot],i),"iconOld"), 0, 0,colors.white,colors.black,"?",4,3)
		end
		if fs.exists( fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],i) ,"config.lua")  ) then 
			p[pnum].mArr[i]=p[pnum].mArr[i]or{}
			local conf,unSerCont = fs.open(fs.combine( fs.combine(p[pnum].hist[p[pnum].histSpot],i) ,"config.lua") ,"r")
			game.l"s"
			if conf then 
				game.l"2"
				unSerCont = conf.readAll()
				conf.close() 
				if unSerCont then 
					game.l("suc "..i) 
					p[pnum].mArr[i].cfg=textutils.unserialize(unSerCont)
					game.l(tostring(p[pnum].mArr[i].cfg))
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
		local evts = {os.pullEvent()}
		local resetY = evts[4]
		--game.l(textutils.serialize(evts))
		--game.l"cy"
		if evts[1]=="mouse_scroll" and not desktopMode then 
			if osStuff.settings.scrollCorrectly then 
				evts[2] = evts[2] *-1
			end
			if evts[3] < p[1].maxXPos then 
				game.l"gotScroll"
				p[1].scroll = p[1].scroll+evts[2]
				refrshDeskBack(1)
				renderIcons(1,p[1].xPos,p[1].maxXPos)
				if p[1].rcBox then 
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
					game.l"click"
					if (noScrolly <= ((p[2] or {}).menuY or 1)+1) and (not desktopMode) then 
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
							renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
						elseif bNum == 1 and p[pnum].histSpot > 0 then 
							p[pnum].histSpot = p[pnum].histSpot-1
							refrshDeskBack(pnum)
							loadArrange(pnum)
							renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
						elseif bNum ==2 and p[pnum].histSpot < #p[pnum].hist then 
							p[pnum].histSpot=p[pnum].histSpot+1
							refrshDeskBack(pnum)
							loadArrange(pnum)
							renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)

						else 
							if noScrolly ==p[pnum].menuY and evts[3] > 2 and evts[3] <= term.getSize()-15 then  ---Textbox, where the file dir is
								game.l"clickedTextbox"
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
								renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)
							end 
						end 
					elseif evts[2]==2 and evts[3] >= p[pnum].xPos and evts[3] < p[pnum].maxXPos then --open right click menu
						if p[pnum].rcBox and ( not p[pnum].rcBox:check(evts) ) then 
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
						game.l("Right clicked "..tostring(p[pnum].rObj))
						if (not p[pnum].rcBox) or not p[pnum].rcBox:check(evts) then 
							if p[pnum].rObj then 
								p[pnum].rcBox = osStuff.rightClick({"Full name >", "WIP-Properties >","Rename >","Copy >","Delete >"},evts[3]+1,noScrolly,colors.blue,colors.black)
							else 
								p[pnum].rcBox = osStuff.rightClick({"New file","New Folder"},evts[3]+1,noScrolly,colors.blue,colors.black)
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
					else 
						if p[pnum].rcBox then 
							game.l"hasRightClickBox"
							evts[4] = evts[4]+p[pnum].scroll
							local check = p[pnum].rcBox:check(evts)
							if check then 
								game.l("clicked "..check)
								if p[pnum].rObj then 
									if check==0 then --Full Name
										osStuff.popup(nil,9,25,nil,tostring(p[pnum].rObj),"Full Name",false)
									elseif check==1 then --properties

									elseif check==2 then --Rename

									elseif check==3 then --Copy
										local name = fs.combine( p[pnum].hist[p[pnum].histSpot] , p[pnum].rObj )
										fs.copy(name,name.."-Copy")
									elseif check ==4 then --Delete
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
										local name = "New folder"
										if check ==1 then name="New File" end 
										while true do 
											if fs.exists(fs.combine(p[pnum].hist[p[pnum].histSpot],name)) then 
												name=name.."-"
											else 
												break 
											end 
										end 
										game.l(name)
										if check ==1 then 
											fs.makeDir(fs.combine(p[pnum].hist[p[pnum].histSpot],name))
										else 
											local file = fs.open(fs.combine(p[pnum].hist[p[pnum].histSpot],name),"w")
											file.write("")
											file.close()
										end 
									end 
								end 
								p[pnum].rcBox = nil 
								p[pnum].rObj=nil
								refrshDeskBack(1)
								renderIcons(1,p[1].xPos,p[1].maxXPos)
								if p[2] then 
									refrshDeskBack(2)
									renderIcons(2,p[2].xPos,p[2].maxXPos)
								end 
							else 
								p[pnum].rcBox = nil 
								p[pnum].rObj=nil
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

								game.l"laucnh exe from filexplore"
								local realname =osStuff.spawnApp(p[pnum].pressing,prg,( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).taskBackColor or colors.white,( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).taskTextColor or colors.black,( (p[pnum].mArr[p[pnum].pressing] or {}).cfg or {}).taskText or "?")
								os.queueEvent("makeLegAct",realname)

							else 
								game.e("Missing main.lua in executable "..p[pnum].pressing)
							end  

						else
							local bgcolor,tcolor,txt = colors.white,colors.black,"?"
							if (osStuff.settings.extensions[osStuff.getExt(p[pnum].pressing)] or {})[1] == "rom/programs/edit" then 
								bgcolor,tcolor,txt = colors.black,colors.white,"E"
							end 
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
									renderIcons(pnum,p[pnum].xPos,p[pnum].maxXPos)

								end 
							else 
								osStuff.spawnApp(p[pnum].pressing,run,bgcolor,tcolor,txt)
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