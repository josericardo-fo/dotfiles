---
name: bitwarden
description: 'How to read secrets from the user''s Bitwarden vault via the `bw` CLI — session handling, unlock flow, resolving item ids, and pulling passwords safely (stdin only, never printed). Use whenever any task needs a password, token, or credential stored in Bitwarden, regardless of what it is for. Triggers: "pega no Bitwarden", "senha/credencial/token no Bitwarden", "bw unlock", "vault travado/locked", "abre o Bitwarden".'
---

# bitwarden

The one place for **how to read secrets from Bitwarden**. Which item a given task
needs is the consumer's job (e.g. the `remote-gpu-access` skill maps GPU machines
to their items); this skill covers only the mechanics.

> **Never** print, `echo`, `export`, or put a secret in argv or a log. A secret only
> ever travels through **stdin** into the program that consumes it. If you can see
> it, you leaked it.

## Session

The session token is cached in `~/.bw-session`. Always use it non-interactively:

```sh
export BW_SESSION="$(cat ~/.bw-session)"
bw --nointeraction --session "$BW_SESSION" status    # expect {"status":"unlocked"}
```

**Always pass `--nointeraction`.** Without it, a locked vault makes `bw` prompt for
the master password and crash in a non-tty shell (`ERR_USE_AFTER_CLOSE` readline
error) — check `status` first instead of letting a command fail mid-pipe.

If status is `locked` or the session is invalid, the vault must be unlocked with the
master passphrase — **interactive, the user does it**: ask them to run `! bw unlock`
and drop the returned session into `~/.bw-session`. Never request or handle the
master password yourself. Until they do, you are blocked on any Bitwarden-backed
secret — say so and continue with what doesn't need it.

## Resolving an item id

Search by name and filter to id/name only, so no secret ever reaches the output:

```sh
bw --nointeraction --session "$BW_SESSION" list items --search "example" \
  | python3 -c "import sys,json;[print(i['id'], i['name']) for i in json.load(sys.stdin)]"
```

Prefer the item **id** (stable) over the name in scripts and memory notes.

## Reading a secret

Fetch by id and pipe it straight into the consumer — never render it:

```sh
bw --nointeraction --session "$BW_SESSION" get password "$ID" | <program that reads stdin>
```

When the consumer needs a trailing newline (e.g. `sudo -S`), append it inside the
pipe, never via `printf "$(...)"` (that puts the secret in printf's argv, visible
in `ps`):

```sh
{ bw --nointeraction --session "$BW_SESSION" get password "$ID"; echo; } | <consumer>
```

For fields other than the password: `bw get item "$ID"` returns JSON — extract the
one field with `python3`/`jq` and pipe it onward; don't dump the whole item.

If the secret must land in a shell variable (e.g. a curl header), keep it out of
argv history: `TOK="$(bw ... get password "$ID")"`, use `"$TOK"` once, then
`unset TOK`. Never echo it, and never pass it on a remote command line.

## Troubleshooting

- **`bw` returns nothing / "locked"**: session expired → user re-unlocks
  (`! bw unlock`), refresh `~/.bw-session`.
- **readline crash (`ERR_USE_AFTER_CLOSE`)**: you ran `bw` without
  `--nointeraction` against a locked vault — check `bw status` first.
- **Stale data after edits in the app**: `bw sync` refreshes the local cache.
