# claude-skills — Repo de Skills de Claude Code

## Propósito

Este repo es el backup/showcase público del stack de skills de Claude Code de yhosw.

URL: https://github.com/Yhoswar/claude-skills

## Flujo de actualización

Cuando el usuario instala o actualiza un skill globalmente en `~/.claude/skills/`, viene aquí para sincronizarlo al repo:

1. Identifica qué skill cambió o se agregó
2. Borra la carpeta vieja del repo (si existe)
3. Copia desde `~/.claude/skills/<skill>/` o `~/.claude/agents/<skill>.md`
4. Actualiza el README si la estructura cambió
5. Commit y push a `main`

## Estructura del repo

```
claude-skills/
├── claude-ads/        ← Suite publicidad paga (18 skills + 10 agentes)
├── claude-marketing/  ← Suite marketing (31 skills)
├── claude-seo/        ← Suite SEO completa (20 skills + 12 agentes)
├── impeccable/        ← Suite diseño web — skill principal (7 ref docs)
├── adapt/             ┐
├── animate/           │
├── audit/             │
├── bolder/            │
├── clarify/           │
├── colorize/          │
├── critique/          │ impeccable — 17 skills de steering
├── delight/           │
├── distill/           │
├── harden/            │
├── layout/            │
├── optimize/          │
├── overdrive/         │
├── polish/            │
├── quieter/           │
├── shape/             │
├── typeset/           ┘
├── composio/
├── cost-reducer/
├── create-skill/
├── customer-support/
├── frontend-design/
├── humanizer/
├── know-me/
├── n8n/
├── researcher/
├── scalability/
├── security/
├── self-healing/
├── trigger-dev/
└── README.md
```

## Ubicaciones globales

- Skills: `C:/Users/yhosw/.claude/skills/`
- Agentes: `C:/Users/yhosw/.claude/agents/`

## Normas

- Responder siempre en **español**
- No gastar tokens reexplicando el propósito del repo — ya está aquí documentado
- Si el usuario dice "sube el nuevo skill X", ir directo: copiar → commit → push

---

## Setup en PC Nueva — Guía Interactiva

Cuando el usuario diga **"configura mi Claude Code"**, **"setup"**, **"nueva PC"** o similar, actuar como asistente de instalación:

### Paso 1 — Verificar estado actual

```bash
ls ~/.claude/skills/ 2>/dev/null | wc -l   # skills instaladas
claude mcp list 2>/dev/null                 # MCPs activos
ls ~/.claude/agents/ 2>/dev/null | wc -l   # agentes
```

### Paso 2 — Preguntar por categorías

Presentar este menú y preguntar cuáles instalar (puede elegir varias o todas):

```
¿Qué categorías instalar?

A) Core (SIEMPRE recomendado)
   → context-mode, claude-mem, claude-plugins-official, ui-ux-pro-max
   → MCPs: context7, nano-banana, n8n-mcp
   → Skills: mcp-builder, pdf, docx, dream

B) Skills de productividad y dev — gstack (garrytan/gstack)
   → 29 skills core: browse, ship, investigate, checkpoint, qa, autoplan, review...
   → Requiere: Bun + Node.js

C) Skills de marketing/CRO/sales — gstack marketing bundle
   → 24 skills: form-cro, page-cro, copywriting, email-sequence, social-content...
   → Se instala junto con gstack (mismo comando)

D) Suite de Ads (publicidad paga)
   → 12 skills: ads-meta, ads-google, ads-budget, ads-creative, ads-plan...

E) Suite de SEO
   → 5 skills: seo, seo-audit, seo-local, seo-maps, seo-plan

F) Suite de Diseño
   → impeccable suite (18 skills), yhosw-skills curated (adapt, animate, shape, etc.)

G) MCPs de proyecto (solo para proyectos con diseño UI)
   → figma, stitch, 21st-magic (instalar por proyecto, no globalmente)
```

### Paso 3 — Instalar según selección

**A) Core:**
```bash
# settings.json — agregar extraKnownMarketplaces (ver README sección 5 y 6)
# Luego dentro de Claude Code:
# /install-skill context-mode
# /install-skill thedotmack
# /install-skill claude-plugins-official
# /install-skill ui-ux-pro-max-skill
# /install-skill yhosw-skills

# MCPs globales:
claude mcp add context7 -- npx -y @upstash/context7-mcp
claude mcp add nano-banana -- npx -y nano-banana-mcp
claude mcp add n8n-mcp -- npx -y n8n-mcp

# Skills sueltas:
BASE="https://github.com/anthropics/skills/raw/refs/heads/main/skills"
curl -sL "$BASE/mcp-builder/SKILL.md" -o ~/.claude/skills/mcp-builder.md
curl -sL "$BASE/pdf/SKILL.md"         -o ~/.claude/skills/pdf.md
curl -sL "$BASE/docx/SKILL.md"        -o ~/.claude/skills/docx.md
git clone --depth 1 https://github.com/grandamenium/dream-skill.git ~/.claude/skills/dream
```

**B+C) gstack (core + marketing bundle):**
```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
# Requiere Bun: curl -fsSL https://bun.sh/install | bash
```

**D) Ads Suite:**
```bash
# Copiar desde este repo clonado:
cp -r claude-ads/skills/. ~/.claude/skills/
# O instalar via yhosw-skills marketplace (si ya instalado en core)
```

**E) SEO Suite:**
```bash
# Copiar desde este repo clonado:
cp -r claude-seo/skills/. ~/.claude/skills/
# O instalar via yhosw-skills marketplace
```

**F) Diseño (yhosw-skills):**
```bash
# Se instala automáticamente con /install-skill yhosw-skills del core
# Incluye: impeccable, adapt, animate, shape, layout, optimize, etc.
```

**G) MCPs de proyecto (correr dentro de cada proyecto):**
```bash
claude mcp add 21st-magic -s project -- npx -y @21st-dev/magic@latest
claude mcp add stitch -s project --transport http https://stitch.googleapis.com/mcp
claude mcp add figma -s project --transport http https://mcp.figma.com/mcp
```

### Paso 4 — Verificar y cerrar

```bash
claude mcp list
ls ~/.claude/skills/ | wc -l
```

Recordar al usuario: **reiniciar Claude Code** para activar plugins recién instalados.

> **Ver README.md** de este repo para el catálogo completo, comandos exactos, y settings.json de referencia.
