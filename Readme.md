# Bootstrap Ninja

Setup my macOS and Linux with one line command.

## Prerequisite

- Setup SSH key to allow to access GitHub repo.
- (macOS only) Make terminal have the permission with accessibility.
	- System Preferences → Security & Privacy → (Tab) Privacy → Accessibility
		- Add Terminal.app
		- Check the checkbox
- (macOS only) Create a certificate for lldb to make "--with-lldb" work when installing llvm.
	- Ignore if debugger is not necessary.
    - See [https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt](https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt).

## Misc.

### (macOS) Use Touch ID to authenticate `sudo` command

Add the following line to the top of /etc/pam.d/sudo.

```
auth sufficient pam_tid.so
```
