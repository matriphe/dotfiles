# AI Agent Guidelines

This is the canonical guidance for AI agents working in this repository and its supported integrations. Agent-specific entrypoints refer to this file so all integrations use the same rules.

## Working on the Git repository

- Read the relevant repository guidance before making changes.
- Create a branch for feature or documentation work; keep the default branch stable.
- Follow the existing project style and the official conventions for the relevant framework or language.
- Never commit secrets, credentials, or API keys. Use environment variables for sensitive data, and warn before exposing credentials.
- Run appropriate tests and verification checks before claiming that work is complete.

## Git workflow

- Agents may create branches, commits, and pushes as part of an explicitly requested workflow.
- Ask for confirmation before destructive operations such as deleting files or branches, dropping databases or tables, force-pushing, or otherwise making data difficult to recover.
- Preserve unrelated working-tree changes.

### Commit messages

When an AI agent writes or commits changes in this repository, it MUST:

- Prefix every Git commit subject with `AI:`.
- Identify the model used in the commit message body.
- Include effort information when available.
- Clearly identify that the changes were written with the help of and committed by AI.
- Add the AI agent as a co-author using a `Co-authored-by:` trailer.

Generic template:

```text
AI: <imperative change summary>

Written with the help of and committed by AI using model <model-id> (<effort, if available>).
Co-authored-by: <agent-name> <agent-email>
```

For example, a Codex commit may use:

```text
AI: update configuration documentation

Written with the help of and committed by AI using model gpt-5.6-luna (low).
Co-authored-by: Codex <noreply@openai.com>
```

The co-author name and email MUST match the AI agent that performed the work.

### Pull requests and merge requests

When an AI agent creates or updates a pull request or merge request, it MUST:

- Use a short, descriptive title.
- Explain the changes, motivation, and linked issue when one exists.
- Identify the AI agent and model in the description footer.
- Include effort information when available.

Generic footer format:

```markdown
🤖 Generated with the help of [<agent-name>](<agent-link>) using model <model-id> (<effort, if available>).
```

For example, a Codex footer may use:

```markdown
🤖 Generated with the help of [Codex](https://openai.com/codex/) using model gpt-5.6-luna (low).
```

The agent name, link, model, and effort MUST match the agent and configuration used for the pull request.

## Quality and style

- Prefer readable, maintainable changes over terseness.
- JavaScript and TypeScript SHOULD follow the existing ESLint/Prettier configuration and modern ES conventions.
- Python SHOULD follow PEP 8 and the project's formatter configuration.
- PHP SHOULD follow PSR-12.
- Go SHOULD follow official formatting and idioms.

### Code comments

- Comments MUST be short and concise.
- Comments MUST explain why the code exists, not what it does.
- Comments SHOULD document only non-obvious rationale, constraints, workarounds, side effects, or invariants.
- Prefer self-documenting code through clear names and simple structure.
- Improve the code instead of adding comments that merely narrate it.
- Remove or update comments that become obsolete.
- Avoid comments that restate the implementation, describe obvious operations, or add unnecessary noise.

## Supported integrations

The agent-specific configuration files in this repository are intentionally small and reference this file as their shared source of truth. Keep repository-wide agent behavior here instead of duplicating it across integrations.
