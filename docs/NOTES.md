# Praktické poznámky

- `main` agent je pro komunikaci a plánování.
- `dev` agent má coding profil a používá helper skripty.
- OpenCode helpery používají `--attach`, takže se připojují na běžící `opencode serve`.
- Když OpenCode neběží, staged helper script selže bezpečně a nic nepropíše do live `/data`.
- Browser je oddělený sidecar kvůli čistší topologii a snazším restartům.
