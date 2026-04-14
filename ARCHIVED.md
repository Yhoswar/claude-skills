# Catálogo de skills archivados
> Restaurar: `mv ~/OneDrive/Desktop/Claude/claude-skills/archived/<nombre> ~/.claude/skills/<nombre>` + reiniciar sesión

---

## Workflow Eng / SaaS (archivados 2026-04-13)
> Restaurar grupo completo si iniciás un SaaS o proyecto con deploy pipeline.

| Skill | Qué hace |
|---|---|
| `plan-ceo-review` | Review de planes desde perspectiva CEO/founder |
| `plan-eng-review` | Review de planes desde perspectiva de eng manager |
| `plan-design-review` | Review de planes desde perspectiva de diseñador |

---

## SEO sub-skills (archivados 2026-04-13)
> No necesarios: `/seo-audit` usa los **agentes** `seo-*` en `~/.claude/agents/` — esos NO están archivados.
> Solo restaurar si querés invocar un sub-skill manualmente sin auditoría completa.

| Skill | Qué hace |
|---|---|
| `seo-page` | Análisis SEO profundo de una sola página |
| `seo-content` | Calidad de contenido y E-E-A-T |
| `seo-technical` | Auditoría técnica: crawl, robots, JS rendering |
| `seo-sitemap` | Validación y generación de sitemaps XML |
| `seo-geo` | Optimización para AI Overviews y GEO |
| `seo-google` | APIs de Google: Search Console + GA4 |
| `seo-dataforseo` | Datos live vía DataForSEO MCP |
| `seo-firecrawl` | Crawl completo del sitio con Firecrawl |
| `seo-backlinks` | Perfil de backlinks y análisis de autoridad |
| `seo-competitor-pages` | Páginas SEO de competidores |
| `seo-hreflang` | SEO internacional y hreflang |
| `seo-image-gen` | Generación de OG images y hero images SEO |
| `ai-seo` | Optimización para motores AI (ChatGPT, Perplexity) |
| `site-architecture` | Planificación de arquitectura de sitio |
| `seo-schema` | Schema.org JSON-LD (generación y validación) |
| `seo-programmatic` | SEO programático — páginas en escala |

---

## Ads — plataformas sin cliente activo (archivados 2026-04-13)
> Restaurar cuando tengas cliente en esa plataforma.

| Skill | Qué hace |
|---|---|
| `ads-tiktok` | Análisis TikTok Ads: creativos, targeting, métricas |
| `ads-apple` | Apple Search Ads (ASA) — App Store |
| `ads-microsoft` | Microsoft/Bing Ads |
| `ads-linkedin` | LinkedIn Ads para B2B |
| `ads-youtube` | YouTube Ads: análisis de campañas video |

---

## Ads — duplicados (archivados 2026-04-13)
> Se mantuvo la versión mejor; estos son el duplicado inferior.

| Skill archivado | Skill que quedó | Razón |
|---|---|---|
| `ads-create` | `ads-creative` | `ads-creative` es más completo y tiene agente alineado |
| `schema-markup` | (agente `seo-schema`) | El agente cubre esta función dentro de `/seo-audit` |
| `programmatic-seo` | `seo-programmatic` | Nomenclatura consistente con set SEO |
| `seo-images` | (nano-banana + `ads-generate`) | Generación de imágenes cubierta por herramientas activas |

---

## Marketing — solapados (archivados 2026-04-13)

| Skill | Solapa con | Qué hace |
|---|---|---|
| `content-strategy` | `marketing-ideas` + `social-content` | Planificación de contenido (más genérico) |
| `copy-editing` | `copywriting` | Edición y revisión de textos |
| `marketing-psychology` | — | Framework teórico de persuasión (no operativo) |
| `product-marketing-context` | — | Contexto interno de product marketing |
