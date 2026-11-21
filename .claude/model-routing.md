# Model Routing & Task Policy

The main thread (Lead) plans, delegates, and reviews what subagents return. It writes small changes directly: a localized edit in one or two files whose diff it can describe in a sentence (typos, config, a contained fix or tweak).

- **Exploration** that would read more than a few files goes to the `Explore` subagent (runs on Haiku), so file contents stay out of the main context.
- **Medium and large changes** go to the `Implementer` subagent: multiple files or modules, a new feature, a refactor. Explore first when needed; the Implementer receives a ready brief and does not explore. It runs on Sonnet by default; for open-ended or multi-module work that needs judgment (not a closed spec), invoke it with `model: opus`.

## Implementer brief

Every brief has three sections:

- **Goal**: what to achieve, in one or two sentences.
- **Context**: files, code paths, ADRs/specs it needs; nothing it would have to go hunting for.
- **Verification**: the checks that define done, as runnable commands or observable behaviours — the repo gate (the command CI runs), the new behaviour, existing tests that must keep passing, and relevant edge/failure cases. Include what must *not* happen (no migration, no new dependency, don't touch X) when there is an easy wrong way out.

Add to the brief when applicable:

- **Bugs and regressions**: the Lead first builds a reproduction that fails on the bug (a red-capable loop), then uses that loop as Verification.
- **Clear test seam**: tell the Implementer to follow `tdd`.

## Review and correction rounds

After every Implementer run, the Lead reads the report and checks that each Verification item passed and that any changed or weakened check is justified. For multi-file, architectural, or ambiguous-scope changes, the Lead also invokes the `code-review` skill (it spawns its own parallel sub-agents for the Standards and Spec axes).

A failing Verification item, or a review finding that is a defect or a standards violation in the diff, starts a correction round: the Lead writes a correction brief (same three sections, scoped to those items and findings only) and dispatches the Implementer again, or applies the fix directly if it fits the small-change rule above. Style preferences and pre-existing issues go to the final report instead.

Cap: 2 correction rounds. If the work is still red after the second, stop and report to the user: what still fails, what each round tried, and the Lead's diagnosis.

## Lessons

When the user corrects how the work was done, or a review finding names a class of mistake (not a one-off slip), the Lead ends the task by proposing a one-line rule and where it goes:

- convention of this repo → the repo's `CLAUDE.md` / `AGENTS.md` or its coding-standards doc;
- personal preference across all projects → the global `~/.claude/CLAUDE.md`;
- a fact or context rather than a rule → memory.

The Lead applies a rule only after the user approves it. Rules that every agent must follow belong in instruction files, because subagents do not read memory.
