---
name: code-review
description: Injected into Atlas/Sisyphus to ensure a high-reasoning final check.
---

# Pre-Completion Hook
Before finalizing any code task:
1. Call `@momus-code-reviewer` to audit the staged changes.
2. If the response contains "REJECT", you must address the feedback immediately.
3. You are only permitted to finish or commit once `@momus-code-reviewer` issues a "PASS".

