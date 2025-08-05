# Clutterstack

A Phoenix-based blog system that generates content from Markdown files.

## Writing Content

Create Markdown files in:
- `markdown/posts/` - Main blog articles
- `markdown/particles/` - Shorter content, lower bar, organised by theme

### Frontmatter & SEO

Add keywords to your frontmatter for automatic SEO optimization:

```yaml
---
title: My Blog Post
date: 2025-01-01
keywords:
  - elixir
  - phoenix
  - web development
---
```

This automatically generates:
- Meta descriptions from post content
- Open Graph tags for social sharing
- Twitter Card metadata
- Canonical URLs
- Semantic article tags for search engines

## Development

- `mix build_pages` - Rebuild content from Markdown files
- `mix build_sitemap` - Generate XML sitemaps
- File changes are automatically detected and reloaded