# Brainstorm: compound-engineering-workflow

## Prompt
Run the compound-engineering workflow as defined in:
`/home/tktr/.config/dotfiles/Configs/opencode/.config/opencode/commands/workflows/run.md`

## Goal
Initialize workflow artifacts in this repository so `/workflows/run <topic>` can resume from a status file.

## Scope
- Create plan-phase workflow docs for this topic.
- Do not fabricate implementation/review results.
- Stop at implementation phase per `run.md` when no prior status exists.

## Risks
- Topic slug was inferred from the request text.
- Memory command APIs in workflow docs are not available in this environment.
