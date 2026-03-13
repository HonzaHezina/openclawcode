# Telegram + autonomie

## Co je nově doplněné
- automatické vyrenderování `/data/openclaw.json` při prvním startu
- volitelné zapnutí Telegramu přes `TELEGRAM_BOT_TOKEN`
- automatický bind `telegram -> main` po startu
- defaultní cron joby pro planning, reminder, weekly review a nightly recap
- helper skripty pro pairing a kontrolu

## Telegram režimy
### Varianta A — pairing (nejjednodušší)
Nastav jen `TELEGRAM_BOT_TOKEN`.

Po deploy:
1. napiš botovi do DM
2. v kontejneru `openclaw` spusť:
```bash
/data/system/scripts/telegram-pairing-status.sh
```
3. schval kód:
```bash
/data/system/scripts/approve-telegram-pairing.sh <CODE>
```

### Varianta B — owner allowlist (pohodlnější)
Nastav:
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_OWNER_ID`

Pak se DM přístup povolí rovnou přes allowlist.

## Výchozí cron joby
Pokud je `OPENCLAW_ENABLE_DEFAULT_AUTONOMY=true`, nainstalují se tyto joby:
- 08:00 každý den — morning planning check
- 13:00 v pracovní dny — approval reminder
- 09:30 každé pondělí — weekly autonomy review
- 20:30 každý den — nightly ops recap

Časové pásmo řídí `OPENCLAW_AUTONOMY_TIMEZONE`.
Výchozí hodnota v balíčku je `Europe/Prague`.

## Důležité omezení
- cron joby neprovádí live apply
- weekly review smí vytvořit jen jeden staged task
- heartbeat a cron dávají smysl až po první reálné konverzaci, protože `target: last` posílá shrnutí do posledního aktivního chatu
