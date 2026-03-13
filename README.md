# OpenClaw + OpenCode split-stack for Coolify (Telegram + default autonomy)

Tento balíček je připravený pro nasazení jako **Docker Compose build pack** v Coolify.

Obsahuje:
- `openclaw` službu s bootstrapem workspaces a approval-first helper skripty
- `opencode` službu s bootstrapem OpenCode configu, agentů a commands
- `browser` sidecar pro vzdálené CDP přes `BROWSER_CDP_URL`
- sdílené persistentní `/data`
- `main` agenta pro komunikaci a plánování
- `dev` agenta, který připravuje staged změny přes OpenCode
- approval-first workflow: staged task → review → explicitní schválení → apply
- volitelné zapnutí Telegramu přes `TELEGRAM_BOT_TOKEN`
- default cron/heartbeat autonomii pro planning, reminders a weekly safe improvement review

Začni v `docs/README.md`.
