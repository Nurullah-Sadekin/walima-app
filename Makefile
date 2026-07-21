SHELL := /bin/bash

FLUTTER ?= flutter
PATH := /usr/local/bin:/opt/homebrew/bin:$(PATH)
FIREBASE ?= firebase

# Walima Android app in the walima-a779e Firebase project.
FIREBASE_APP_ID ?= 1:249586231317:android:f14f26a2091e98ee4bc61c
RELEASE_GROUP_FILE ?= releasegroup.txt
RELEASE_NOTE_FILE ?= releasenote.txt
FIREBASE_GROUPS ?= $(shell test -f "$(RELEASE_GROUP_FILE)" && tr -d '\n\r' < "$(RELEASE_GROUP_FILE)")
FIREBASE_TESTERS ?=
RELEASE_NOTES ?= $(shell test -f "$(RELEASE_NOTE_FILE)" && cat "$(RELEASE_NOTE_FILE)" || echo "Walima release APK from $$(git rev-parse --short HEAD 2>/dev/null || echo local-build)")

APP_FLAVOR ?= dev
BUILD_DEFINES = --dart-define=APP_FLAVOR=$(APP_FLAVOR)
BUILD_ARGS ?= --release
APK_PATH ?= build/app/outputs/flutter-apk/app-release.apk

.PHONY: help clean pub-get release-apk upload-firebase release-apk-upload release \
	build-apk apptester apptester-upload firebase-upload run-dev run-prod \
	build-dev-apk build-prod-apk build-prod-aab build-prod-ipa

help:
	@echo "Available targets:"
	@echo "  make release-apk-upload  Clean, fetch packages, build, and upload Walima to Firebase App Distribution"
	@echo "  make release-apk         Build the Walima release APK only"
	@echo "  make upload-firebase     Upload the existing release APK only"
	@echo "  make run-dev             Run against the development environment"
	@echo "  make run-prod            Run against the production environment"
	@echo "  make build-dev-apk       Build a development release APK"
	@echo "  make build-prod-apk      Build a production release APK"
	@echo "  make build-prod-aab      Build a production Android App Bundle"
	@echo "  make build-prod-ipa      Build a production iOS archive"
	@echo "  make apptester           Alias for release-apk-upload"
	@echo "  make apptester-upload    Alias for upload-firebase"
	@echo "  make release             Alias for release-apk-upload"
	@echo ""
	@echo "Configuration:"
	@echo "  releasegroup.txt         Firebase App Distribution group aliases, comma-separated"
	@echo "  releasenote.txt          Release notes for the upload"
	@echo "  FIREBASE_TESTERS=...     Optional comma-separated tester emails"
	@echo "  APK_PATH=...             Optional path to an existing APK"
	@echo "  APP_FLAVOR=dev|prod      App environment (defaults to dev)"

clean:
	$(FLUTTER) clean

pub-get:
	$(FLUTTER) pub get

release-apk:
	$(FLUTTER) build apk $(BUILD_ARGS) $(BUILD_DEFINES)
	@test -f "$(APK_PATH)"

run-dev:
	$(FLUTTER) run --dart-define=APP_FLAVOR=dev

run-prod:
	$(FLUTTER) run --dart-define=APP_FLAVOR=prod

build-dev-apk:
	$(FLUTTER) build apk --release --dart-define=APP_FLAVOR=dev

build-prod-apk:
	$(FLUTTER) build apk --release --dart-define=APP_FLAVOR=prod

build-prod-aab:
	$(FLUTTER) build appbundle --release --dart-define=APP_FLAVOR=prod

build-prod-ipa:
	$(FLUTTER) build ipa --release --dart-define=APP_FLAVOR=prod

upload-firebase:
	@test -f "$(APK_PATH)" || { \
		echo "APK not found: $(APK_PATH). Run 'make release-apk' first." >&2; \
		exit 1; \
	}
	@command -v "$(FIREBASE)" >/dev/null 2>&1 || { \
		echo "Firebase CLI not found. Install firebase-tools or set FIREBASE to its path." >&2; \
		exit 127; \
	}
	@if [ "$(CI)" = "true" ] && [ -z "$${FIREBASE_TOKEN:-}" ] && [ -z "$${GOOGLE_APPLICATION_CREDENTIALS:-}" ]; then \
		echo "Missing Firebase credentials. Set FIREBASE_TOKEN or GOOGLE_APPLICATION_CREDENTIALS." >&2; \
		exit 1; \
	fi
	$(FIREBASE) appdistribution:distribute "$(APK_PATH)" \
		--app "$(FIREBASE_APP_ID)" \
		$(if $(wildcard $(RELEASE_NOTE_FILE)),--release-notes-file "$(RELEASE_NOTE_FILE)",--release-notes "$(RELEASE_NOTES)") \
		$(if $(strip $(FIREBASE_GROUPS)),--groups "$(FIREBASE_GROUPS)") \
		$(if $(strip $(FIREBASE_TESTERS)),--testers "$(FIREBASE_TESTERS)")

# Recursive calls guarantee ordering even when make is invoked with -j.
release-apk-upload:
	$(MAKE) clean
	$(MAKE) pub-get
	$(MAKE) release-apk APP_FLAVOR=prod
	$(MAKE) upload-firebase

release: release-apk-upload

# Backward-compatible aliases.
build-apk: release-apk

apptester: release-apk-upload

apptester-upload: upload-firebase

firebase-upload: upload-firebase
