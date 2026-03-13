# Provozní příkazy

## Vypsat staged tasky
```bash
/data/system/scripts/list-tasks.sh
```

## Připravit zlepšení stacku
```bash
/data/system/scripts/improve-openclaw.sh "Přidej nového read-only analytického agenta"
```

## Připravit nového agenta
```bash
/data/system/scripts/scaffold-openclaw-agent.sh support "Agent pro support, čte docs a odpovídá bez exec"
```

## Aplikovat schválený task
```bash
/data/system/scripts/apply-approved-task.sh <TASK_ID> --approved
```

## Telegram pairing stav
```bash
/data/system/scripts/telegram-pairing-status.sh
```

## Schválit Telegram pairing kód
```bash
/data/system/scripts/approve-telegram-pairing.sh <CODE>
```

## Ručně doinstalovat default autonomii
```bash
/data/system/scripts/install-default-autonomy.sh
```

## Ručně zkusit Telegram init
```bash
/data/system/scripts/setup-telegram.sh
```

## Co po apply
- OpenClaw si config změny většinou načte automaticky
- změny `gateway.*` typicky vyžadují restart gateway
- po větší změně zkontroluj logs a health endpointy
