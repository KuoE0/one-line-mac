# Bootstrap Ninja

Setup my macOS and Linux with one line command.

## Prerequisite

- Setup SSH key to allow to access GitHub repo.
- (macOS only) Sign-in App Store
- (macOS only) Make terminal have the permission with accessibility.
	- System Preferences → Security & Privacy → (Tab) Privacy → Accessibility
		- Add Terminal.app
		- Check the checkbox
- (macOS only) Create a certificate for lldb to make "--with-lldb" work when installing llvm.
	- Ignore if debugger is not necessary.
    - See [https://opensource.apple.com/source/lldb/lldb-69/docs/code-signing.txt](https://opensource.apple.com/source/lldb/lldb-69/docs/code-signing.txt)

## Download & Run

```
$ curl -o bootstrap-ninja.zip https://github.com/kuoe0/bootstrap-ninja/archive/master.zip
$ unzip bootstrap-ninja.zip
$ cd bootstrap-ninja-master && ./setup.sh
```

## Misc.

### (macOS) Use Touch ID to authenticate `sudo` command

Add the following line to the top of /etc/pam.d/sudo.

```
auth sufficient pam_tid.so
```
## ToDo

Install the packages that need password to install first
- [brew] zsh (when do `chsh`)
- [cask] google-drive-file-stream
- [cask] adobe-creative-cloud
- [cask] osxfuse (gocryptfs's dependency)
