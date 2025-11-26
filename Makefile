.PHONY: generate clean regenerate
.ONESHELL:

SHELL := /bin/zsh

generate:
	@START_TIME=$$(date +%s); \
	tuist install; \
	tuist generate --no-open; \
	END_TIME=$$(date +%s); \
	echo "Generate Completed ✅\nTotal time: taken $$((END_TIME - START_TIME)) seconds"; \
	xed .


clean:
	rm -f Tuist/Package.resolved
	rm -rf **/*.xcodeproj
	rm -rf **/*.xcworkspace
	rm -rf Tuist/.build
	rm -rf **/Derived
	tuist clean


reset: clean generate
