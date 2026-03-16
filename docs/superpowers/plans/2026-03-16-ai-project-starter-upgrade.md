# ai-project-starter Upgrade Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade `ai-project-starter` from 5.1/10 to 9/10 by installing local skills globally, improving the repo foundation, and adding three production-ready templates (next-saas, api-service, automation).

**Architecture:** Two-layer design — AI config layer (agents, MEMORY.md, CLAUDE.md) sits independently of three application templates. Skills are packaged as a Claude Code plugin and registered globally. All templates ship with TypeScript, ESLint, Prettier, tests, and CI/CD.

**Tech Stack:** Next.js 15, Bun, Hono, Trigger.dev, Composio, Drizzle ORM, Auth.js v5, Vitest, Playwright, GitHub Actions, shadcn/ui, Tailwind CSS

**Spec:** `docs/superpowers/specs/2026-03-16-ai-project-starter-upgrade-design.md`

---

## Pre-flight Checks

Before starting, verify these are true:

- [ ] `C:\Users\yhosw\OneDrive\Desktop\Claude Skills\` exists and contains skill folders
- [ ] `gh` CLI is authenticated: `gh auth status`
- [ ] `git` is available: `git --version`
- [ ] `node` ≥ 20 is available: `node --version`
- [ ] `bun` is available: `bun --version` (install from https://bun.sh if not)
- [ ] GitHub repo exists: `gh repo view Yhoswar/ai-project-starter`

---

## Chunk 1: Phase 0 — Skills as Global Plugin

**Goal:** Make the `Claude Skills` folder a proper Claude Code plugin, push to GitHub, and register it globally so skills are available in ALL projects without needing to run from the Claude Skills directory.

**Files:**
- Create: `C:\Users\yhosw\OneDrive\Desktop\Claude Skills\.claude-plugin\plugin.json`
- Modify: `C:\Users\yhosw\.claude\settings.json`

### Task 1.1: Convert Claude Skills to a Claude Code Plugin

- [ ] **Step 1: Create the plugin manifest**

Create `C:\Users\yhosw\OneDrive\Desktop\Claude Skills\.claude-plugin\plugin.json`:

```json
{
  "name": "yhosw-skills",
  "description": "Personal skill library: security, scalability, frontend-design, trigger-dev, composio, n8n, cost-reducer, researcher, know-me, self-healing, customer-support",
  "version": "1.0.0",
  "author": {
    "name": "Yhoswar",
    "email": ""
  },
  "homepage": "https://github.com/Yhoswar/claude-skills",
  "repository": "https://github.com/Yhoswar/claude-skills",
  "license": "MIT",
  "keywords": ["skills", "security", "scalability", "frontend", "automation", "ai"]
}
```

- [ ] **Step 2: Verify all skill SKILL.md files exist**

```bash
ls "C:/Users/yhosw/OneDrive/Desktop/Claude Skills"/*/SKILL.md
```

Expected output: One `SKILL.md` per skill folder (security, scalability, frontend-design, trigger-dev, composio, n8n, cost-reducer, researcher, know-me, self-healing, customer-support, create-skill).

- [ ] **Step 3: Initialize git repo in Claude Skills (if not already)**

```bash
cd "C:/Users/yhosw/OneDrive/Desktop/Claude Skills"
git init
git checkout -b main
git add .
git commit -m "feat: initial commit — personal Claude Code skills plugin"
```

Expected: Commit succeeds with list of tracked files. Branch is `main`.

- [ ] **Step 4: Create GitHub repo and push**

```bash
cd "C:/Users/yhosw/OneDrive/Desktop/Claude Skills"
gh repo create Yhoswar/claude-skills --private --source=. --description "Personal Claude Code skills: security, scalability, AI integrations"
git push -u origin HEAD
```

Expected: Repo created at `https://github.com/Yhoswar/claude-skills`, pushed to `main`.

### Task 1.2: Register Plugin Globally

- [ ] **Step 5: Read current settings.json**

```bash
cat "C:/Users/yhosw/.claude/settings.json"
```

- [ ] **Step 6: Surgically update settings.json — add only the two new keys**

Do NOT overwrite the entire file. Read it first (Step 5 above), then add ONLY these two entries:

In `enabledPlugins`, add:
```json
"yhosw-skills@yhosw-skills": true
```

In `extraKnownMarketplaces`, add:
```json
"yhosw-skills": {
  "source": {
    "source": "github",
    "repo": "Yhoswar/claude-skills"
  }
}
```

The final file should preserve ALL existing entries and look like:

```json
{
  "enabledPlugins": {
    "frontend-design@claude-plugins-official": true,
    "code-review@claude-plugins-official": true,
    "claude-mem@thedotmack": true,
    "ui-ux-pro-max@ui-ux-pro-max-skill": true,
    "superpowers@superpowers-marketplace": true,
    "skill-creator@claude-plugins-official": true,
    "context-mode@context-mode": true,
    "yhosw-skills@yhosw-skills": true
  },
  "extraKnownMarketplaces": {
    "thedotmack": { "source": { "source": "github", "repo": "thedotmack/claude-mem" } },
    "ui-ux-pro-max-skill": { "source": { "source": "github", "repo": "nextlevelbuilder/ui-ux-pro-max-skill" } },
    "superpowers-marketplace": { "source": { "source": "github", "repo": "obra/superpowers-marketplace" } },
    "context-mode": { "source": { "source": "github", "repo": "mksglu/context-mode" } },
    "yhosw-skills": { "source": { "source": "github", "repo": "Yhoswar/claude-skills" } }
  },
  "autoUpdatesChannel": "latest"
}
```

If your current `settings.json` has additional entries not listed above, preserve them — only ADD the yhosw-skills entries.

- [ ] **Step 7: Restart Claude Code and verify skills load**

Restart Claude Code (close and reopen the terminal session). Open a NEW project directory (not Claude Skills). Run `/security` and verify the skill loads from the plugin — not from the project directory.

Expected: Skill loads with a base directory path containing `yhosw-skills` (exact path may vary).

- [ ] **Step 8: Commit settings change (note: settings.json is personal — do not commit to repo)**

This file stays local. Document the manual step in the repo README.

---

## Chunk 2: Phase 1 — Repository Foundation

**Goal:** Clone the repo, add quality tooling (gitignore, editorconfig, env.example, GitHub Actions), MEMORY.md system, and improve CLAUDE.md/AGENTS.md.

**Working directory for all tasks in this chunk:** Your local clone of `ai-project-starter`.

```bash
git clone https://github.com/Yhoswar/ai-project-starter.git
cd ai-project-starter
```

### Task 2.1: Quality Baseline Files

- [ ] **Step 1: Create `.gitignore`**

Create `ai-project-starter/.gitignore`:

```gitignore
# Dependencies
node_modules/
.pnp
.pnp.js
bun.lockb
bun.lock

# Build outputs
.next/
out/
dist/
build/
*.tsbuildinfo

# Environment files — NEVER commit these
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.env.production
*.env

# Secrets and keys
*.pem
*.key
*.p12
*.pfx
id_rsa
id_ed25519

# OS files
.DS_Store
.DS_Store?
._*
Thumbs.db
desktop.ini

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Claude Code local settings (personal — not for sharing)
.claude/settings.local.json

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# Test coverage
coverage/
.nyc_output/

# Drizzle generated files
drizzle/

# Playwright
test-results/
playwright-report/
playwright/.cache/

# Turbo
.turbo/
```

- [ ] **Step 2: Create `.editorconfig`**

Create `ai-project-starter/.editorconfig`:

```editorconfig
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab

[*.go]
indent_style = tab
indent_size = 4
```

- [ ] **Step 3: Create root `.env.example`**

Create `ai-project-starter/.env.example`:

```bash
# ============================================================
# ai-project-starter — Environment Variables Template
# Copy this file to .env and fill in your values.
# NEVER commit .env to git.
# ============================================================

# --- App ---
NODE_ENV=development
APP_URL=http://localhost:3000
APP_SECRET=change-me-use-openssl-rand-base64-32

# --- Database (PostgreSQL) ---
DATABASE_URL=postgresql://user:password@localhost:5432/mydb

# --- Auth (Auth.js v5 / NextAuth) ---
AUTH_SECRET=change-me-use-openssl-rand-base64-32
AUTH_GOOGLE_ID=
AUTH_GOOGLE_SECRET=
AUTH_GITHUB_ID=
AUTH_GITHUB_SECRET=

# --- AI Services ---
ANTHROPIC_API_KEY=
OPENAI_API_KEY=

# --- Automation (Trigger.dev) ---
TRIGGER_SECRET_KEY=

# --- Integrations (Composio) ---
COMPOSIO_API_KEY=

# --- Email ---
EMAIL_FROM=noreply@example.com
RESEND_API_KEY=

# --- Payments (Stripe) ---
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
```

- [ ] **Step 4: Commit foundation files**

```bash
git add .gitignore .editorconfig .env.example
git commit -m "feat: add gitignore, editorconfig, and env.example"
```

### Task 2.2: GitHub Actions CI/CD

- [ ] **Step 5: Create CI workflow**

Create `ai-project-starter/.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [main, develop]
    paths:
      - 'templates/**'
  pull_request:
    branches: [main]
    paths:
      - 'templates/**'

jobs:
  check:
    name: Lint, Type-check & Test
    runs-on: ubuntu-latest
    strategy:
      matrix:
        template: [next-saas, api-service, automation]
    defaults:
      run:
        working-directory: templates/${{ matrix.template }}

    steps:
      - uses: actions/checkout@v4

      - uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest

      - name: Install dependencies
        run: bun install --frozen-lockfile

      - name: Type-check
        run: bun run typecheck

      - name: Lint
        run: bun run lint

      - name: Test
        run: bun run test -- --run

      - name: Build
        run: bun run build
        if: matrix.template == 'next-saas'
```

- [ ] **Step 6: Create security audit workflow**

Create `ai-project-starter/.github/workflows/security.yml`:

```yaml
name: Security Audit

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9am UTC

jobs:
  audit:
    name: Dependency Security Audit
    runs-on: ubuntu-latest
    strategy:
      matrix:
        template: [next-saas, api-service, automation]
    defaults:
      run:
        working-directory: templates/${{ matrix.template }}

    steps:
      - uses: actions/checkout@v4

      - uses: oven-sh/setup-bun@v2
        with:
          bun-version: latest

      - name: Install dependencies
        run: bun install --frozen-lockfile

      - name: Run audit
        run: bun audit
        continue-on-error: true

      - name: Check for critical vulnerabilities
        run: bun audit --audit-level=critical
```

- [ ] **Step 7: Commit GitHub Actions**

```bash
git add .github/
git commit -m "feat: add CI and security audit GitHub Actions workflows"
```

### Task 2.3: MEMORY.md System

- [ ] **Step 8: Create memory directory with templates**

Create `ai-project-starter/memory/MEMORY.md`:

```markdown
# [PROJECT NAME] — Claude Memory Index
> Last updated: YYYY-MM-DD
> Instructions for Claude: Read this file at the start of every session to restore project context.

---

## Project Identity

- **Name:** [Project Name]
- **Type:** [SaaS / Dashboard / API / Automation]
- **Stack:** [e.g., Next.js 15 + TypeScript + Drizzle + PostgreSQL]
- **Primary URL:** [https://your-app.com or localhost:3000]
- **Repo:** [https://github.com/username/repo]
- **Status:** [In Development / Beta / Production]

---

## Architecture Decisions
→ See `memory/decisions.md`

Key decisions summary:
- [Decision 1]: [Why]
- [Decision 2]: [Why]

---

## Current Sprint / Active Work
→ See `memory/sprint.md`

Active focus: [What we're working on right now]

---

## Known Issues / Tech Debt
→ See `memory/issues.md`

Critical: [Any blocking issues]

---

## External Services & Credentials
→ See `memory/services.md` (NEVER commit real values — use .env)

Services in use: [List services, not keys]

---

## Team & Conventions

- **Branch strategy:** [e.g., main + feature branches]
- **Commit style:** [e.g., conventional commits: feat/fix/chore]
- **Code style:** [e.g., ESLint + Prettier, 2-space indent]
- **Test approach:** [e.g., Vitest unit + Playwright e2e]
```

Create `ai-project-starter/memory/decisions.md`:

```markdown
# Architecture Decisions

> Log significant technical decisions here with context and rationale.
> Format: ## Decision Title, **Date**, **Status** (Active/Superseded), **Context**, **Decision**, **Consequences**

---

## Example: Chose Drizzle over Prisma

**Date:** YYYY-MM-DD
**Status:** Active

**Context:** Needed a TypeScript ORM for PostgreSQL. Evaluated Prisma, Drizzle, and Kysely.

**Decision:** Drizzle ORM — lighter bundle, SQL-first, better edge compatibility, no code generation step.

**Consequences:** SQL knowledge required for complex queries. No Prisma Studio GUI. Better performance at edge.
```

Create `ai-project-starter/memory/sprint.md`:

```markdown
# Current Sprint

**Sprint:** [Sprint name / dates]
**Goal:** [One sentence — what does done look like?]

## In Progress
- [ ] [Task description]

## Done This Sprint
- [x] [Completed task]

## Blocked
- [Blocker description and who owns resolution]

## Next Sprint Preview
- [Upcoming work]
```

Create `ai-project-starter/memory/services.md`:

```markdown
# External Services

> List services and where credentials live. NEVER write actual API keys here.

| Service | Purpose | Credentials Location | Docs |
|---------|---------|----------------------|------|
| PostgreSQL | Primary database | .env → DATABASE_URL | [link] |
| Auth.js | Authentication | .env → AUTH_SECRET + providers | [link] |
| Resend | Transactional email | .env → RESEND_API_KEY | [link] |
| Stripe | Payments | .env → STRIPE_SECRET_KEY | [link] |
| Trigger.dev | Background jobs | .env → TRIGGER_SECRET_KEY | [link] |
| Composio | App integrations | .env → COMPOSIO_API_KEY | [link] |
```

- [ ] **Step 9: Commit memory system**

```bash
git add memory/
git commit -m "feat: add MEMORY.md system — Claude project context templates"
```

### Task 2.4: Improve CLAUDE.md and AGENTS.md

- [ ] **Step 10: Read existing CLAUDE.md**

```bash
cat CLAUDE.md
```

- [ ] **Step 11: Add skills and memory sections to CLAUDE.md**

Append to the existing `CLAUDE.md` (after existing content):

```markdown

---

## Recommended Skills (Claude Code)

Install via `scripts/install-skills.sh` or manually via Claude Code plugin manager.

### Always Install
- `security` — every project needs security review
- `frontend-design` — UI/component work
- `scalability` — before any production deployment
- `superpowers` — TDD, debugging, brainstorming, planning workflows

### By Project Type
| Template | Additional Skills |
|----------|------------------|
| next-saas | `ui-ux-pro-max`, `claude-api` |
| api-service | `scalability`, `security` |
| automation | `trigger-dev`, `composio`, `n8n` |

---

## Memory System

This repo includes a `memory/` folder with Claude memory templates.

1. Copy `memory/MEMORY.md` to your project root
2. Fill in your project details
3. Claude will read it at session start and maintain context across conversations

For cross-session persistent memory, also use the `claude-mem` MCP plugin.

---

## Project Context (fill in when starting a project)

- **Project name:** [NAME]
- **Stack:** [STACK]
- **Current focus:** [WHAT YOU'RE BUILDING]
- **Key constraints:** [DEADLINES, TECH CONSTRAINTS]
```

- [ ] **Step 12: Fix AGENTS.md security placeholders**

Read existing `AGENTS.md`. Search for the placeholder section — it will contain text like `## Security`, `<!-- TODO: fill in security guidelines -->`, or an empty `## Security Guidelines` heading. Replace that entire section (from the heading to the next `##` heading) with:

```markdown
## Security Guidelines for All Agents

### Mandatory Rules
1. **Never output secrets** — Never log, print, or expose API keys, tokens, or credentials in any output
2. **Validate inputs** — All user inputs must be validated before processing
3. **Use parameterized queries** — Never concatenate user input into SQL strings
4. **Escape outputs** — HTML-escape any user content rendered in UI
5. **Principle of least privilege** — Request only the permissions actually needed for the task
6. **Fail closed** — On errors, deny access rather than grant it
7. **No hardcoded credentials** — All secrets come from environment variables

### When Writing Code
- Apply the `security` skill for authentication, API endpoints, form handling, and DB queries
- Add rate limiting to all public-facing endpoints
- Use HTTPS and set security headers (CSP, HSTS, X-Frame-Options)
- Validate file uploads: type, size, and content
```

- [ ] **Step 13: Commit CLAUDE.md and AGENTS.md improvements**

```bash
git add CLAUDE.md AGENTS.md
git commit -m "feat: improve CLAUDE.md with skills guide + memory docs, fill AGENTS.md security section"
```

---

## Chunk 3: Phase 2 — next-saas Template

**Goal:** Create a production-ready Next.js 15 template covering SaaS products, dashboards, and web apps.

**Working directory:** `ai-project-starter/templates/next-saas/`

### Task 3.1: Scaffold Next.js Project

- [ ] **Step 1: Create template with create-next-app**

```bash
cd ai-project-starter/templates
bunx create-next-app@latest next-saas \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --no-turbopack \
  --import-alias "@/*"
cd next-saas
```

- [ ] **Step 2: Install core dependencies**

```bash
bun add \
  next-auth@beta \
  @auth/drizzle-adapter \
  drizzle-orm \
  @neondatabase/serverless \
  @tanstack/react-query \
  recharts \
  zod \
  @t3-oss/env-nextjs

bun add -d \
  drizzle-kit \
  vitest \
  @vitejs/plugin-react \
  @playwright/test \
  @testing-library/react \
  @testing-library/jest-dom \
  jsdom \
  @types/node
```

- [ ] **Step 3: Install shadcn/ui**

```bash
bunx shadcn@latest init --defaults
bunx shadcn@latest add button card input label badge avatar dropdown-menu sidebar sheet table
```

- [ ] **Step 4: Verify install — run dev server**

```bash
bun dev &
sleep 3
curl -s http://localhost:3000 | head -5
kill %1
```

Expected: HTML response from Next.js.

### Task 3.2: Core Configuration Files

- [ ] **Step 5: Create TypeScript config (strict mode)**

Overwrite `tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

- [ ] **Step 6: Create Vitest config**

Create `vitest.config.ts`:

```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./tests/unit/setup.ts'],
  },
  resolve: {
    alias: { '@': path.resolve(__dirname, './src') },
  },
})
```

Create `tests/unit/setup.ts`:

```typescript
import '@testing-library/jest-dom'
```

- [ ] **Step 7: Create Playwright config**

Create `playwright.config.ts`:

```typescript
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
  webServer: {
    command: 'bun dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
})
```

- [ ] **Step 8: Create Drizzle config**

Create `drizzle.config.ts`:

```typescript
import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  schema: './src/lib/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
})
```

- [ ] **Step 9: Update package.json scripts**

Update `package.json` scripts section to:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "vitest",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "db:push": "drizzle-kit push",
    "db:studio": "drizzle-kit studio",
    "db:generate": "drizzle-kit generate",
    "db:migrate": "drizzle-kit migrate"
  }
}
```

### Task 3.3: Core Library Files

- [ ] **Step 10: Create database schema**

Create `src/lib/db/schema.ts`:

```typescript
import { pgTable, text, timestamp, integer, uuid } from 'drizzle-orm/pg-core'

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  name: text('name'),
  email: text('email').notNull().unique(),
  emailVerified: timestamp('email_verified', { mode: 'date' }),
  image: text('image'),
  createdAt: timestamp('created_at', { mode: 'date' }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { mode: 'date' }).notNull().defaultNow(),
})

export const accounts = pgTable('accounts', {
  userId: uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  type: text('type').notNull(),
  provider: text('provider').notNull(),
  providerAccountId: text('provider_account_id').notNull(),
  refresh_token: text('refresh_token'),
  access_token: text('access_token'),
  expires_at: integer('expires_at'),   // integer, not text — OAuth tokens use Unix timestamps
  token_type: text('token_type'),
  scope: text('scope'),
  id_token: text('id_token'),
  session_state: text('session_state'),
})

export const sessions = pgTable('sessions', {
  sessionToken: text('session_token').notNull().primaryKey(),
  userId: uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  expires: timestamp('expires', { mode: 'date' }).notNull(),
})

export const verificationTokens = pgTable('verification_tokens', {
  identifier: text('identifier').notNull(),
  token: text('token').notNull(),
  expires: timestamp('expires', { mode: 'date' }).notNull(),
})

export type User = typeof users.$inferSelect
export type NewUser = typeof users.$inferInsert
```

Create `src/lib/db/index.ts`:

```typescript
import { drizzle } from 'drizzle-orm/neon-http'
import { neon } from '@neondatabase/serverless'
import * as schema from './schema'

const sql = neon(process.env.DATABASE_URL!)
export const db = drizzle(sql, { schema })
```

- [ ] **Step 11: Create Auth.js config**

Create `src/lib/auth/index.ts`:

```typescript
import NextAuth from 'next-auth'
import { DrizzleAdapter } from '@auth/drizzle-adapter'
import GitHub from 'next-auth/providers/github'
import Google from 'next-auth/providers/google'
import { db } from '@/lib/db'
import * as schema from '@/lib/db/schema'

export const { handlers, signIn, signOut, auth } = NextAuth({
  // Explicit table mapping required — our schema uses plural names
  adapter: DrizzleAdapter(db, {
    usersTable: schema.users,
    accountsTable: schema.accounts,
    sessionsTable: schema.sessions,
    verificationTokensTable: schema.verificationTokens,
  }),
  providers: [
    GitHub,
    Google,
  ],
  callbacks: {
    session({ session, user }) {
      session.user.id = user.id
      return session
    },
  },
})
```

Create `src/app/api/auth/[...nextauth]/route.ts`:

```typescript
import { handlers } from '@/lib/auth'
export const { GET, POST } = handlers
```

- [ ] **Step 12: Create utility functions**

Create `src/lib/utils/index.ts`:

```typescript
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatCurrency(amount: number, currency = 'USD'): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
  }).format(amount)
}

export function formatDate(date: Date | string): string {
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  }).format(new Date(date))
}
```

- [ ] **Step 13: Write unit tests for utils (TDD — write test first)**

Create `tests/unit/utils.test.ts`:

```typescript
import { describe, it, expect } from 'vitest'
import { cn, formatCurrency, formatDate } from '@/lib/utils'

describe('cn', () => {
  it('merges class names', () => {
    expect(cn('foo', 'bar')).toBe('foo bar')
  })

  it('resolves tailwind conflicts — last wins', () => {
    expect(cn('text-red-500', 'text-blue-500')).toBe('text-blue-500')
  })

  it('handles falsy values', () => {
    expect(cn('foo', undefined, null, false, 'bar')).toBe('foo bar')
  })
})

describe('formatCurrency', () => {
  it('formats USD by default', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56')
  })

  it('formats EUR', () => {
    expect(formatCurrency(100, 'EUR')).toContain('100')
  })
})

describe('formatDate', () => {
  it('formats a date string', () => {
    const result = formatDate('2026-01-15')
    expect(result).toContain('2026')
    expect(result).toContain('Jan')
  })
})
```

- [ ] **Step 14: Run tests — verify they pass**

```bash
bun run test -- --run
```

Expected: All 5 tests pass.

### Task 3.4: App Layout and Pages

- [ ] **Step 15: Create dashboard layout**

Create `src/app/(dashboard)/layout.tsx`:

```typescript
import { auth } from '@/lib/auth'
import { redirect } from 'next/navigation'
import { Sidebar } from '@/components/layout/sidebar'

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const session = await auth()
  if (!session) redirect('/login')

  return (
    <div className="flex h-screen bg-background">
      <Sidebar />
      <main className="flex-1 overflow-auto p-6">
        {children}
      </main>
    </div>
  )
}
```

Create `src/app/(dashboard)/dashboard/page.tsx`:

```typescript
import { auth } from '@/lib/auth'

export default async function DashboardPage() {
  const session = await auth()

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Dashboard</h1>
      <p className="text-muted-foreground">
        Welcome back, {session?.user?.name ?? 'User'}
      </p>
    </div>
  )
}
```

- [ ] **Step 16: Create Sidebar component**

Create `src/components/layout/sidebar.tsx`:

```typescript
'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import { LayoutDashboard, Settings, LogOut } from 'lucide-react'
import { signOut } from 'next-auth/react'

const navItems = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/settings', label: 'Settings', icon: Settings },
]

export function Sidebar() {
  const pathname = usePathname()

  return (
    <aside className="w-64 border-r bg-background flex flex-col">
      <div className="p-6">
        <h2 className="text-lg font-semibold">My App</h2>
      </div>
      <nav className="flex-1 px-4 space-y-1">
        {navItems.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              'flex items-center gap-3 px-3 py-2 rounded-md text-sm transition-colors',
              pathname === item.href
                ? 'bg-primary text-primary-foreground'
                : 'text-muted-foreground hover:text-foreground hover:bg-muted'
            )}
          >
            <item.icon className="h-4 w-4" />
            {item.label}
          </Link>
        ))}
      </nav>
      <div className="p-4 border-t">
        <button
          onClick={() => signOut()}
          className="flex items-center gap-3 px-3 py-2 w-full rounded-md text-sm text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
        >
          <LogOut className="h-4 w-4" />
          Sign out
        </button>
      </div>
    </aside>
  )
}
```

- [ ] **Step 17: Install lucide-react**

```bash
bun add lucide-react
```

- [ ] **Step 18: Create auth pages**

Create `src/app/(auth)/login/page.tsx`:

```typescript
import { signIn } from '@/lib/auth'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <Card className="w-full max-w-sm">
        <CardHeader>
          <CardTitle>Sign in</CardTitle>
          <CardDescription>Choose your sign in method</CardDescription>
        </CardHeader>
        <CardContent className="space-y-3">
          <form action={async () => {
            'use server'
            await signIn('github', { redirectTo: '/dashboard' })
          }}>
            <Button type="submit" variant="outline" className="w-full">
              Continue with GitHub
            </Button>
          </form>
          <form action={async () => {
            'use server'
            await signIn('google', { redirectTo: '/dashboard' })
          }}>
            <Button type="submit" variant="outline" className="w-full">
              Continue with Google
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
```

- [ ] **Step 19: Create route protection middleware**

Create `src/middleware.ts` (at the project root, not in src/app/):

```typescript
import { auth } from '@/lib/auth'
import { NextResponse } from 'next/server'

export default auth((req) => {
  const isLoggedIn = !!req.auth
  const isAuthPage = req.nextUrl.pathname.startsWith('/login')
  const isDashboard = req.nextUrl.pathname.startsWith('/dashboard')

  if (isDashboard && !isLoggedIn) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  if (isAuthPage && isLoggedIn) {
    return NextResponse.redirect(new URL('/dashboard', req.url))
  }

  return NextResponse.next()
})

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'],
}
```

- [ ] **Step 20: Create template .env.example**

Create `templates/next-saas/.env.example`:

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/myapp

# Auth.js v5 — AUTH_URL required for non-Vercel deployments
AUTH_URL=http://localhost:3000
AUTH_SECRET=run-openssl-rand-base64-32
AUTH_GITHUB_ID=
AUTH_GITHUB_SECRET=
AUTH_GOOGLE_ID=
AUTH_GOOGLE_SECRET=

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

- [ ] **Step 21: Create template README**

Create `templates/next-saas/README.md`:

```markdown
# next-saas Template

Full-stack Next.js 15 starter for SaaS products, dashboards, and web applications.

## Stack

- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript (strict)
- **Styling:** Tailwind CSS + shadcn/ui
- **Auth:** Auth.js v5 (GitHub + Google OAuth)
- **Database:** Drizzle ORM + PostgreSQL (Neon)
- **Testing:** Vitest (unit) + Playwright (e2e)
- **Charts:** Recharts

## Quick Start

1. Copy this folder: `cp -r templates/next-saas my-project && cd my-project`
2. Install: `bun install`
3. Copy env: `cp .env.example .env` and fill in values
4. Push DB schema: `bun db:push`
5. Start dev: `bun dev`

## Recommended Skills

Install these Claude Code skills for best AI assistance on this template:

- `security` — auth, API endpoints, input validation
- `frontend-design` — UI/component work
- `ui-ux-pro-max` — design system and UX patterns
- `scalability` — before adding caching, queues, or multi-region

## Project Structure

- `src/app/(auth)/` — login, register, forgot-password pages
- `src/app/(dashboard)/` — protected dashboard pages
- `src/app/api/` — API routes
- `src/components/ui/` — shadcn/ui base components
- `src/components/layout/` — Sidebar, Navbar, Header
- `src/lib/db/` — Drizzle schema and queries
- `src/lib/auth/` — Auth.js configuration
- `tests/unit/` — Vitest unit tests
- `tests/e2e/` — Playwright end-to-end tests
```

- [ ] **Step 22: Final type-check and lint**

```bash
bun run typecheck
bun run lint
bun run test -- --run
```

Expected: 0 type errors, 0 lint errors, all tests pass.

- [ ] **Step 23: Commit next-saas template**

```bash
cd ../..  # back to ai-project-starter root
git add templates/next-saas/
git commit -m "feat: add next-saas template — Next.js 15 + Auth.js + Drizzle + shadcn/ui + Vitest + Playwright"
```

---

## Chunk 4: Phase 3 — api-service Template

**Goal:** Create a lightweight, production-ready backend API template with Bun + Hono.

**Working directory:** `ai-project-starter/templates/api-service/`

### Task 4.1: Scaffold API Service

- [ ] **Step 1: Create project**

```bash
mkdir -p templates/api-service/src/{routes,middleware,db,validators}
mkdir -p templates/api-service/tests
cd templates/api-service
bun init -y
```

- [ ] **Step 2: Install dependencies**

```bash
bun add hono drizzle-orm @neondatabase/serverless zod
bun add -d \
  @types/bun \
  drizzle-kit \
  vitest \
  typescript
```

- [ ] **Step 3: Create tsconfig.json**

Create `templates/api-service/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "types": ["bun-types"],
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["src", "tests"]
}
```

- [ ] **Step 4: Create Vitest config for api-service**

Create `templates/api-service/vitest.config.ts`:

```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
  },
})
```

- [ ] **Step 5: Create main app entry**

Create `templates/api-service/src/index.ts`:

```typescript
import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'
import { secureHeaders } from 'hono/secure-headers'
import { errorHandler } from './middleware/error-handler'
import { usersRouter } from './routes/users'

const app = new Hono()

// Middleware
app.use('*', logger())
app.use('*', secureHeaders())
app.use('/api/*', cors({
  origin: process.env.ALLOWED_ORIGIN ?? 'http://localhost:3000',
  credentials: true,
}))

// Routes
app.route('/api/users', usersRouter)

// Health check
app.get('/health', (c) => c.json({ status: 'ok', timestamp: new Date().toISOString() }))

// Error handler
app.onError(errorHandler)

export default {
  port: parseInt(process.env.PORT ?? '3001'),
  fetch: app.fetch,
}
```

- [ ] **Step 6: Create error handler middleware**

Create `templates/api-service/src/middleware/error-handler.ts`:

```typescript
import type { Context } from 'hono'
import type { StatusCode } from 'hono/utils/http-status'

export function errorHandler(err: Error, c: Context) {
  console.error(`[Error] ${err.message}`)

  if (err.name === 'ZodError') {
    return c.json({ error: 'Validation failed', details: JSON.parse(err.message) }, 400)
  }

  return c.json(
    { error: process.env.NODE_ENV === 'production' ? 'Internal server error' : err.message },
    500 as StatusCode
  )
}
```

- [ ] **Step 7: Create users route (TDD — write test first)**

Create `templates/api-service/tests/users.test.ts`:

```typescript
import { describe, it, expect } from 'vitest'
import app from '../src/index'

describe('GET /health', () => {
  it('returns 200 with status ok', async () => {
    const res = await app.fetch(new Request('http://localhost/health'))
    const body = await res.json() as { status: string }
    expect(res.status).toBe(200)
    expect(body.status).toBe('ok')
  })
})

describe('GET /api/users', () => {
  it('returns 200 with array', async () => {
    const res = await app.fetch(new Request('http://localhost/api/users'))
    expect(res.status).toBe(200)
    const body = await res.json() as unknown[]
    expect(Array.isArray(body)).toBe(true)
  })
})
```

- [ ] **Step 8: Run failing test**

```bash
bun test
```

Expected: FAIL — `/api/users` route not found.

- [ ] **Step 9: Create users route to make test pass**

Create `templates/api-service/src/routes/users.ts`:

```typescript
import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

export const usersRouter = new Hono()

// GET /api/users
usersRouter.get('/', async (c) => {
  // TODO: Replace with actual DB query
  return c.json([])
})

// POST /api/users
const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
})

usersRouter.post('/', zValidator('json', createUserSchema), async (c) => {
  const body = c.req.valid('json')
  // TODO: Insert into DB
  return c.json({ id: crypto.randomUUID(), ...body }, 201)
})
```

- [ ] **Step 10: Install missing dep and run tests**

```bash
bun add @hono/zod-validator
bun test
```

Expected: All tests pass.

- [ ] **Step 11: Update package.json scripts**

```json
{
  "scripts": {
    "dev": "bun run --watch src/index.ts",
    "start": "bun run src/index.ts",
    "test": "vitest",
    "typecheck": "tsc --noEmit",
    "lint": "bunx @biomejs/biome check src/",
    "db:push": "drizzle-kit push",
    "db:generate": "drizzle-kit generate"
  }
}
```

- [ ] **Step 12: Create .env.example**

Create `templates/api-service/.env.example`:

```bash
DATABASE_URL=postgresql://user:password@localhost:5432/myapi
PORT=3001
NODE_ENV=development
ALLOWED_ORIGIN=http://localhost:3000
JWT_SECRET=run-openssl-rand-base64-32
```

- [ ] **Step 13: Final checks and commit**

```bash
cd templates/api-service
bun run typecheck
bun test
```

Expected: 0 errors, all tests pass.

```bash
cd ../..
git add templates/api-service/
git commit -m "feat: add api-service template — Bun + Hono + Drizzle + Zod + Vitest"
```

---

## Chunk 5: Phase 4 — automation Template

**Goal:** Create a Trigger.dev + Composio + n8n automation template for background jobs and workflows.

**Working directory:** `ai-project-starter/templates/automation/`

### Task 5.1: Scaffold Automation Project

- [ ] **Step 1: Scaffold automation project manually**

The Trigger.dev v3 CLI `init` command is interactive and does not accept positional name arguments. Scaffold manually instead:

```bash
mkdir -p templates/automation/src/{jobs,workflows,integrations}
mkdir -p templates/automation/tests
cd templates/automation
bun init -y
```

Then configure Trigger.dev by creating `trigger.config.ts`:

```typescript
import { defineConfig } from '@trigger.dev/sdk/v3'

export default defineConfig({
  project: process.env.TRIGGER_PROJECT_ID ?? 'proj_placeholder',
  dirs: ['./src/jobs', './src/integrations'],
})
```

- [ ] **Step 2: Install additional dependencies**

```bash
bun add composio-core zod
bun add -d vitest @types/bun typescript
```

- [ ] **Step 3: Create tsconfig.json**

Create `templates/automation/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "types": ["bun-types"],
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["src", "tests"]
}
```

- [ ] **Step 4: Create example scheduled job (TDD — test first)**

Create `templates/automation/tests/email-digest.test.ts`:

```typescript
import { describe, it, expect, vi } from 'vitest'
import { buildDigestContent } from '../src/jobs/email-digest'

describe('buildDigestContent', () => {
  it('formats items into digest string', () => {
    const items = [
      { title: 'Update 1', url: 'https://example.com/1' },
      { title: 'Update 2', url: 'https://example.com/2' },
    ]
    const result = buildDigestContent(items)
    expect(result).toContain('Update 1')
    expect(result).toContain('Update 2')
    expect(result).toContain('https://example.com/1')
  })

  it('returns empty message when no items', () => {
    const result = buildDigestContent([])
    expect(result).toContain('No updates')
  })
})
```

- [ ] **Step 5: Run — verify it fails**

```bash
bun test
```

Expected: FAIL — `buildDigestContent` not found.

- [ ] **Step 6: Create the job to make test pass**

Create `templates/automation/src/jobs/email-digest.ts`:

```typescript
import { schedules } from '@trigger.dev/sdk/v3'

export interface DigestItem {
  title: string
  url: string
}

export function buildDigestContent(items: DigestItem[]): string {
  if (items.length === 0) return 'No updates for this period.'

  return items
    .map((item, i) => `${i + 1}. ${item.title}\n   ${item.url}`)
    .join('\n\n')
}

export const weeklyDigestJob = schedules.task({
  id: 'weekly-email-digest',
  cron: '0 9 * * 1', // Every Monday at 9am UTC
  run: async (payload) => {
    const items: DigestItem[] = [
      // TODO: Fetch real items from your data source
    ]

    const content = buildDigestContent(items)
    console.log('Digest content:', content)

    // TODO: Send via Resend or your email provider
    return { success: true, itemCount: items.length }
  },
})
```

- [ ] **Step 7: Create Composio integration example**

Create `templates/automation/src/integrations/github-notifier.ts`:

```typescript
import { task } from '@trigger.dev/sdk/v3'
import { z } from 'zod'

const payloadSchema = z.object({
  repo: z.string(),
  message: z.string(),
})

export const githubNotifierTask = task({
  id: 'github-notifier',
  run: async (payload: z.infer<typeof payloadSchema>) => {
    const { repo, message } = payloadSchema.parse(payload)

    // TODO: Use Composio to create a GitHub issue or comment
    // const composio = new ComposioToolSet({ apiKey: process.env.COMPOSIO_API_KEY })
    // await composio.executeAction('GITHUB_CREATE_ISSUE', { repo, title: message })

    console.log(`Would notify ${repo}: ${message}`)
    return { notified: true, repo, message }
  },
})
```

- [ ] **Step 8: Run tests**

```bash
bun test
```

Expected: All tests pass.

- [ ] **Step 9: Create .env.example**

Create `templates/automation/.env.example`:

```bash
TRIGGER_SECRET_KEY=tr_dev_...
TRIGGER_PROJECT_ID=proj_...
COMPOSIO_API_KEY=
# Add any service-specific keys your jobs need
DATABASE_URL=postgresql://user:password@localhost:5432/automation
```

- [ ] **Step 10: Update scripts and commit**

Update `package.json` scripts:

```json
{
  "scripts": {
    "dev": "bunx trigger.dev@latest dev",
    "deploy": "bunx trigger.dev@latest deploy",
    "test": "vitest",
    "typecheck": "tsc --noEmit"
  }
}
```

```bash
cd ../..
git add templates/automation/
git commit -m "feat: add automation template — Trigger.dev + Composio + Vitest"
```

---

## Chunk 6: Phase 5 — Documentation

**Goal:** Rewrite README, add docs/ folder, skills guide, memory guide, and per-template docs.

### Task 6.1: Rewrite Main README

- [ ] **Step 1: Write new README.md**

Overwrite `ai-project-starter/README.md`:

```markdown
# ai-project-starter

> The AI-native project starter: multi-agent Claude Code configuration + three production-ready templates.

[![CI](https://github.com/Yhoswar/ai-project-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/Yhoswar/ai-project-starter/actions/workflows/ci.yml)

## What's Inside

Two independent layers:

**1. AI Config Layer** — Works with any codebase
- 7 specialized Claude Code agents (Director, Architect, Frontend, Backend, Marketer, Researcher, Reviewer)
- Slash commands: `/team-plan`, `/team-status`, `/team-review`
- `MEMORY.md` system for project context across sessions
- Compatible with Claude Code and OpenCode

**2. Application Templates** — Production-ready starters
| Template | Stack | Best for |
|----------|-------|----------|
| `next-saas` | Next.js 15 + Auth.js + Drizzle + shadcn/ui | SaaS, dashboards, web apps |
| `api-service` | Bun + Hono + Drizzle + Zod | REST APIs, microservices |
| `automation` | Trigger.dev + Composio + n8n | Background jobs, workflows, integrations |

## Quick Start

### Option A: Use a Template
```bash
# Clone the repo
git clone https://github.com/Yhoswar/ai-project-starter.git
cd ai-project-starter

# Copy your chosen template
cp -r templates/next-saas ../my-project
cd ../my-project

# Set up
bun install
cp .env.example .env  # Fill in your values
bun db:push
bun dev
```

### Option B: Add AI Agents to Existing Project
```bash
# Copy just the AI config layer
cp -r ai-project-starter/.claude your-project/
cp ai-project-starter/CLAUDE.md your-project/
cp ai-project-starter/AGENTS.md your-project/
cp -r ai-project-starter/memory your-project/
```

### Option C: Run the Init Script
```bash
./scripts/init.sh
```

## Install Skills Globally

Make skills available in all your Claude Code projects:

```bash
# bash/zsh
./scripts/install-skills.sh

# PowerShell
./scripts/install-skills.ps1
```

Or manually: see [docs/skills-guide.md](docs/skills-guide.md)

## Documentation

- [Getting Started](docs/getting-started.md)
- [Skills Guide](docs/skills-guide.md) — Which skills to install for each project type
- [Memory Guide](docs/memory-guide.md) — How to use MEMORY.md and claude-mem
- [Agents Guide](docs/agents-guide.md) — How the multi-agent system works

## Platform Support

| Platform | Status |
|----------|--------|
| Claude Code | ✅ Full support |
| OpenCode | ✅ Full support |
| Gemini CLI | 🔜 Via bridge skill |

## License

MIT
```

### Task 6.2: Create docs/ Files

- [ ] **Step 2: Create skills guide**

Create `docs/skills-guide.md`:

```markdown
# Skills Guide

> Which Claude Code skills to install for each project type.

## Install Skills Globally

Run the installer script to make all core skills available in every project:

```bash
./scripts/install-skills.sh        # bash/zsh
./scripts/install-skills.ps1       # PowerShell
```

## Core Skills (Install for Every Project)

| Skill | What it does | Source |
|-------|-------------|--------|
| `security` | Secure coding, OWASP, auth patterns | yhosw-skills plugin |
| `frontend-design` | Production-quality UI components | claude-plugins-official |
| `scalability` | DB optimization, caching, API design | yhosw-skills plugin |
| `superpowers` | TDD, debugging, planning workflows | superpowers-marketplace |

## By Project Type

### next-saas
Additional skills to install:
- `ui-ux-pro-max` — design system, color palettes, shadcn/ui patterns
- `claude-api` — if adding AI features

### api-service
Core skills are sufficient. Additionally:
- `security` — especially for auth middleware and input validation

### automation
- `trigger-dev` — Trigger.dev jobs, scheduling, error handling
- `composio` — 1000+ app integrations (GitHub, Gmail, Slack, Notion)
- `n8n` — n8n workflow building and custom nodes

## Installing Individual Skills

Via Claude Code plugin manager or manually add to `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "yhosw-skills@yhosw-skills": true
  },
  "extraKnownMarketplaces": {
    "yhosw-skills": {
      "source": {
        "source": "github",
        "repo": "Yhoswar/claude-skills"
      }
    }
  }
}
```
```

- [ ] **Step 3: Create memory guide**

Create `docs/memory-guide.md`:

```markdown
# Memory Guide

## Two Memory Systems

### MEMORY.md — Per-Project Context (in this repo)
File-based, git-versioned, per-project. Claude reads it at session start.

**Setup:**
1. Copy `memory/MEMORY.md` to your project root
2. Fill in your project details
3. Update it as your project evolves

**What to put in it:**
- Project name, stack, current goal
- Key architecture decisions (link to `memory/decisions.md`)
- Active sprint / what you're working on
- External services in use (without credentials)

**What NOT to put in it:**
- API keys or secrets (use .env)
- Temporary debug notes
- Code snippets (they go in the code)

### claude-mem MCP — Cross-Session Database
Persistent memory across ALL sessions and projects. Uses smart search.

**When to use:** "Did we solve this bug before?" / "How did we configure X last time?"

**Usage:** The `claude-mem` plugin is pre-installed. Claude uses it automatically, or you can ask: "Search your memory for [topic]"

## Memory Hierarchy

```
~/.claude/memory/           ← Global user memory (all projects)
  user_*.md                 ← About you and your preferences
  feedback_*.md             ← What works / what to avoid

project-root/memory/        ← This project's memory
  MEMORY.md                 ← Index (Claude reads this first)
  decisions.md              ← Architecture decisions log
  sprint.md                 ← Current work in progress
  services.md               ← External services (no secrets)

claude-mem MCP database     ← Cross-session searchable history
```
```

- [ ] **Step 4: Create getting-started guide**

Create `docs/getting-started.md`:

```markdown
# Getting Started

## Prerequisites

- [Node.js 20+](https://nodejs.org)
- [Bun](https://bun.sh) — `curl -fsSL https://bun.sh/install | bash`
- [Git](https://git-scm.com)
- [Claude Code](https://claude.ai/code) — for AI agent features
- [GitHub CLI](https://cli.github.com) — optional, for scripts

## 1. Clone

```bash
git clone https://github.com/Yhoswar/ai-project-starter.git
cd ai-project-starter
```

## 2. Choose Your Path

**New project from template:**
```bash
cp -r templates/next-saas ../my-project
cd ../my-project
bun install
cp .env.example .env
```

**Add agents to existing project:**
```bash
cp -r .claude /path/to/your-project/
cp CLAUDE.md AGENTS.md /path/to/your-project/
cp -r memory /path/to/your-project/
```

## 3. Install Skills Globally

```bash
./scripts/install-skills.sh
```

## 4. Configure Memory

Edit `memory/MEMORY.md` in your project to describe what you're building.

## 5. Open Claude Code

```bash
claude  # opens in your project directory
```

Try `/team-plan` to kick off planning with all 7 agents.

## Troubleshooting

**Skills not loading?**
- Run `./scripts/install-skills.sh` again
- Check `~/.claude/settings.json` has `yhosw-skills@yhosw-skills: true`
- Restart Claude Code

**Template won't start?**
- Ensure `.env` is filled out (not `.env.example`)
- Run `bun install` first
- For next-saas: run `bun db:push` to create DB tables
```

- [ ] **Step 5: Create agents guide**

Create `docs/agents-guide.md`:

```markdown
# Agents Guide

## The Multi-Agent System

This repo ships 7 specialized agents that collaborate via Claude Code.

| Agent | Role | Use for |
|-------|------|---------|
| Director | Orchestrates other agents | Project planning, delegation |
| Architect | System design | Architecture decisions, technical tradeoffs |
| Frontend | UI/UX implementation | Components, pages, styling |
| Backend | API and data layer | Routes, DB queries, auth |
| Marketer | Product messaging | Landing pages, copy, positioning |
| Researcher | Deep research | Finding solutions, comparing options |
| Reviewer | Code quality | PR review, security audit |

## Slash Commands

```bash
/team-plan    # Director creates a plan using all relevant agents
/team-status  # Summary of current progress across all areas
/team-review  # Full code review using Reviewer + security scan
```

## How to Use

**Start a feature:**
```
/team-plan Build a user dashboard with usage stats and recent activity
```

**Get a code review:**
```
/team-review
```

**Ask a specific agent:**
```
@architect What's the best approach for handling file uploads at scale?
@frontend Build a responsive data table with sorting and filtering
@backend Add rate limiting to all /api/auth/* routes
```

## Adding Custom Agents

Add a new file to `.claude/agents/`:

```markdown
---
name: your-agent-name
description: When to invoke this agent
---

# Agent Role

Your agent instructions here.
```
```

- [ ] **Step 6: Commit all documentation**

```bash
git add docs/ README.md
git commit -m "docs: rewrite README and add full docs/ folder — getting-started, skills-guide, memory-guide, agents-guide"
```

### Task 6.3: Create Install Scripts

- [ ] **Step 7: Create install-skills.sh**

Create `scripts/install-skills.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# install-skills.sh — Install Claude Code skills globally
# Makes skills available in ALL projects, not just Claude Skills directory
# ============================================================

# Source path: configure via SKILLS_ROOT env var or use OS default
if [[ -n "${SKILLS_ROOT:-}" ]]; then
  SOURCE_DIR="$SKILLS_ROOT"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -d "/c/Users" ]]; then
  # Windows (Git Bash / MSYS2)
  SOURCE_DIR="${USERPROFILE}/OneDrive/Desktop/Claude Skills"
else
  # macOS / Linux
  SOURCE_DIR="$HOME/Claude Skills"
fi

DEST_DIR="$HOME/.claude/plugins/local-skills"

echo "============================================================"
echo "Claude Code Skills Installer"
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo "============================================================"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "ERROR: Claude Skills folder not found at: $SOURCE_DIR"
  echo "Set SKILLS_ROOT=/path/to/your/skills and retry."
  exit 1
fi

# Core skills always installed
CORE_SKILLS=("security" "scalability" "frontend-design" "researcher" "know-me" "self-healing")

# Optional skills (prompted)
OPTIONAL_SKILLS=("trigger-dev" "composio" "n8n" "cost-reducer" "customer-support" "create-skill")

mkdir -p "$DEST_DIR"

install_skill() {
  local skill="$1"
  local src="$SOURCE_DIR/$skill"
  local dest="$DEST_DIR/$skill"

  if [[ ! -d "$src" ]]; then
    echo "  SKIP: $skill (not found in $SOURCE_DIR)"
    return
  fi

  if [[ -d "$dest" ]]; then
    echo "  OK (already installed): $skill"
    return
  fi

  cp -r "$src" "$dest"
  echo "  INSTALLED: $skill"
}

echo ""
echo "Installing core skills..."
for skill in "${CORE_SKILLS[@]}"; do
  install_skill "$skill"
done

echo ""
echo "Optional skills (press Enter to skip, 'y' to install):"
for skill in "${OPTIONAL_SKILLS[@]}"; do
  read -rp "  Install $skill? [y/N] " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    install_skill "$skill"
  fi
done

echo ""
echo "Done! Restart Claude Code for changes to take effect."
echo ""
echo "NOTE: To register as a plugin, update ~/.claude/settings.json"
echo "See docs/skills-guide.md for instructions."
```

```bash
chmod +x scripts/install-skills.sh
```

- [ ] **Step 8: Create install-skills.ps1 (Windows PowerShell)**

Create `scripts/install-skills.ps1`:

```powershell
# ============================================================
# install-skills.ps1 — Install Claude Code skills globally (Windows)
# ============================================================

$ErrorActionPreference = "Stop"

# Source path
if ($env:SKILLS_ROOT) {
  $SourceDir = $env:SKILLS_ROOT
} else {
  $SourceDir = "$env:USERPROFILE\OneDrive\Desktop\Claude Skills"
}

$DestDir = "$env:USERPROFILE\.claude\plugins\local-skills"

Write-Host "============================================================"
Write-Host "Claude Code Skills Installer"
Write-Host "Source: $SourceDir"
Write-Host "Destination: $DestDir"
Write-Host "============================================================"

if (-not (Test-Path $SourceDir)) {
  Write-Error "ERROR: Claude Skills folder not found at: $SourceDir"
  Write-Host "Set SKILLS_ROOT=C:\path\to\your\skills and retry."
  exit 1
}

$CoreSkills = @("security", "scalability", "frontend-design", "researcher", "know-me", "self-healing")
$OptionalSkills = @("trigger-dev", "composio", "n8n", "cost-reducer", "customer-support", "create-skill")

if (-not (Test-Path $DestDir)) {
  New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
}

function Install-Skill {
  param([string]$Skill)
  $Src = Join-Path $SourceDir $Skill
  $Dest = Join-Path $DestDir $Skill

  if (-not (Test-Path $Src)) {
    Write-Host "  SKIP: $Skill (not found)"
    return
  }
  if (Test-Path $Dest) {
    Write-Host "  OK (already installed): $Skill"
    return
  }
  Copy-Item -Recurse $Src $Dest
  Write-Host "  INSTALLED: $Skill"
}

Write-Host ""
Write-Host "Installing core skills..."
foreach ($skill in $CoreSkills) { Install-Skill $skill }

Write-Host ""
Write-Host "Optional skills:"
foreach ($skill in $OptionalSkills) {
  $answer = Read-Host "  Install $skill? [y/N]"
  if ($answer -match "^[Yy]$") { Install-Skill $skill }
}

Write-Host ""
Write-Host "Done! Restart Claude Code for changes to take effect."
```

- [ ] **Step 9: Improve init.sh for idempotency**

The existing `scripts/init.sh` should be verified to be idempotent (running twice doesn't overwrite). Add a check at the top if it doesn't already exist:

```bash
# Check if already initialized
if [[ -f ".initialized" ]]; then
  echo "Project already initialized. Remove .initialized to re-run."
  exit 0
fi
```

And at the end:
```bash
touch .initialized
echo "Initialization complete!"
```

- [ ] **Step 10: Commit scripts**

```bash
git add scripts/
git commit -m "feat: add install-skills.sh + install-skills.ps1 — global skills installer for bash and PowerShell"
```

### Task 6.4: Final Verification

- [ ] **Step 11: Run full CI check locally**

```bash
# Test each template
for template in next-saas api-service automation; do
  echo "=== Testing $template ==="
  cd templates/$template
  bun install --frozen-lockfile
  bun run typecheck
  bun run test -- --run
  cd ../..
done
```

Expected: All templates pass typecheck and tests.

- [ ] **Step 12: Verify repo structure matches spec**

```bash
ls -la
ls -la .github/workflows/
ls -la templates/
ls -la docs/
ls -la memory/
ls -la scripts/
```

Expected: All directories and files from the spec are present.

- [ ] **Step 13: Final commit and push**

```bash
git log --oneline -10
git push origin main
```

- [ ] **Step 14: Verify GitHub Actions pass**

```bash
gh run list --limit 5
gh run watch  # Watch the latest run
```

Expected: CI workflow passes on all 3 templates.

- [ ] **Step 15: Score the repo (self-assessment)**

Check each dimension from the spec Section 7 and confirm ≥8/10 on all:
- [ ] Structure: templates/, docs/, memory/, .github/ all present
- [ ] Stack: Next.js 15 + Bun + TypeScript confirmed in each template
- [ ] Tooling: ESLint + Prettier + TypeScript in each template
- [ ] Documentation: README + docs/ complete
- [ ] SaaS readiness: next-saas has auth + DB + dashboard
- [ ] Security: .gitignore complete, .env.example present, security workflow active
- [ ] CI/CD: GitHub Actions passing
- [ ] Testing: Vitest in all 3 templates, Playwright in next-saas

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-03-16-ai-project-starter-upgrade.md`.

**This plan requires subagent-driven-development for optimal execution.** The chunks are designed to be executed sequentially (each chunk depends on the previous), with sub-agents handling individual tasks within each chunk.

Execution order:
1. Chunk 1 (Skills Plugin) — must be first, enables global skills
2. Chunk 2 (Foundation) — must be before templates
3. Chunks 3-5 (Templates) — can be parallelized across 3 sub-agents
4. Chunk 6 (Docs + Scripts) — must be last

Ready to execute? Invoke `superpowers:subagent-driven-development`.
