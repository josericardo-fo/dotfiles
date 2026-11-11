# Model Routing & Task Policy

The main thread (Lead) plans, delegates, and reviews what subagents return. It writes small changes directly: a localized edit in one or two files whose diff it can describe in a sentence (typos, config, a contained fix or tweak).

- **Exploration** that would read more than a few files goes to the `Explore` subagent (runs on Haiku), so file contents stay out of the main context.
- **Medium and large changes** go to the `Implementer` subagent: multiple files or modules, a new feature, a refactor. Explore first when needed; the Implementer receives a ready brief and does not explore.

## Implementer brief

Every brief has three sections:

- **Goal**: what to achieve, in one or two sentences.
- **Context**: files, code paths, ADRs/specs it needs; nothing it would have to go hunting for.
- **Verification**: the checks that define done, as runnable commands or observable behaviours — the repo gate (the command CI runs), the new behaviour, existing tests that must keep passing, and relevant edge/failure cases. Include what must *not* happen (no migration, no new dependency, don't touch X) when there is an easy wrong way out.

Add to the brief when applicable:

- **Bugs and regressions**: the Lead runs `diagnosing-bugs` until it has a red-capable loop, then uses that loop as Verification.
- **Clear test seam**: tell the Implementer to follow `tdd`.

## Multi-file, architectural, or ambiguous-scope changes

- **After implementing**: the Lead invokes the `code-review` skill directly (it spawns its own parallel sub-agents for the Standards and Spec axes).
