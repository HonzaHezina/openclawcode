# OpenCode bridge

Používej helper skripty v `/data/system/scripts`.

## Hlavní skripty
- `improve-openclaw.sh "<zadání>"`
- `scaffold-openclaw-agent.sh <agent_id> "<zadání>"`
- `list-tasks.sh`
- `apply-approved-task.sh <TASK_ID> --approved`

## Jak fungují
- vytvoří staged task v `/data/approvals/tasks/<TASK_ID>/`
- zkopírují relevantní live soubory do `baseline/` a `candidate/`
- spustí OpenCode proti `candidate/`
- vytvoří diff a reporty

## Důležité
- pro nové změny vždy používej staged task
- pro live propsání používej `apply-approved-task.sh` až po explicitním schválení uživatele
- když helper script selže, vrať uživateli chybu a další krok, nezkoušej tichý riskantní zásah
