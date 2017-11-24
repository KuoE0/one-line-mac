# Bootstrap for Mac

Setup my macOS with one line command.

## Requirement

- Make terminal have the permission with accessibility.
	- System Preferences → Security & Privacy → (Tab) Privacy → Accessibility
		- Add Terminal.app
		- Check the checkbox
- Create a certificate for lldb to make "--with-lldb" work when installing llvm.
    - See [https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt](https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt)
- Prepare the ssh key

## Other

### Use Touch ID to authenticate `sudo` command

Add the following line to the top of /etc/pam.d/sudo.

```
auth sufficient pam_tid.so
```
