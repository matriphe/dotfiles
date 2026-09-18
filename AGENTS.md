# AI Agent Guidelines

This is the canonical AI agent guidance for all AI agents. Agent-specific entrypoints refer to this file so all supported agents use the same rules.

## Git Commit

When an AI agent writes or commits changes in this repository:

- Prefix every Git commit subject with `AI:`.
- Identify the model used in the commit message body.
- Add the AI agent as a co-author using a `Co-authored-by:` trailer.
- Clearly identify that the changes were written with the help of and committed by AI.

Example commit message:

```text
AI: update configuration documentation

Written with the help of and committed by AI using model gpt-5.6-luna.
Co-authored-by: Codex <noreply@openai.com>
```

## Pull Requests and Merge Requests

When an AI agent creates or updates a pull request or merge request, always identify the AI usage in the footer of the description.

Use this format:

```text
🤖 Generated with the help of <AI agent name and link> using model <model-id>.
```

Example:

```text
🤖 Generated with the help of [Codex](https://openai.com/codex/) using model gpt-5.6-luna.
```
