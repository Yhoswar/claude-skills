# Init System — Claude Code Restore

> Crea snapshots de tu configuración global y restáuralos en cualquier PC.

---

## Uso

### Crear snapshot actual
```
/init create
```

### Restaurar último snapshot
```
/init restore
```

### Ver snapshots disponibles
```
/init list
```

---

## Qué incluye el snapshot

| Componente | Incluido | Nota |
|------------|----------|------|
| `~/.claude/CLAUDE.md` | ✅ | Config global |
| `~/.claude/settings.json` | ✅ | Hooks, plugins, MCPs |
| `~/.claude/skills/` | ✅ | Todos los skills |
| `~/.claude/agents/` | ✅ | Todos los agentes |
| `~/.claude/projects/` | ⚠️ | Opcional (pesado) |
| MCPs ejecutables | ⚠️ | Lista para reinstalar |
| `~/.claude-mem/` | ⚠️ | Opcional |

---

## Proceso

### Crear (en PC actual)

1. Exporta config a `init-snapshots/YYYY-MM-DD/`
2. Genera `init-restore.ps1` automáticamente
3. Commit al repo con tag `snapshot-YYYY-MM-DD`
4. Push a GitHub

### Restaurar (en nueva PC)

1. Clona/pull repo `claude-skills`
2. Detecta último snapshot
3. Copia archivos a `~/.claude/`
4. Reinstala MCPs desde lista
5. Verifica instalación

---

## Configuración personalizada

Crear `init-config.json` en la raíz del repo:

```json
{
  "include_sessions": false,
  "include_memories": false,
  "mcp_installers": {
    "google-ads-mcp": "github:your/google-ads-mcp",
    "n8n-mcp": "npm:n8n-mcp"
  }
}
```

---

## Automatización

Snapshot automático semanal (cron/scheduler):
```bash
# Windows Task Scheduler o similar
0 9 * * 1 cd /path/to/claude-skills && /init create --auto
```
