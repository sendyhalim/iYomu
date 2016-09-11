platform = --platform ios
xcode_flags = -project "iYomu.xcodeproj" -scheme "iYomu" -configuration "Release" DSTROOT=/tmp/iYomu.dst
xcode_flags_test = -project "iYomu.xcodeproj" -scheme "iYomu" -configuration "Debug"
components_plist = "Supporting Files/Components.plist"
temporary_dir = /tmp/iYomu.dst

bootstrap:
	carthage bootstrap $(platform) --no-use-binaries

update:
	carthage update $(platform)

synx:
	synx iYomu.xcodeproj

clean:
	rm -rf $(temporary_dir)
	xcodebuild $(xcode_flags) clean

test: clean bootstrap
	xcodebuild $(xcode_flags_test) test

lint:
	swiftlint

.PHONY: bootstrap update synx clean test lint

