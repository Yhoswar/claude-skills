# Design Spec: ai-project-starter Upgrade — From 5.1 to 9/10
**Date:** 2026-03-16
**Author:** Yhoswar (via Claude Code brainstorming)
**Repo:** https://github.com/Yhoswar/ai-project-starter
**Status:** Approved for implementation

---

## 1. Problem Statement

The current `ai-project-starter` scores 5.1/10 as a project base. It excels as an AI agent configuration layer (10/10) but lacks real application substance: no TypeScript tooling, no testing, no CI/CD, no security baseline, and no code templates. Any developer cloning it must still build the entire application stack from scratch.

**Goal:** Elevate to 9/10 by adding three real starter templates, global skills infrastructure, quality tooling, and complete documentation — while keeping the AI agent system as the core differentiator.

---

## 2. Architecture: Two-Layer Design

The repo has two independent layers that coexist:

**Layer 1 — AI Config Layer** (what exists, improved)
Claude/OpenCode agent configuration, MEMORY.md system, CLAUDE.md, AGENTS.md, slash commands.

**Layer 2 — Application Templates** (what's being added)
Three production-ready starters a developer copies to begin their project.

These layers are independent: a developer can use only the AI config layer on their existing stack, or start from one of the templates. Both scenarios are supported.

---

## 3. Repository Structure

```
ai-project-starter/
├── .claude/
│   ├── agents/                    # 7 specialized agents (improved)
│   ├── commands/                  # /team-plan, /team-status, /team-review
│   └── settings.local.json        # Tool permissions
├── .opencode/                     # OpenCode compatibility (improved)
├── .github/
│   └── workflows/
│       ├── ci.yml                 # NEW: lint + typecheck + test + build
│       └── security.yml           # NEW: npm audit + dependency scanning
├── templates/
│   ├── next-saas/                 # NEW: unified SaaS + dashboard + web app
│   ├── api-service/               # NEW: pure backend
│   └── automation/                # NEW: background jobs + workflows
├── docs/
│   ├── getting-started.md         # NEW: onboarding guide
│   ├── skills-guide.md            # NEW: full skills reference by project type (canonical location)
│   ├── memory-guide.md            # NEW: MEMORY.md + claude-mem usage
│   └── agents-guide.md            # NEW: multi-agent system walkthrough
├── memory/
│   ├── MEMORY.md                  # NEW: Claude memory index template
│   ├── decisions.md               # NEW: architecture decisions template
│   └── architecture.md            # NEW: project architecture notes template
├── scripts/
│   ├── init.sh                    # Improved: better prompts, validation
│   ├── init.ps1                   # Improved: PowerShell version
│   ├── install-skills.sh          # NEW: global skills installer (bash)
│   └── install-skills.ps1         # NEW: global skills installer (PowerShell)
├── .env.example                   # NEW: base environment variables
├── .gitignore                     # NEW: comprehensive (secrets, deps, builds, OS)
├── .editorconfig                  # NEW: cross-editor consistency
├── CLAUDE.md                      # Improved: clearer structure, security section
├── AGENTS.md                      # Improved: filled security placeholders
└── README.md                      # Rewritten: badges, quick-start, template guide
```

---

## 4. Templates

### 4.1 `next-saas` — Unified (SaaS + Dashboard + Web App)

**Use when:** Building any user-facing web application — SaaS products, company dashboards, internal tools, personal finance apps, admin panels.

**Stack:**
- Next.js 15 (App Router)
- TypeScript (strict mode)
- Tailwind CSS + shadcn/ui
- Auth.js v5 (NextAuth) — email/password + OAuth providers
- Drizzle ORM + PostgreSQL
- TanStack Query (client data fetching)
- Recharts (dashboard charts)
- Vitest (unit tests)
- Playwright (e2e tests)
- ESLint + Prettier + Husky + lint-staged

**Structure:**
```
templates/next-saas/
├── src/
│   ├── app/
│   │   ├── (auth)/            # login, register, forgot-password
│   │   ├── (dashboard)/       # protected layout + pages
│   │   └── api/               # API routes
│   ├── components/
│   │   ├── ui/                # shadcn/ui base components
│   │   ├── charts/            # Recharts wrappers (BarChart, LineChart, etc.)
│   │   └── layout/            # Sidebar, Navbar, Header, PageWrapper
│   ├── lib/
│   │   ├── db/                # Drizzle config + schema + migrations
│   │   ├── auth/              # Auth.js config + session helpers
│   │   └── utils/             # cn(), formatCurrency(), formatDate()
│   └── types/                 # Global TypeScript types
├── tests/
│   ├── unit/                  # Vitest unit tests
│   └── e2e/                   # Playwright browser tests
├── .env.example               # DATABASE_URL, AUTH_SECRET, NEXTAUTH_URL, etc.
├── drizzle.config.ts
├── tsconfig.json              # strict: true
├── eslint.config.js
├── prettier.config.js
├── vitest.config.ts
├── playwright.config.ts
└── package.json
```

### 4.2 `api-service` — Pure Backend

**Use when:** Building a standalone REST or GraphQL API, microservice, or backend for a mobile app.

**Stack:** Bun + Hono + TypeScript + Drizzle ORM + Zod + Vitest

```
templates/api-service/
├── src/
│   ├── routes/            # Hono route handlers (grouped by resource)
│   ├── middleware/        # auth JWT, rate-limit, CORS, error-handler
│   ├── db/                # Drizzle schema + queries
│   ├── validators/        # Zod schemas for request validation
│   └── index.ts           # App entry point
├── tests/                 # Vitest integration + unit tests
├── .env.example
├── tsconfig.json
└── package.json
```

### 4.3 `automation` — Background Jobs + Workflows

**Use when:** Building scheduled tasks, event-driven pipelines, integrations with external services, or AI workflows.

**Stack:** Trigger.dev v3 + Composio + n8n workflow exports + Zod + TypeScript

```
templates/automation/
├── src/
│   ├── jobs/              # Trigger.dev tasks (scheduled + event-triggered)
│   ├── workflows/         # n8n workflow JSON exports
│   └── integrations/      # Composio app connections (GitHub, Gmail, Slack, etc.)
├── tests/                 # Vitest unit tests for jobs (using Trigger.dev mocked context)
├── .env.example           # TRIGGER_SECRET_KEY, COMPOSIO_API_KEY, etc.
├── tsconfig.json          # TypeScript strict config
└── package.json           # trigger.dev, composio-core, vitest, typescript, zod
```

**Testing approach:** Vitest with Trigger.dev's `@trigger.dev/sdk/v3/testing` mocked context for unit-testing job logic without live infrastructure.

---

## 5. Memory System (MEMORY.md)

The repo ships a `memory/MEMORY.md` **template** that developers customize per project. Claude Code reads it at session start to maintain project context across conversations.

This is different from `claude-mem` (MCP cross-session database). MEMORY.md is:
- Per-project, not global
- Stored in git (versioned with the code)
- Human-readable and editable
- A pointer index to detailed memory files in `memory/`

**Template structure:**
```markdown
# [Project Name] — Memory Index
Updated: YYYY-MM-DD

## Project Identity
- Name, stack, primary goal, production URL

## Architecture Decisions
→ memory/decisions.md

## Current Sprint / Active Work
→ memory/sprint.md

## Known Issues / Tech Debt
→ memory/issues.md

## External Services & Credentials
→ memory/services.md (never commit real secrets)
```

---

## 6. Skills — Global Installation

### Skills installed globally (available in ALL projects):

| Skill | Why global |
|---|---|
| `security` | Every project needs it |
| `frontend-design` | Any UI work |
| `scalability` | Any production deployment |
| `researcher` | Research tasks in any context |
| `know-me` | Personal productivity layer |
| `self-healing` | Meta-improvement framework |

### Skills installed per-project type (via `install-skills.sh` menu):

| Skill | For |
|---|---|
| `trigger-dev` | automation template |
| `composio` | automation / AI integration |
| `n8n` | automation template |
| `cost-reducer` | any deployed production app |
| `customer-support` | SaaS with real users |

### Installation mechanism (`scripts/install-skills.sh`):

**Prerequisite:** The `Claude Skills` repository must already be cloned or present at `~/OneDrive/Desktop/Claude Skills/` (Windows) or `~/Claude Skills/` (macOS/Linux). The source path is configurable via the `SKILLS_ROOT` environment variable:

```bash
SKILLS_ROOT="/custom/path/to/Claude Skills" ./scripts/install-skills.sh
```

If `SKILLS_ROOT` is not set, the script defaults to the OS-appropriate path above. The script copies skill directories from `$SKILLS_ROOT` to `~/.claude/plugins/`, making them available across all Claude Code sessions regardless of working directory.

**Idempotency:** Both `install-skills.sh` and `init.sh` are idempotent — running them multiple times is safe and will not overwrite existing customizations or previously installed skills. The `install-skills.ps1` file mirrors the bash version exactly with PowerShell syntax.

---

## 7. Quality Improvements — Reaching 9/10

| Dimension | Before | After | Key change |
|---|---|---|---|
| AI Integration | 10/10 | 10/10 | Already perfect |
| Documentation | 9/10 | 10/10 | Full docs/, per-template READMEs |
| Dev Experience | 7/10 | 9/10 | install-skills script, better init |
| Structure | 7/10 | 10/10 | Two-layer architecture, templates |
| Stack | 5/10 | 9/10 | Three real starters with full tooling |
| SaaS Readiness | 4/10 | 9/10 | next-saas template covers this |
| Security | 3/10 | 8/10 | .gitignore, .env.example, security.yml, filled AGENTS.md |
| Tooling | 3/10 | 9/10 | ESLint, Prettier, Husky, TypeScript per template |
| CI/CD | 2/10 | 8/10 | GitHub Actions: ci.yml + security.yml |
| Testing | 1/10 | 8/10 | Vitest + Playwright in next-saas, Vitest in api-service |
| **Average** | **5.1** | **9.0** | |

---

## 8. Implementation Phases

| Phase | Scope | Deliverable |
|---|---|---|
| **0 — Skills** | Install 6 core skills globally via script | Skills available in all projects |
| **1 — Foundation** | .gitignore, .editorconfig, .env.example, MEMORY.md system, improved CLAUDE.md/AGENTS.md, GitHub Actions | Solid base layer |
| **2 — next-saas** | Full Next.js 15 template with auth, DB, dashboard components, tests | Most-used template ready |
| **3 — api-service** | Bun + Hono backend template | Backend template ready |
| **4 — automation** | Trigger.dev + Composio + n8n template | Automation template ready |
| **5 — Docs** | README rewrite, docs/ folder, skills-guide, memory-guide | Complete documentation |

---

## 9. Out of Scope

- Mobile app templates (React Native, Flutter) — future iteration
- Payment integration (Stripe) — left as documented placeholder in next-saas
- Database hosting setup — developer's responsibility (documented in README)
- OpenCode-specific agent improvements beyond existing functionality

---

## 10. Success Criteria

- [ ] Any developer can `git clone` and be running a Next.js app in < 5 minutes
- [ ] Skills install with a single script run
- [ ] Claude Code agents work correctly across all three template contexts: `/team-plan` resolves without error, agent files are detected by Claude Code, and `/team-status` returns a structured response in each template's working directory
- [ ] CI passes on every template out of the box
- [ ] MEMORY.md is documented and usable from day one
- [ ] Repo scores ≥ 9/10 on all dimensions from the original evaluation
