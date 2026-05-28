# SIN-Hermes-V15-Patches

Hermes v0.15.0 lokale Patches für SINator-Betrieb.

## Patches

### Progressive Tool Loading (tool_search)
**PR #6318 Equivalent** — Reduziert initiale Tool-Schema-Last von 26→~10 Tools.
Lädt restliche Schemas on-demand via `tool_search(query)` / `tool_details(name)`.

**Geänderte Dateien (7):**
| Datei | Änderung |
|---|---|
| `tools/tool_search.py` | **NEU** — Meta-Tools `tool_search`/`tool_details` + Auto-Registrierung |
| `tools/registry.py` | `get_catalog()`, `get_single_definition()` hinzugefügt |
| `model_tools.py` | Globals (`_all_session_tool_names`, `_deferred_catalog`), `should_defer_tools()`, `_estimate_tool_tokens()`, Dispatch für Meta-Tools, Sandbox-Fallbacks |
| `agent/prompt_builder.py` | `build_tool_catalog_prompt()` — formatiert Katalog als System-Prompt-Block |
| `agent/system_prompt.py` | Katalog-Injektion in stable tier (wenn `_tool_search_active`) |
| `agent/agent_init.py` | Deferred Filtering nach `get_tool_definitions()` |
| `agent/conversation_loop.py` | Auto-Load nach `tool_details`, Tool-Eviction vor allen 5 Compression-Call-Sites |

### 413 Compression Fix
`retry_count` Zähler wird nicht mehr bei Kompression erhöht, `max_compression_attempts=5`.

## Usage

```bash
# Apply patches
./patch.sh

# Revert patches
./unpatch.sh

# Config: tool_search block in ~/.hermes/config.yaml einfügen
# Siehe config.yaml im Repo
```

## Config

`tool_search` Block in `~/.hermes/config.yaml`:
```yaml
tool_search:
  mode: auto           # auto | always | never
  threshold: 0.10      # 10% of context = Aktivierungsschwelle
  pinned_tools:
    - tool_search
    - tool_details
    - execute_code
    - todo
    - web_search
    - read_file
    - write_file
    - skills_list
    - skill_view
    - skill_manage
```

## Testing

```bash
# Normal mode (full tools, kein Deferral bei 128k ctx)
hermes chat -Q -q "list all loaded tools"

# Deferred mode test
# → mode: always in config setzen
hermes chat -Q -q "list all loaded tools"
# → sollte nur ~10 pinned tools zeigen, aber ALLE via Katalog sehen
```
