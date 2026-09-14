MODULE := TKSwitcherCollection
DEMO_SCHEME := $(MODULE)Demo
DEMO_PROJECT := Demo/$(DEMO_SCHEME).xcodeproj

SIM_DEVICE ?= $(shell xcrun simctl list devices available | grep -m1 iPhone | grep -om1 'iPhone [A-Za-z0-9 ]*' | xargs)
DESTINATION ?= platform=iOS Simulator,name=$(SIM_DEVICE)

SWIFT_FORMAT ?= swift format
FORMAT_PATHS := Sources Tests Demo/Sources

.PHONY: demo build test format lint xcodegen demo-build ci

## Generate and open the demo project
demo:
	./Scripts/demo.sh

## Build the library for iOS Simulator
build:
	xcodebuild build -scheme $(MODULE) -destination '$(DESTINATION)'

## Run the library tests on iOS Simulator
test:
	xcodebuild test -scheme $(MODULE) -destination '$(DESTINATION)'

## Format Swift sources in place
format:
	$(SWIFT_FORMAT) format --in-place --recursive $(FORMAT_PATHS)

## Check formatting
lint:
	$(SWIFT_FORMAT) lint --recursive --strict $(FORMAT_PATHS)

## Regenerate the demo Xcode project
xcodegen:
	cd Demo && xcodegen generate

## Build the demo app for iOS Simulator
demo-build: xcodegen
	xcodebuild build -project $(DEMO_PROJECT) -scheme $(DEMO_SCHEME) -destination '$(DESTINATION)'

## Everything CI runs
ci: lint build test demo-build
