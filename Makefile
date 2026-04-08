.PHONY: sync-ai sync-ai-ps

sync-ai:
	bash scripts/sync-ai.sh

sync-ai-ps:
	powershell -ExecutionPolicy Bypass -File scripts/sync-ai.ps1
