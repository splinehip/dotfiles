tell application "Cisco AnyConnect Secure Mobility Client"
    activate
end tell
repeat until application "Cisco AnyConnect Secure Mobility Client" is running
	delay 1
end repeat
tell application "System Events"
    repeat until (window 1 of process "Cisco AnyConnect Secure Mobility Client" exists)
	    delay 1
	end repeat

	repeat until (window 2 of process "Cisco AnyConnect Secure Mobility Client" exists)
		delay 1
	end repeat

	tell process "Cisco AnyConnect Secure Mobility Client"
		click button "Disconnect" of window 2
	end tell
	set visible of application process "Cisco AnyConnect Secure Mobility Client" to false
end tell
return 0
