# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- `mix setup` - Install dependencies and set up the project
- `mix phx.server` - Start the Phoenix server (dev mode)
- `iex -S mix phx.server` - Start server with IEx REPL
- `mix test` - Run all tests
- `mix build_pages` - Build markdown content and populate database
- `mix build_sitemap` - Generate sitemap files
- `mix assets.build` - Build CSS/JS assets (Tailwind + esbuild)
- `mix assets.deploy` - Build minified assets for production

## Core Architecture

### Blog Content System
- **NimblePublisher**: Uses custom parser/converter to transform markdown files from `./markdown/**/*.md*` into blog entries
- **Content Types**: 
  - Posts (`markdown/posts/`) - Main blog articles
  - Particles (`markdown/particles/`) - Shorter content organized by theme
  - Scribbles (`markdown/scribbles/`) - Draft content
- **Database Storage**: Parsed markdown is stored in SQLite via Ecto for fast serving
- **Asset Pipeline**: Images from markdown are automatically copied to `priv/static/images/`

### Live Content Updates
- **MarkdownWatcher**: FileSystem-based GenServer that monitors markdown directory
- **Hot Reloading**: Changes to markdown files trigger automatic recompilation and database updates
- **Feed Generation**: Atom feed and sitemap regeneration on content changes

### Custom Publishing Pipeline
- **Clutterstack.Publish**: NimblePublisher module with custom parser and HTML converter
- **Entry Processing**: Handles metadata extraction, redirect mapping, and content transformation
- **Redirect System**: Database-backed redirects from old paths to new paths via `redirect_from` frontmatter

### Key Files
- `lib/clutterstack.ex` - Main content processing and database population
- `lib/clutterstack/publish.ex` - NimblePublisher configuration
- `lib/clutterstack/markdown_watcher.ex` - Live reload system
- `lib/clutterstack/entries.ex` - Database context for blog entries

### Phoenix Web Structure
- **Custom Routes**: Dynamic routing for posts and particles with theme organization
- **SQLite Database**: Ecto with SQLite3 adapter for content storage
- **Static Assets**: Tailwind CSS + esbuild for JS bundling
- **Development Tools**: LiveDashboard available at `/dev/dashboard` in dev mode

### Special Dependencies
- Uses forked Earmark markdown processor from clutterstack/earmark
- Makeup syntax highlighting for Elixir/Erlang/EEx
- Sitemapper for XML sitemap generation
- File watcher system for development workflow

## Content Development Workflow
1. Write markdown in appropriate `markdown/` subdirectory
2. MarkdownWatcher automatically detects changes
3. Content is parsed, processed, and stored in database
4. Atom feed and sitemap are regenerated
5. Phoenix LiveReload refreshes browser