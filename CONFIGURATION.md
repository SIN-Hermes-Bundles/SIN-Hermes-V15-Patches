# Configuration Guide

## Overview

The V15 Patches bundle adds progressive tool loading and compression fixes to Hermes.

## Configuration

### ~/.hermes/config.yaml

```yaml
tool_search:
  mode: auto           # auto | always | never
  threshold: 0.10      # 10% of context length
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
    - browser_navigate
    - browser_snapshot
    - browser_click
    - browser_type
    - browser_scroll
    - browser_console
    - browser_press
    - browser_get_images
    - browser_vision
    - browser_back

# Compression settings
compression:
  max_attempts: 5
  retry_on_failure: false
```

## Patch Files

### Tool Search

```python
# tools/tool_search.py
# Enables tool_search and tool_details meta-tools
```

### Registry

```python
# tools/registry.py
# Adds get_catalog() and get_single_definition()
```

### Model Tools

```python
# model_tools.py
# Adds deferred tool loading logic
```

## Advanced Configuration

### Custom Pinned Tools

```yaml
# Add custom tools to pinned list
tool_search:
  pinned_tools:
    - tool_search
    - tool_details
    - your_custom_tool
```

### Threshold Adjustment

```yaml
# Lower threshold for more aggressive deferral
tool_search:
  threshold: 0.05

# Higher threshold for less deferral
tool_search:
  threshold: 0.20
```

## Environment Variables

```bash
export HERMES_TOOL_SEARCH_MODE=auto
export HERMES_TOOL_SEARCH_THRESHOLD=0.10
```

## Troubleshooting

### Tools not loading

```bash
# Check tool search status
curl http://localhost:9998/health | grep tool_search

# Re-apply patches
./patch.sh
```

### Deferral issues

```bash
# Check current tools
hermes chat -Q -q "list all loaded tools"

# Force all tools
# Set mode: never in config
```

---
*Last updated: 2026-05-30*
