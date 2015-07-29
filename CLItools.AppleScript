do shell script "xcode-select --install"
delay 2

tell application "System Events"
	tell process "Install Command Line Developer Tools"
		-- keystroke return
		click button "Install" of window 1
		click button "Agree" of window "License Agreement"
	end tell

	repeat while "Install Command Line Developer Tools" is in (name of application processes)
		tell process "Install Command Line Developer Tools"
			delay 1
			keystroke return
			tell (window 1)
				tell (first button whose name is "Done")
					if exists then
						click
					end if
				end tell
			end tell
		end tell
	end repeat
	
end tell


