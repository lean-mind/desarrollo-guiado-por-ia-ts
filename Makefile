.PHONY: generate-agents check-agents preview-agents sync-ai sync-ai-dry-run sync-ai-claude sync-ai-codex sync-ai-opencode sync-ai-cursor sync-ai-ps sync-ai-ps-dry-run

PLATFORM ?= all
AGENT ?=

GENERATOR_ARGS = --platform $(PLATFORM)
ifneq ($(AGENT),)
GENERATOR_ARGS += --agent $(AGENT)
endif

generate-agents:
	scripts/generate-agents $(GENERATOR_ARGS)

check-agents:
	scripts/generate-agents --check --platform $(PLATFORM)

preview-agents:
	scripts/generate-agents --dry-run $(GENERATOR_ARGS)

sync-ai:
	bash scripts/sync-ai.sh --platform $(PLATFORM)

sync-ai-dry-run:
	bash scripts/sync-ai.sh --dry-run --platform $(PLATFORM)

sync-ai-claude:
	bash scripts/sync-ai.sh --platform claude

sync-ai-codex:
	bash scripts/sync-ai.sh --platform codex

sync-ai-opencode:
	bash scripts/sync-ai.sh --platform opencode

sync-ai-cursor:
	bash scripts/sync-ai.sh --platform cursor

sync-ai-ps:
	powershell -ExecutionPolicy Bypass -File scripts/sync-ai.ps1 -Platform $(PLATFORM)

sync-ai-ps-dry-run:
	powershell -ExecutionPolicy Bypass -File scripts/sync-ai.ps1 -Platform $(PLATFORM) -DryRun
