# Git clean filter for .claude/settings.json: drops the hooks and status line
# that Orca writes (they reference ORCA_AGENT_HOOK_* or ~/.orca/agent-hooks),
# so only my own settings are versioned. Orca re-adds them on startup.
def orca: (.command // "") | test("ORCA_AGENT_HOOK_|\\.orca/agent-hooks/");

(if .hooks then
   .hooks |= (map_values(map(.hooks |= map(select(orca | not)))
                         | map(select(.hooks | length > 0)))
              | with_entries(select(.value | length > 0)))
 else . end)
| if .hooks == {} then del(.hooks) else . end
| if (.statusLine // {} | orca) then del(.statusLine) else . end
