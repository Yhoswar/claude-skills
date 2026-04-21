# claude-skills — Catálogo Global de Setup Claude Code

Repositorio privado de **Yhosw** para replicar el setup completo de Claude Code en cualquier PC nueva.

> **Fecha de última actualización:** 2026-04-20
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
| ~~**superpowers**~~ *(DESHABILITADO)* | `obra/superpowers-marketplace` | 5.0.2+ | TDD, systematic-debugging, brainstorming, planning, writing-plans, executing-plans, code-review, git-worktrees, parallel-agents, verification-before-completion, subagent-driven-development | `/install-skill superpowers-marketplace` |
| **context-mode** | `mksglu/context-mode` | 1.0.22 | Plugin + MCP Server + Hooks (ahorro ~98% contexto, ctx_execute, ctx_batch_execute) | `/install-skill context-mode` |
| **claude-mem** | `thedotmack/claude-mem` | 10.5.5 | Plugin + MCP Server (memoria cross-session, smart_search, timeline) | `/install-skill thedotmack` |
| **claude-plugins-official** | `anthropics/claude-plugins-official` | — | frontend-design, code-review, skill-creator | `/install-skill claude-plugins-official` |
| **ui-ux-pro-max** | `nextlevelbuilder/ui-ux-pro-max-skill` | 2.0.1 | Diseño UI/UX (50+ estilos, 10 stacks, 161 paletas) | `/install-skill ui-ux-pro-max-skill` |
| **yhosw-skills** | `Yhoswar/claude-skills` | — | Skills locales de este repo | Ver sección 2 y 5 |

**Skills activas en settings.json** *(7 activas + 1 deshabilitada)*:
```json
"enabledPlugins": {
  "frontend-design@claude-plugins-official": true,
  "code-review@claude-plugins-official": true,
  "skill-creator@claude-plugins-official": true,
  "claude-mem@thedotmack": true,
  "ui-ux-pro-max@ui-ux-pro-max-skill": true,
  "superpowers@superpowers-marketplace": false,
  "context-mode@context-mode": true,
  "yhosw-skills@yhosw-skills": true
}
```

> **Nota (2026-04-08):** `superpowers` deshabilitado — funcionalidad cubierta por `claude-mem` + `gstack`. Se mantiene en `extraKnownMarketplaces` por si se reactiva.

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
| **emil-design-eng** | *(marketplace)* | Filosofía UI de Emil Kowalski — polish, animaciones, detalles invisibles |
| **web-accessibility** | *(marketplace)* | Accesibilidad web WCAG 2.1 — ARIA, keyboard nav, screen readers |
| **web-design-guidelines** | *(marketplace)* | Revisión de UI contra Web Interface Guidelines |
| **claude-ads** | `/claude-ads/` | Suite de publicidad paga (18 skills + 10 agentes) — Google, Meta, LinkedIn, TikTok, Microsoft, Apple |
| **claude-marketing** | `/claude-marketing/` | Suite de marketing (31 skills) — CRO, copy, email, social, branding |

> **Nota:** `claude-seo` se recomienda instalar localmente por proyecto según necesidad, no globalmente.
> **Nota:** `emil-design-eng`, `web-accessibility`, `web-design-guidelines` provienen del marketplace (plugin cache), no tienen carpeta en este repo.
> **Nota:** `claude-ads` y `claude-marketing` se instalan como skills individuales (`ads-meta`, `marketing-ideas`, etc.) vía gstack marketing bundle — las carpetas del repo son el backup de los bundles completos.

**Instalación manual (nueva PC):**
```bash
git clone https://github.com/Yhoswar/claude-skills.git ~/.claude/skills/yhosw-skills
```
O bien registrar como marketplace propio (ver sección 5).

---

## 2.5 Skills Externas (anthropics/skills)

Skills del repo oficial [`anthropics/skills`](https://github.com/anthropics/skills). **No se incluyen en este repo** para mantenerlo liviano. Se instalan como `.md` sueltos en `~/.claude/skills/`.

| Skill | Descripción |
|-------|-------------|
| **mcp-builder** | Guía para construir MCP servers en Python (FastMCP) y TypeScript |
| **pdf** | Operaciones PDF: merge, split, OCR, extraer texto/tablas, forms, cifrado |
| **docx** | Crear/editar archivos Word (.docx) con tablas de contenido, headings, etc. |

**Instalación (una vez, nueva PC):**
```bash
BASE="https://github.com/anthropics/skills/raw/refs/heads/main/skills"
curl -sL "$BASE/mcp-builder/SKILL.md" -o ~/.claude/skills/mcp-builder.md
curl -sL "$BASE/pdf/SKILL.md"         -o ~/.claude/skills/pdf.md
curl -sL "$BASE/docx/SKILL.md"        -o ~/.claude/skills/docx.md
```

**Otras disponibles** (instalar según proyecto):
- `algorithmic-art` — arte generativo con p5.js (flow fields, partículas)
- `canvas-design` — diseños visuales estáticos (PNG/PDF, posters)
- `doc-coauthoring` — co-autoría estructurada de documentación (specs, PRDs, RFCs)

---

## 2.6 Skills Externas Adicionales

Skills de terceros instaladas en `~/.claude/skills/` como archivos `.md` sueltos o repos clonados.

| Skill | Origen | Comando de instalación |
|-------|--------|----------------------|
| **content-research-writer** | ComposioHQ | `curl -L -o ~/.claude/skills/content-research-writer.md https://raw.githubusercontent.com/ComposioHQ/awesome-claude-skills/master/content-research-writer/SKILL.md` |
| **dream** | [grandamenium/dream-skill](https://github.com/grandamenium/dream-skill) | `git clone --depth 1 https://github.com/grandamenium/dream-skill.git ~/.claude/skills/dream` |

**Propósito:**

- `content-research-writer`: Asistente de escritura con research, citations, hooks, feedback por sección. Para blog posts, artículos, documentación técnica, newsletters.
- `dream`: Consolidación de memorias Claude cada 24h. Incluye sistema de **auto-dream**: el Stop hook (`should-dream.sh`) crea `~/.claude/.dream-pending` al finalizar sesión; al inicio de la siguiente sesión, el CLAUDE.md global lo detecta y ejecuta `/dream` en background. Setup requerido: agregar al Stop hook en `~/.claude/settings.json` y añadir instrucción en `~/.claude/CLAUDE.md`.

> **Nota:** `systematic-debugging` (ChrisWiles) fue eliminado — redundante con `superpowers:systematic-debugging`. Nota: `superpowers` también fue deshabilitado el 2026-04-08 (cubierto por `claude-mem` + `gstack`).

> **Ver** `docs/marketplace-skills.md` para skills del plugin cache (superpowers, emil-design-eng, web-accessibility, web-design-guidelines).

---

## 2.7 Skills de Desarrollo — gstack (garrytan/gstack)

Pack de **62 skills** de Garry Tan (CEO de Y Combinator). Incluye un equipo completo de ingeniería (32 skills core) + un equipo de marketing/CRO (30 skills). **62k estrellas en GitHub.**

**Instalación (nueva PC):**
```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

Requiere: **Bun** + **Node.js** (para /browse via Playwright)

**Skills Core (32) — Equipo de ingeniería:**

| Rol | Skills |
|-----|--------|
| CEO / Producto | `/office-hours`, `/plan-ceo-review`, `/autoplan` |
| Eng Manager | `/plan-eng-review`, `/review`, `/codex` |
| Designer | `/design-consultation`, `/design-shotgun`, `/design-html`, `/plan-design-review`, `/design-review` |
| Release Manager | `/ship`, `/land-and-deploy`, `/canary`, `/document-release` |
| QA | `/qa`, `/qa-only`, `/benchmark`, `/health` |
| Chrome / Browser | `/browse`, `/connect-chrome`, `/setup-browser-cookies` |
| Seguridad prod | `/careful`, `/freeze`, `/guard`, `/unfreeze` |
| Utilidades | `/retro`, `/investigate`, `/cso`, `/learn`, `/checkpoint`, `/gstack-upgrade` |

**Skills Marketing/CRO (30) — Bundle adicional:**

| Categoría | Skills |
|-----------|--------|
| CRO | `/form-cro`, `/page-cro`, `/popup-cro`, `/onboarding-cro`, `/signup-flow-cro`, `/paywall-upgrade-cro` |
| Marketing | `/cold-email`, `/email-sequence`, `/content-strategy`, `/copywriting`, `/copy-editing`, `/social-content`, `/marketing-ideas`, `/marketing-psychology`, `/lead-magnets`, `/launch-strategy`, `/free-tool-strategy` |
| Sales | `/sales-enablement`, `/revops`, `/referral-program`, `/pricing-strategy`, `/competitor-alternatives`, `/churn-prevention`, `/customer-research` |
| SEO/Analytics | `/programmatic-seo`, `/schema-markup`, `/analytics-tracking`, `/ab-test-setup`, `/site-architecture` |
| Contexto | `/product-marketing-context` |
| DevOps | `/setup-deploy` |

**CLAUDE.md global requerido:**
```
## gstack
Usar /browse de gstack para todo web browsing. Nunca usar mcp__claude-in-chrome__*.
```

> **Nota:** gstack se instala como subdirectorio `~/.claude/skills/gstack/`. No solapa con ningún skill suelto.

---

## 2.8 Suite de Diseño — impeccable (pbakaus/impeccable)

Pack de **18 skills** de diseño web con vocabulario profundo y guías anti-"AI slop". Instalado 2026-04-20.

**Instalación (nueva PC):**
```bash
git clone https://github.com/pbakaus/impeccable /tmp/impeccable
cp -r /tmp/impeccable/.claude/skills/* ~/.claude/skills/
```

**Skill principal:**

| Skill | Carpeta | Descripción |
|-------|---------|-------------|
| **impeccable** | `/impeccable/` | Onboarding al sistema de diseño. 7 ref docs: typography, color OKLCH, spatial, motion, interaction, responsive, ux-writing |

**18 comandos de steering:**

| Skill | Descripción |
|-------|-------------|
| `adapt` | Adaptar diseño a diferentes contextos/plataformas |
| `animate` | Añadir motion design con curvas de easing correctas |
| `audit` | Checks de calidad técnica (a11y, performance) |
| `bolder` | Amplificar diseños seguros/aburridos |
| `clarify` | Mejorar copy y mensajes de UX |
| `colorize` | Añadir color estratégico |
| `critique` | Evaluación UX con scoring y personas |
| `delight` | Añadir momentos de joy y personalidad |
| `distill` | Destilar diseños a su esencia |
| `harden` | Fortalecer interfaces contra edge cases |
| `layout` | Mejorar layout, espaciado y jerarquía visual |
| `optimize` | Diagnóstico y fixes de performance UI |
| `overdrive` | Llevar interfaces más allá de lo convencional |
| `polish` | Quality pass final antes de ship |
| `quieter` | Reducir agresividad visual |
| `shape` | Planificar UX/UI de una feature |
| `typeset` | Mejorar tipografía |

> Uso: `/impeccable teach` para onboarding en proyecto nuevo → `/impeccable craft` para generar → comandos individuales para steering fino.

---

## 2.9 Agent-Skill Maps (por dominio)

El archivo `~/.claude/agent-skill-map.md` fue dividido en 4 archivos de dominio para reducir tokens cargados por sesión. Solo el archivo relevante al proyecto activo se carga:

| Archivo | Dominio |
|---------|---------|
| `~/.claude/agent-skill-map-seo.md` | SEO — skills de auditoría, keywords, schema, local |
| `~/.claude/agent-skill-map-ads.md` | Publicidad paga — Google, Meta, LinkedIn, TikTok, etc. |
| `~/.claude/agent-skill-map-marketing.md` | Marketing — CRO, copy, email, social, branding |
| `~/.claude/agent-skill-map-design.md` | Diseño — UI/UX, frontend, creative strategy |

> **Optimización (2026-04-08):** Esta división redujo el overhead de tokens en sesiones no-SEO/ads de ~47k a ~13k tokens (~72% reducción).

---

## 3. MCP Servers Externos

Configurados via `claude mcp add`. Requieren tokens/API keys propios.

### 3.1 MCP Servers Globales

Disponibles en todas las sesiones.

| MCP Server | Comando de instalación | Estado | Notas |
|------------|----------------------|--------|-------|
| **context7** | `claude mcp add context7 -- npx -y @upstash/context7-mcp` | ✓ Connected | Docs up-to-date de librerías |
| **nano-banana** | `claude mcp add nano-banana -- npx -y nano-banana-mcp` | ✓ Connected | Generación/edición de imágenes — global porque `ads-generate` y `ads-photoshoot` se invocan desde cualquier proyecto cliente |

### 3.2 MCP Servers por Proyecto (project-scoped)

Solo disponibles en el proyecto donde se configuraron. Se instalan con `claude mcp add <nombre> -s project`.

| MCP Server | Comando de instalación | Notas |
|------------|----------------------|-------|
| **n8n-mcp** | `claude mcp add n8n-mcp -s project -- npx -y n8n-mcp` | Automatización n8n — solo en proyectos de workflows |
| **21st-magic** | `claude mcp add 21st-magic -s project -- npx -y @21st-dev/magic@latest` | Componentes UI de 21st.dev |
| **stitch** | `claude mcp add stitch -s project --transport http https://stitch.googleapis.com/mcp` | Stitch by Google |
| **figma** | `claude mcp add figma -s project --transport http https://mcp.figma.com/mcp` | Lectura/escritura de diseños Figma — requiere token Figma |

> **Por qué project-scoped:** n8n-mcp requiere env vars específicas por instancia y solo sirve en proyectos de automatización. Figma, Stitch y 21st-magic solo se necesitan en proyectos con UI. Mantenerlos globales añade overhead en cada sesión sin beneficio.

> **Nota para Figma y Stitch:** Son servidores HTTP, usar flag `--transport http`.
> **Nota para n8n-mcp, context7, 21st-magic, nano-banana:** Son servidores npx locales, no llevan flag de transport.

### Variables de entorno requeridas

| MCP | Variable | Descripción |
|-----|----------|-------------|
| nano-banana | `GEMINI_API_KEY` | Clave de Google AI Studio |
| figma | Token en header | Configurar via `claude mcp add figma -H "Authorization: Bearer <TOKEN>"` |
| n8n-mcp | `N8N_API_URL` | URL local de n8n (ej. `http://localhost:5678`) |
| n8n-mcp | `N8N_API_KEY` | API key generada desde n8n Settings → API |

---

## 4. MCP Servers claude.ai (integrados)

Estos MCP se conectan desde claude.ai y requieren autenticación OAuth en la primera sesión.

| MCP Server | URL | Estado |
|------------|-----|--------|
| **Airtable** | `https://mcp.airtable.com/mcp` | ✓ Conectado |
| **Gmail** | `https://gmail.mcp.claude.com/mcp` | ⚠ Pendiente (OAuth no completado) |
| **Google Calendar** | `https://gcal.mcp.claude.com/mcp` | ⚠ Pendiente (OAuth no completado) |

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
    "superpowers@superpowers-marketplace": false,
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
# Obligatorios:
/install-skill context-mode
/install-skill thedotmack
/install-skill claude-plugins-official
/install-skill ui-ux-pro-max-skill
/install-skill yhosw-skills
# Opcional (actualmente deshabilitado):
# /install-skill superpowers-marketplace

# 4. Configurar MCP servers externos — GLOBALES
claude mcp add context7 -- npx -y @upstash/context7-mcp
claude mcp add nano-banana -- npx -y nano-banana-mcp

# 4b. MCP servers PROJECT-SCOPED (ejecutar dentro de cada proyecto)
# Automatización n8n (requiere N8N_API_URL y N8N_API_KEY en env):
# claude mcp add n8n-mcp -s project -- npx -y n8n-mcp
# Diseño UI:
# claude mcp add 21st-magic -s project -- npx -y @21st-dev/magic@latest
# claude mcp add stitch -s project --transport http https://stitch.googleapis.com/mcp
# claude mcp add figma -s project --transport http https://mcp.figma.com/mcp

# 5. Instalar skills externas (anthropics/skills)
BASE="https://github.com/anthropics/skills/raw/refs/heads/main/skills"
curl -sL "$BASE/mcp-builder/SKILL.md" -o ~/.claude/skills/mcp-builder.md
curl -sL "$BASE/pdf/SKILL.md"         -o ~/.claude/skills/pdf.md
curl -sL "$BASE/docx/SKILL.md"        -o ~/.claude/skills/docx.md

# 6. Configurar CLAUDE.md global
# Copiar ~/.claude/CLAUDE.md desde backup o crear uno nuevo

# 7. Verificar setup
claude mcp list
```

### Verificación post-instalación

```bash
claude mcp list
# Globales: context7 ✓, nano-banana ✓, n8n-mcp ✓
# + plugin:claude-mem:mcp-search ✓, plugin:context-mode:context-mode ✓
# Project-scoped (solo si configurados en el proyecto): 21st-magic, stitch, figma
```

---

## Componentes totales

| Categoría | Cantidad |
|-----------|----------|
| Plugins de marketplace | 7 activos + 1 deshabilitado (superpowers) |
| gStack skills (core + marketing) | ~53 skills (garrytan/gstack) |
| Skills curadas en este repo | ~30 skills (yhosw-skills) |
| Ads Suite | 12 skills (claude-ads/) |
| SEO Suite | 5 skills (claude-seo/) |
| Skills externas sueltas | 5 (dream, mcp-builder, pdf, docx, content-research-writer) |
| MCP servers globales (CLI) | 3 activos + 1 fallido |
| MCP servers project-scoped | 3 (figma, stitch, 21st-magic) |
| **Total skills activas** | **~111 skills** |

---

## 8. Catálogo Completo — Referencia para Nueva PC

Todas las skills instaladas, organizadas por origen. Usar junto al `CLAUDE.md` de este repo para setup interactivo.

### 8.1 gStack — Core Engineering (29 skills)

**Fuente:** `garrytan/gstack` · **Instalación:** `git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup`

| Skill | Rol / Descripción |
|-------|------------------|
| `autoplan` | CEO/Producto — planificación automática de tareas |
| `benchmark` | QA — comparar rendimiento antes/después |
| `browse` | Browser — navegación web headless con Playwright |
| `canary` | Release — monitoreo post-deploy |
| `careful` | Seguridad — modo cauteloso para ops destructivas |
| `checkpoint` | Utilidad — guardar y resumir estado de trabajo |
| `codex` | Eng Manager — integración con OpenAI Codex CLI |
| `connect-chrome` | Browser — controlar Chrome real con CDP |
| `cso` | Seguridad — Chief Security Officer mode |
| `design-consultation` | Diseñador — consultoría de diseño |
| `design-html` | Diseñador — generar HTML final de diseños |
| `design-review` | Diseñador — revisión de UI con ojo de diseñador |
| `design-shotgun` | Diseñador — múltiples conceptos visuales rápidos |
| `document-release` | Release — documentación post-ship |
| `freeze` | Seguridad — restringir ediciones a archivos específicos |
| `gstack` | Utilidad — browser headless optimizado para marketing |
| `gstack-upgrade` | Utilidad — actualizar gstack a última versión |
| `guard` | Seguridad — modo completo de seguridad |
| `health` | QA — dashboard de calidad de código |
| `investigate` | QA — debugging sistemático |
| `land-and-deploy` | Release — workflow land + deploy |
| `office-hours` | CEO/Producto — YC Office Hours simulation |
| `qa` | QA — testing sistemático de features |
| `qa-only` | QA — reporte de QA sin fixes |
| `retro` | Utilidad — retrospectivas semanales |
| `review` | Eng Manager — review de PRs |
| `setup-browser-cookies` | Browser — importar cookies desde Chrome |
| `ship` | Release — workflow completo de ship |
| `unfreeze` | Seguridad — limpiar restricciones de freeze |

### 8.2 gStack — Marketing/CRO/Sales Bundle (24 skills)

**Fuente:** `garrytan/gstack` (mismo repo, mismo comando de instalación)

| Skill | Categoría | Descripción |
|-------|-----------|-------------|
| `ab-test-setup` | Analytics | Configurar A/B tests |
| `analytics-tracking` | Analytics | Setup de tracking y analytics |
| `churn-prevention` | Sales | Estrategias de retención |
| `cold-email` | Marketing | Emails B2B en frío |
| `competitor-alternatives` | Sales | Páginas de alternativas a competidores |
| `copywriting` | Marketing | Copy para publicidad paga |
| `customer-research` | Sales | Investigación de clientes |
| `email-sequence` | Marketing | Secuencias de email |
| `form-cro` | CRO | Optimización de formularios |
| `free-tool-strategy` | Marketing | Estrategia de herramientas gratuitas |
| `launch-strategy` | Marketing | Estrategia de lanzamiento |
| `lead-magnets` | Marketing | Creación de lead magnets |
| `marketing-ideas` | Marketing | Ideas de marketing |
| `onboarding-cro` | CRO | Optimización de onboarding |
| `page-cro` | CRO | Optimización de páginas de conversión |
| `paywall-upgrade-cro` | CRO | Optimización de upgrades/paywall |
| `popup-cro` | CRO | Optimización de popups |
| `pricing-strategy` | Sales | Estrategia de precios |
| `referral-program` | Sales | Programa de referidos |
| `revops` | Sales | Revenue operations |
| `sales-enablement` | Sales | Habilitación de ventas |
| `setup-deploy` | DevOps | Configurar settings de deployment |
| `signup-flow-cro` | CRO | Optimización del flujo de registro |
| `social-content` | Marketing | Contenido para redes sociales |

### 8.3 Ads Suite (12 skills)

**Fuente:** `Yhoswar/claude-skills` (carpeta `claude-ads/`) · **Instalación:** via `/install-skill yhosw-skills` o copiar carpeta

| Skill | Descripción |
|-------|-------------|
| `ads` | Orquestador — coordinación multi-plataforma |
| `ads-audit` | Auditoría completa de campañas (LinkedIn, TikTok, Microsoft) |
| `ads-budget` | Estrategia de presupuesto y bidding |
| `ads-competitor` | Inteligencia competitiva |
| `ads-creative` | Calidad de creatividades por plataforma |
| `ads-dna` | Extractor de Brand DNA para ads |
| `ads-generate` | Generación de imágenes para ads |
| `ads-google` | Google Ads — análisis profundo |
| `ads-landing` | Landing page quality assessment |
| `ads-meta` | Meta Ads — análisis profundo |
| `ads-photoshoot` | Fotografía de producto para ads |
| `ads-plan` | Planificación estratégica de campañas |

### 8.4 SEO Suite (5 skills)

**Fuente:** `Yhoswar/claude-skills` (carpeta `claude-seo/`) · **Instalación:** via `/install-skill yhosw-skills` o copiar carpeta

| Skill | Descripción |
|-------|-------------|
| `seo` | Análisis SEO completo |
| `seo-audit` | Auditoría técnica SEO |
| `seo-local` | SEO local y GBP |
| `seo-maps` | Maps intelligence (geo-grid, GBP, NAP) |
| `seo-plan` | Planificación estratégica SEO |

### 8.5 Skills Curadas en este Repo (via yhosw-skills)

**Fuente:** `Yhoswar/claude-skills` · **Instalación:** `/install-skill yhosw-skills`

| Skill | Descripción |
|-------|-------------|
| `adapt` | Adaptar diseños a diferentes contextos |
| `animate` | Motion design con curvas de easing correctas |
| `audit` | Checks de calidad técnica |
| `bolder` | Amplificar diseños seguros/aburridos |
| `caveman-compress` | Compresión de texto para CLAUDE.md y memoria |
| `clarify` | Mejorar copy y mensajes UX |
| `colorize` | Añadir color estratégico |
| `cost-reducer` | Optimización de costos cloud/infra |
| `critique` | Evaluación UX con scoring |
| `customer-support` | Atención al cliente y flujos de soporte |
| `delight` | Añadir momentos de joy y personalidad |
| `distill` | Destilar diseños a su esencia |
| `harden` | Fortalecer interfaces contra edge cases |
| `humanizer` | Eliminar señales de escritura AI |
| `impeccable` | Suite diseño web (7 ref docs + 18 steering skills) |
| `layout` | Mejorar layout, espaciado y jerarquía |
| `n8n-code-javascript` | JS en n8n |
| `n8n-code-python` | Python en n8n |
| `n8n-expression-syntax` | Sintaxis de expresiones n8n |
| `n8n-mcp-tools-expert` | Guía de tools MCP en n8n |
| `n8n-node-configuration` | Configuración de nodos n8n |
| `n8n-validation-expert` | Interpretar errores de validación n8n |
| `n8n-workflow-patterns` | Patrones de arquitectura n8n |
| `notebooklm` | API completa para Google NotebookLM |
| `optimize` | Diagnóstico y fixes de performance UI |
| `overdrive` | Llevar interfaces más allá de lo convencional |
| `polish` | Quality pass final antes de ship |
| `quieter` | Reducir agresividad visual |
| `researcher` | Investigación profunda multi-fuente |
| `scalability` | Patrones de escalabilidad para sistemas |
| `security` | Seguridad web/desktop — OWASP Top 10 |
| `self-healing` | Auto-mejora: patrones, memoria, skills |
| `shape` | Planificar UX/UI de una feature |
| `typeset` | Mejorar tipografía |

### 8.6 Skills Sueltas (instalación individual)

| Skill | Fuente | Comando |
|-------|--------|---------|
| `dream` | `grandamenium/dream-skill` | `git clone --depth 1 https://github.com/grandamenium/dream-skill.git ~/.claude/skills/dream` |
| `mcp-builder.md` | `anthropics/skills` | `curl -sL https://github.com/anthropics/skills/raw/refs/heads/main/skills/mcp-builder/SKILL.md -o ~/.claude/skills/mcp-builder.md` |
| `pdf.md` | `anthropics/skills` | `curl -sL https://github.com/anthropics/skills/raw/refs/heads/main/skills/pdf/SKILL.md -o ~/.claude/skills/pdf.md` |
| `docx.md` | `anthropics/skills` | `curl -sL https://github.com/anthropics/skills/raw/refs/heads/main/skills/docx/SKILL.md -o ~/.claude/skills/docx.md` |
| `content-research-writer.md` | `ComposioHQ/awesome-claude-skills` | `curl -L -o ~/.claude/skills/content-research-writer.md https://raw.githubusercontent.com/ComposioHQ/awesome-claude-skills/master/content-research-writer/SKILL.md` |

### 8.7 Skills Archivadas — Solo si se necesitan

Estas skills fueron archivadas por solapamiento con equivalentes activos. **No están instaladas.** Si en el futuro se necesita alguna, reinstalar desde su fuente original (todas provienen de `garrytan/gstack` o del marketplace de plugins).

| Skill | Reemplazada por | Fuente |
|-------|----------------|--------|
| `plan-ceo-review` | `office-hours` | garrytan/gstack |
| `plan-eng-review` | `review` | garrytan/gstack |
| `plan-design-review` | `design-review` | garrytan/gstack |
| `content-strategy` | `marketing-ideas` + `social-content` | garrytan/gstack |
| `copy-editing` | `copywriting` | garrytan/gstack |
| `marketing-psychology` | — (teórico, no operativo) | garrytan/gstack |
| `product-marketing-context` | — (contexto interno) | garrytan/gstack |
| `programmatic-seo` | `seo-plan` | garrytan/gstack |
| `schema-markup` | agente `seo-schema` | garrytan/gstack |
| `site-architecture` | `seo-plan` | garrytan/gstack |
| `ads-create` | `ads-creative` | Yhoswar/claude-skills |
| `ads-apple` | — (sin cliente activo) | Yhoswar/claude-skills |
| `ads-linkedin` | — (sin cliente activo) | Yhoswar/claude-skills |
| `ads-microsoft` | — (sin cliente activo) | Yhoswar/claude-skills |
| `ads-tiktok` | — (sin cliente activo) | Yhoswar/claude-skills |
| `ads-youtube` | — (sin cliente activo) | Yhoswar/claude-skills |
| `seo-technical` | `seo-audit` | Yhoswar/claude-skills |
| `seo-dataforseo` | agente `seo-dataforseo` | Yhoswar/claude-skills |
| `seo-firecrawl` | — | Yhoswar/claude-skills |
| `seo-backlinks` | `seo-audit` | Yhoswar/claude-skills |
| `seo-competitor-pages` | `seo-audit` | Yhoswar/claude-skills |
| `seo-hreflang` | `seo-technical` (agente) | Yhoswar/claude-skills |
| `seo-image-gen` | `ads-generate` | Yhoswar/claude-skills |
| `seo-geo` | agente `seo-geo` | Yhoswar/claude-skills |
| `seo-google` | agente `seo-google` | Yhoswar/claude-skills |
| `seo-schema` | agente `seo-schema` | Yhoswar/claude-skills |
| `seo-sitemap` | agente `seo-sitemap` | Yhoswar/claude-skills |
| `seo-content` | agente `seo-content` | Yhoswar/claude-skills |
| `seo-page` | `seo-audit` | Yhoswar/claude-skills |
| `seo-programmatic` | `seo-plan` | Yhoswar/claude-skills |
| `ai-seo` | `seo` | Yhoswar/claude-skills |
| `seo-images` | `ads-generate` | Yhoswar/claude-skills |
