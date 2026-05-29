# INSTALL.md — SIN-Hermes-V15-Patches

## Installation

### 1. Hermes Agent installieren
```bash
pip install hermes-agent
```

### 2. Patches anwenden
```bash
cd ~/dev/SIN-Hermes-V15-Patches
./patch.sh
```

### 3. Config anwenden
```bash
# Kopiert config.yaml nach ~/.hermes/config.yaml
# ODER: manuell den `tool_search` Block einfügen
cp config.yaml ~/.hermes/config.yaml
```

### 4. Hermes starten
```bash
hermes
```

## Verifikation

```bash
# Prüfe, ob Browser-Tools geladen sind
hermes chat -Q -q "list all loaded tools"
# → Sollte browser_navigate, browser_snapshot, etc. zeigen
```

## Troubleshooting

### Problem: Modell hängt in `todo`+`read_file` Schleife
**Lösung:** Browser-Tools müssen in `pinned_tools` sein. Siehe `config.yaml` in diesem Repo.

### Problem: `tool_search` funktioniert nicht
**Lösung:** `tool_search` und `tool_details` müssen in `pinned_tools` sein.

## Uninstall
```bash
cd ~/dev/SIN-Hermes-V15-Patches
./unpatch.sh
```

---
*Last updated: 2026-05-30*
*Version: V15.1 (Browser-Tools Fix)*
