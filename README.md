# claude-skills — Catálogo Global de Setup Claude Code

Repositorio privado de **Yhosw** para replicar el setup completo de Claude Code en cualquier PC nueva.

> **Fecha de última actualización:** 2026-03-20
> **Modelo preferido:** `opusplan` | **Canal:** `latest`

---

## Índice

1. [Plugins de Marketplace](#1-plugins-de-marketplace)
2. [Skills Locales (este repo)](#2-skills-locales-este-repo)
3. [MCP Servers Externos](#3-mcp-servers-externos)
4. [MCP Servers claude.ai (integrados)](#4-mcp-servers-claudeai-integrados)
5. [Marketplace Propio](#5-marketplace-propio-este-repo)
6. [Configuración settings.json](#6-configuración-settingsjson)
7. [Orden de Instalación Recomendado](#7-orden-de-instalación-recomendado)

---

## 1. Plugins de Marketplace

Instalación via `/install-skill <marketplace>` dentro de Claude Code.

| Plugin | Repo GitHub | Versión | Skills incluidas | Comando de instalación |
|--------|-------------|---------|-----------------|------------------------|
| **superpowers** | `obra/superpowers-marketplace` | 5.0.2 | TDD, debugging, brainstorming, planning, writing-plans, executing-plans, code-review, git-worktrees, parallel-agents | `/install-skill superpowers-marketplace` |
| **context-mode** | `mksglu/context-mode` | 1.0.25 | Plugin + MCP Server + Hooks (ahorro ~98% contexto, ctx_execute, ctx_batch_execute) | `/install-skill context-mode` |
| **claude-mem** | `thedotmack/claude-mem` | 10.5.5 | Plugin + MCP Server (memoria cross-session, smart_search, timeline) | `/install-skill thedotmack` |
| **claude-plugins-official** | `anthropics/claude-plugins-official` | — | frontend-design, code-review, skill-creator | `/install-skill claude-plugins-official` |
| **ui-ux-pro-max** | `nextlevelbuilder/ui-ux-pro-max-skill` | 2.0.1 | Diseño UI/UX (50+ estilos, 10 stacks, 161 paletas) | `/install-skill ui-ux-pro-max-skill` |
| **yhosw-skills** | `Yhoswar/claude-skills` | — | Skills locales de este repo | Ver sección 2 y 5 |

**Skills activas en settings.json:**
```json
"enabledPlugins": {
  "frontend-design@claude-plugins-official": true,
  "code-review@claude-plugins-official": true,
  "skill-creator@claude-plugins-official": true,
  "claude-mem@thedotmack": true,
  "ui-ux-pro-max@ui-ux-pro-max-skill": true,
  "superpowers@superpowers-marketplace": true,
  "context-mode@context-mode": true,
  "yhosw-skills@yhosw-skills": true
}
```

---

## 2. Skills Locales (este repo)

Estas skills se instalan copiando este repo o registrándolo como marketplace (ver sección 5).

| Skill | Carpeta | Descripción |
|-------|---------|-------------|
| **cost-reducer** | `/cost-reducer/` | Optimización de costos cloud/infra, queries, CDN, serverless |
| **humanizer** | `/humanizer/` | Eliminar señales de escritura AI en textos |
| **researcher** | `/researcher/` | Investigación profunda con web search y síntesis multi-fuente |
| **security** | `/security/` | Seguridad web/desktop — OWASP Top 10, XSS, CSRF, SQL injection |
| **self-healing** | `/self-healing/` | Auto-mejora: patrones, memoria, creación de skills |
| **frontend-design** | `/frontend-design/` | Interfaces web production-grade con alta calidad de diseño |
| **composio** | `/composio/` | Integración con herramientas via Composio |
| **create-skill** | `/create-skill/` | Helper para crear nuevas skills |
| **customer-support** | `/customer-support/` | Atención al cliente, respuestas y flujos |
| **know-me** | `/know-me/` | Contexto personal y preferencias del usuario |
| **n8n** | `/n8n/` | Automatización de flujos con n8n |
| **scalability** | `/scalability/` | Patrones de escalabilidad para sistemas |
| **trigger-dev** | `/trigger-dev/` | Jobs y tareas en background con Trigger.dev |
| **claude-seo** | `/claude-seo/` | Suite SEO completa (audit, keywords, meta, schema, speed, etc.) — **instalar por proyecto** |

> **Nota:** `claude-seo` se recomienda instalar localmente por proyecto según necesidad, no globalmente.

**Instalación manual (nueva PC):**
```bash
git clone https://github.com/Yhoswar/claude-skills.git ~/.claude/skills/yhosw-skills
```
O bien registrar como marketplace propio (ver sección 5).

---

## 3. MCP Servers Externos

Configurados via `claude mcp add`. Requieren tokens/API keys propios.

| MCP Server | Comando de instalación | Estado | Notas |
|------------|----------------------|--------|-------|
| **context7** | `claude mcp add context7 -- npx -y @upstash/context7-mcp` | ✓ Connected | Docs up-to-date de librerías |
| **21st-magic** | `claude mcp add 21st-magic -- npx -y @21st-dev/magic@latest` | ✓ Connected | Componentes UI de 21st.dev |
| **nano-banana** | `claude mcp add nano-banana -- npx -y nano-banana-mcp` | ✓ Connected | Generación/edición de imágenes con Gemini |
| **stitch** | `claude mcp add stitch --transport http https://stitch.googleapis.com/mcp` | ✓ Connected | Stitch by Google |
| **figma** | `claude mcp add figma --transport http https://mcp.figma.com/mcp` | ✓ Connected | Lectura/escritura de diseños Figma — requiere token Figma |
| **Mermaid Chart** | `claude mcp add mermaid-chart --transport http https://chatgpt.mermaid.ai/anthropic/mcp` | ✗ Failed | Validación y render de diagramas Mermaid |

> **Nota para Figma y Stitch:** Son servidores HTTP, usar flag `--transport http`.
> **Nota para context7, 21st-magic, nano-banana:** Son servidores npx locales, no llevan flag de transport.

### Variables de entorno requeridas

| MCP | Variable | Descripción |
|-----|----------|-------------|
| nano-banana | `GEMINI_API_KEY` | Clave de Google AI Studio |
| figma | Token en header | Configurar via `claude mcp add figma -H "Authorization: Bearer <TOKEN>"` |

---

## 4. MCP Servers claude.ai (integrados)

Estos MCP se conectan desde claude.ai y requieren autenticación OAuth en la primera sesión.

| MCP Server | URL | Estado |
|------------|-----|--------|
| **Airtable** | `https://mcp.airtable.com/mcp` | Needs authentication |
| **Gmail** | `https://gmail.mcp.claude.com/mcp` | Needs authentication |
| **Google Calendar** | `https://gcal.mcp.claude.com/mcp` | Needs authentication |

> Estos se instalan desde la interfaz de Claude.ai, no desde CLI.

---

## 5. Marketplace Propio (este repo)

Este repositorio está registrado como marketplace propio bajo el nombre `yhosw-skills`.

### Cómo registrarlo en una PC nueva

Agregar en `~/.claude/settings.json`:

```json
"extraKnownMarketplaces": {
  "yhosw-skills": {
    "source": {
      "source": "github",
      "repo": "Yhoswar/claude-skills"
    }
  }
}
```

Luego instalar con:
```
/install-skill yhosw-skills
```

---

## 6. Configuración settings.json

`~/.claude/settings.json` completo de referencia:

```json
{
  "model": "opusplan",
  "autoUpdatesChannel": "latest",
  "enabledPlugins": {
    "frontend-design@claude-plugins-official": true,
    "code-review@claude-plugins-official": true,
    "skill-creator@claude-plugins-official": true,
    "claude-mem@thedotmack": true,
    "ui-ux-pro-max@ui-ux-pro-max-skill": true,
    "superpowers@superpowers-marketplace": true,
    "context-mode@context-mode": true,
    "yhosw-skills@yhosw-skills": true
  },
  "extraKnownMarketplaces": {
    "thedotmack": {
      "source": { "source": "github", "repo": "thedotmack/claude-mem" }
    },
    "ui-ux-pro-max-skill": {
      "source": { "source": "github", "repo": "nextlevelbuilder/ui-ux-pro-max-skill" }
    },
    "superpowers-marketplace": {
      "source": { "source": "github", "repo": "obra/superpowers-marketplace" }
    },
    "context-mode": {
      "source": { "source": "github", "repo": "mksglu/context-mode" }
    },
    "yhosw-skills": {
      "source": { "source": "github", "repo": "Yhoswar/claude-skills" }
    }
  }
}
```

### CLAUDE.md global

Archivo en `~/.claude/CLAUDE.md`. Configura:
- **Idioma:** Responder siempre en español
- **context-mode:** Cuándo usar ctx_execute vs ctx_fetch_and_index
- **claude-mem:** Cuándo usar smart_search vs búsqueda en sesión
- **Proyectos activos:** Tabla con rutas y CLAUDE.md por proyecto

---

## 7. Orden de Instalación Recomendado

```bash
# 1. Instalar Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Registrar marketplaces externos en settings.json
# (editar ~/.claude/settings.json con los extraKnownMarketplaces de la sección 6)

# 3. Instalar plugins de marketplace (dentro de Claude Code)
/install-skill superpowers-marketplace
/install-skill context-mode
/install-skill thedotmack
/install-skill claude-plugins-official
/install-skill ui-ux-pro-max-skill
/install-skill yhosw-skills

# 4. Configurar MCP servers externos
claude mcp add context7 -- npx -y @upstash/context7-mcp
claude mcp add 21st-magic -- npx -y @21st-dev/magic@latest
claude mcp add nano-banana -- npx -y nano-banana-mcp
claude mcp add stitch --transport http https://stitch.googleapis.com/mcp
claude mcp add figma --transport http https://mcp.figma.com/mcp

# 5. Configurar CLAUDE.md global
# Copiar ~/.claude/CLAUDE.md desde backup o crear uno nuevo

# 6. Verificar setup
claude mcp list
```

### Verificación post-instalación

```bash
claude mcp list
# Debe mostrar: context7 ✓, 21st-magic ✓, nano-banana ✓, stitch ✓, figma ✓
# + plugin:claude-mem:mcp-search ✓, plugin:context-mode:context-mode ✓
```

---

## Componentes totales: 20+

| Categoría | Cantidad |
|-----------|----------|
| Plugins/Skills de marketplace | 8 activos |
| Skills locales en este repo | 13 |
| MCP servers externos (CLI) | 5 activos + 1 fallido |
| MCP servers claude.ai | 3 (OAuth) |
| **Total** | **~30 componentes** |
