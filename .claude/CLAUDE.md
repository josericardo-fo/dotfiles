# Coding Philosophy

Task routing lives in @model-routing.md — what the Lead does vs. the Implementer, how briefs are written, when to plan and review. The sections below are about how code itself should be written.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly.
- Diagnose the root cause before fixing. If the requested fix only treats a symptom, say so and present the root-cause fix alongside, with its extra cost.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

Keep code well-organized and reusable. Before writing something new, check whether an existing function/module already solves it. Don't duplicate; reuse.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

Surgical doesn't mean palliative (see §1 on root causes), but never silently expand scope to "fix it properly" — propose, then wait.

## 4. Language

- Talk to me in Brazilian Portuguese.
- Code identifiers, test names, branch names, log messages: English.
- User-facing text (UI, end-user errors): the product's language / i18n files.
- Comments, docstrings, docs (incl. ADRs/specs), commits, PRs: follow the repo's existing convention; in a new repo, default to Brazilian Portuguese. Commit type prefixes (`feat:`, `fix:`) stay in English.
- Agent instruction files (CLAUDE.md, AGENTS.md, skills, subagent definitions and briefs): English, in my setup and in repos.
- Memories: Brazilian Portuguese.
