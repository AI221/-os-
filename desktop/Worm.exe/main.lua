shell.run"worm"
term.clear()term.setCursorPos(1,1)
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
print"apps are not capable of quiting yet. this will hang."
while true do coroutine.yield() end 
