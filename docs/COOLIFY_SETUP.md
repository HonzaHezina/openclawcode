# Nasazení v Coolify

## 1. Vytvoř aplikaci
- Build Pack: **Docker Compose**
- Repo: nahraj nebo pushni obsah tohoto balíčku do Git repa
- Compose file: `docker-compose.coolify.yml`

## 2. Nastav environment variables
Minimálně:
- `OPENCLAW_GATEWAY_TOKEN`
- `OPENCLAW_MODEL_PRIMARY`
- `OPENCODE_MODEL`
- `OPENCODE_SERVER_PASSWORD`

A provider key minimálně pro model, který skutečně použiješ:
- `OPENAI_API_KEY` nebo
- `ANTHROPIC_API_KEY` nebo
- `OPENROUTER_API_KEY` nebo další

Pro Telegram:
- `TELEGRAM_BOT_TOKEN`
- volitelně `TELEGRAM_OWNER_ID`

Pro autonomii:
- `OPENCLAW_ENABLE_DEFAULT_AUTONOMY=true`
- `OPENCLAW_AUTONOMY_TIMEZONE=Europe/Prague`

Volitelně:
- `SERVICE_FQDN_OPENCLAW_18789`
- `SERVICE_FQDN_OPENCODE_4096`

## 3. Persistent storage
V tomto compose je perzistence už definovaná přes named volumes.
Klíčová je hlavně:
- `openclaw-data` → sdílené `/data`

## 4. Deploy
Po deploy:
- OpenClaw vyrenderuje `/data/openclaw.json`
- OpenClaw bootstrapne workspaces a helper skripty
- OpenCode bootstrapne `/data/opencode/`
- post-deploy init zkusí bindnout Telegram a nainstalovat default cron joby

## 5. Kontrola zdraví
- OpenClaw: `/healthz`
- OpenCode: `/global/health`

## 6. První ověření
Po prvním startu zkontroluj v logs:
- že `openclaw config validate` prošel
- že OpenCode je reachable
- že OpenClaw běží na portu `18789`
- že `post-deploy-init.log` nehlásí chyby
