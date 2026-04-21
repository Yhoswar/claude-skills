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
