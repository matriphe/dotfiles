# AI Agent Guidelines

This is the canonical AI agent guidance for this repository and its supported agent integrations. Agent-specific entrypoints refer to this file so all supported agents use the same rules.

## Working in this repository

- Read the relevant repository guidance before making changes.
- Create a branch for feature or documentation work; keep the default branch stable.
- Follow the existing project style and use the framework or language's official conventions where applicable.
- Never commit secrets, credentials, or API keys. Use environment variables for sensitive data and warn before exposing credentials.
- Run appropriate tests and verification checks before claiming work is complete.

## Git workflow

- Agents may create branches, commits, and pushes as part of an explicitly requested workflow.
- Ask for confirmation before destructive operations such as deleting files or branches, dropping databases or tables, force-pushing, or otherwise making data difficult to recover.
- Preserve unrelated working-tree changes.

### Commit messages

When an AI agent writes or commits changes in this repository:

- Prefix every Git commit subject with `AI:`.
- Identify the model used in the commit message body.
- Add the effort information if available.
- Clearly identify that the changes were written with the help of and committed by AI.
- Add the AI agent as a co-author using a `Co-authored-by:` trailer.

Example:

```text
AI: update configuration documentation

Written with the help of and committed by AI using model gpt-5.6-luna (low).
Co-authored-by: Codex <noreply@openai.com>
```

### Pull requests and merge requests

When an AI agent creates or updates a pull request or merge request:

- Use a short, descriptive title.
- Explain the changes, motivation, and linked issue when one exists.
- Identify the AI agent and model in the description footer.

Use this footer format:

```markdown
🤖 Generated with the help of [Codex](https://openai.com/codex/) using model <model-id>.
```

## Quality and style

- Prefer readable, maintainable changes over terseness.
- Comments should explain why, not what.
- JavaScript and TypeScript should follow the existing ESLint/Prettier configuration and modern ES conventions.
- Python should follow PEP 8 and the project's formatter configuration.
- PHP should follow PSR-12.
- Go should follow the official formatting and idioms.

## Supported integrations

The agent-specific configuration files in this repository are intentionally small and reference this file as their shared source of truth. Keep repository-wide agent behavior here rather than duplicating it across integrations.
