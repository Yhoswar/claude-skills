# Skills del Marketplace (Plugin Cache)

Estas skills se instalan vía `/install-skill` y viven en el plugin cache de Claude Code, no en este repositorio.

---

## Superpowers Marketplace

**Repo:** `obra/superpowers-marketplace`  
**Instalación:** `/install-skill superpowers-marketplace`

### Skills Incluidas

| Skill | Cuándo se activa |
|-------|------------------|
| `test-driven-development` | Antes de escribir código para features/bugfixes |
| `systematic-debugging` | Bugs, test failures, comportamiento inesperado |
| `brainstorming` | Antes de cualquier trabajo creativo |
| `writing-plans` | Cuando hay spec/requerimientos para tarea multi-step |
| `executing-plans` | Ejecutar planes escritos en sesión separada |
| `using-superpowers` | Al iniciar cualquier conversación |
| `verification-before-completion` | Antes de claimar trabajo completo/passing |
| `requesting-code-review` | Al completar features o antes de merge |
| `receiving-code-review` | Al implementar sugerencias de code review |
| `dispatching-parallel-agents` | 2+ tareas independientes paralelizables |
| `subagent-driven-development` | Ejecutar planes con subagentes en sesión actual |
| `finishing-a-development-branch` | Implementación completa, tests passing |
| `using-git-worktrees` | Feature work que necesita aislamiento |
| `writing-skills` | Crear/editar/verificar skills |

---

## Skills de Diseño y UX

### emil-design-eng

**Origen:** Emil Kowalski's philosophy on UI polish  
**Instalación:** `/install-skill superpowers-marketplace`  
**Propósito:** UI polish, animaciones, detalles invisibles, micro-interacciones

**Cuándo usar:**
- Componentes UI que necesitan polish visual
- Decisiones de animación y transiciones
- Detalles que hacen la UI "feel polished"

---

### web-accessibility

**Origen:** WCAG 2.1 guidelines  
**Instalación:** `/install-skill superpowers-marketplace`  
**Propósito:** Accesibilidad web - ARIA, keyboard navigation, screen readers

**Cuándo usar:**
- Construir componentes accesibles desde el inicio
- Fixear issues de accesibilidad
- Implementar ARIA attributes, focus management

---

### web-design-guidelines

**Origen:** Web Interface Guidelines  
**Instalación:** `/install-skill superpowers-marketplace`  
**Propósito:** Review de UI contra Web Interface Guidelines

**Cuándo usar:**
- `/review my UI`
- `/check accessibility`
- `/audit design`

---

## Notas de Instalación

Estas skills **no** tienen carpeta en este repositorio porque:

1. Se distribuyen vía marketplace de Claude Code
2. Viven en el plugin cache (`~/.claude/plugins/`)
3. Se actualizan automáticamente con el marketplace

Para replicar en una PC nueva, usar:
```bash
/install-skill superpowers-marketplace
```

Esto instala automáticamente todas las skills listadas arriba.
