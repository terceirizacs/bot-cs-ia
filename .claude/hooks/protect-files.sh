#!/bin/bash
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

ask() {
  jq -n --arg reason "$1" '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "ask",
      "permissionDecisionReason": $reason
    }
  }'
  exit 0
}

# Bash: confirmar mv/rm/rmdir
if [ "$TOOL" = "Bash" ]; then
  if echo "$COMMAND" | grep -qE '\b(mv|rm|rmdir)\b'; then
    ask "Requer confirmacao: mover/deletar requer aprovacao explicita do Tiago."
  fi
fi

# Write/Edit: proteger arquivos criticos da base de conhecimento
if [ "$TOOL" = "Write" ] || [ "$TOOL" = "Edit" ]; then
  case "$FILE_PATH" in
    */.claude/settings.json|*/.claude/hooks/protect-files.sh)
      ask "Requer confirmacao: arquivo de isolamento do Claude Code. Alterar deny rules/hooks requer aprovacao."
      ;;
    */CLAUDE.md|*/AGENTS.md|*/INSTRUCOES-DO-PROJETO.md)
      ask "Requer confirmacao: instrucoes do projeto/base de conhecimento. Alterar requer aprovacao."
      ;;
  esac
fi

exit 0
