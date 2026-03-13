# Approval policy

## Staged změny
Staged změna je návrh připravený mimo live `/data`.
Je uložený v `/data/approvals/tasks/<TASK_ID>/`.

## Live změny
Live změna je až aplikace staged tasku zpět do `/data`.

## Bez schválení nesmíš
- přepisovat `openclaw.json`
- přepisovat workspaces
- přepisovat helper skripty
- měnit OpenCode config
- spouštět deploy / restart jako hotový krok

## Po schválení smíš
- zavolat helper script `apply-approved-task.sh <TASK_ID> --approved`
- stručně shrnout, co se právě propsalo
- upozornit na post-deploy / post-reload kontrolu
