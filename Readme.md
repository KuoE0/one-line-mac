# Bootstrap for Mac

Setup my macOS with one line command.

## Requirement

- Install Xcode and agree the agreement.
- Make terminal have the permission with accessibility.
	- System Preferences -> Security & Privacy -> Privacy (Tab) -> Accessibility -> Add Terminal.app and check the checkbox
- Create a certificate for lldb to make "--with-lldb" work when installing llvm.
    - See [https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt](https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt)
