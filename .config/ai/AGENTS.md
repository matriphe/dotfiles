# AI Agent Guidelines

When an AI agent writes or commits changes in this repository:

- Prefix every Git commit subject with `AI:`.
- Identify the model used in the commit message body.
- Add the AI agent as a co-author using a `Co-authored-by:` trailer.
- Clearly identify that the changes were written and committed by AI.

Example commit message:

```text
AI: update configuration documentation

Model used: gpt-5 (default)

Written and committed by AI.
Co-authored-by: Codex <noreply@openai.com>
```
