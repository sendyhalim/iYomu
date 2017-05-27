platform = --platform ios
xcode_flags = -project "Yomu.xcodeproj" -scheme "Yomu" -configuration "Release" DSTROOT=/tmp/Yomu.dst
xcode_flags_test = -project "Yomu.xcodeproj" -scheme "Yomu" -configuration "Debug"
components_plist = "Supporting Files/Components.plist"
temporary_dir = /tmp/Yomu.dst

bootstrap:
	carthage bootstrap $(platform)

update:
	carthage update $(platform)

synx:
	synx Yomu.xcodeproj

clean:
	rm -rf $(temporary_dir)
	xcodebuild $(xcode_flags) clean

test: clean bootstrap
	xcodebuild $(xcode_flags_test) test

lint:
	swiftlint

.PHONY: bootstrap update synx clean test lint

