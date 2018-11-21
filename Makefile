
resolve:
	swift package resolve

xcode:
	swift package generate-xcodeproj

unresolve:
	rm -rf Package.resolved

reset: unresolve resolve xcode

build:
	swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.14"

