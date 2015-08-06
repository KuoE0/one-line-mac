New Mac
=======

Requirement 
-----------

- Make terminal have the permission with accessibility
	- System Preferences -> Security & Privacy -> Privacy (Tab) -> Accessibility -> Add Terminal.app and check the checkbox

Todo
----

- Install core package to build package or control installation process.
- Use Json format to describe the package list.

	```javascript
	{
	  name: "",
	  description: "",
	  do_before: ["command 1", "command 2", ...],
	  do_after: ["command 1", "command 2", ...]
	}
	```

- Use Node to parse package list and control the installation.

