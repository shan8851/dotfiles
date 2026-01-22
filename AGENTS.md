# AGENTS.md

## Start
- Say hi + 1 motivating line.
- Then: telegraph mode. Noun phrases OK. Min tokens.

## Scope
- Applies when coding/editing repos.
- If repo has its own `AGENTS.md`, follow closest-in-tree.

## Safety Defaults (Ask First)
- Ask before: new branch, commit, push, rebase, force-push.
- Ask before destructive ops: `reset --hard`, `clean`, delete/rename files.
- Ask before adding/upgrading dependencies.
- No repo-wide search/replace scripts. Small, reviewable edits.
- Unrecognized changes: assume other agent; continue carefully; if risky, stop + ask.

## Critical Thinking
- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask with short options.
- Conflicts: call out; pick safer path.
- Leave breadcrumb notes in-thread (what changed, why, next step).

## TypeScript (Hard Rules)
- `strict: true` (don’t weaken types to “make it pass”).
- Never use `any`.
- Prefer `unknown` + type guards when uncertain.
- Prefer `const` over `let`. `let` only when reassignment truly necessary.
- Prefer `??` over `||` for defaults.
- Use optional chaining (`?.`) where it clarifies.

## Exports
- Prefer named exports.
- Default exports allowed only when required by framework/tools or existing repo convention.

## Style & Architecture
- Prefer functional style: pure functions, immutability.
- Prefer `map` / `filter` / `reduce` over imperative loops when it improves clarity.
- Prefer self-documenting code (good names) over comments.
- Classes allowed when they’re clearly the best tool, but default to functional patterns.
- Comments allowed; keep minimal; focus on “why” or tricky logic. Avoid noise.

## Avoid
- Magic numbers: avoid; use named constants (include meaning/units). Obvious literals OK (`0/1` indexing, empty string checks, etc).
- Magic strings: prefer constants unless truly local and obvious.
- `console.log` in committed code (remove or use proper logging).
- Direct object/array mutation when reasonable alternatives exist.

## Imports
Order, alphabetized within groups:
1. External packages
2. Internal modules
3. Types

## File Naming
- Prefer `camelCase` filenames (`userProfile.tsx`, `apiUtils.ts`).
- If repo uses another convention, follow repo pattern.

## Testing Philosophy
- High-value tests over coverage vanity.
- Prefer integration + E2E tests; test real user flows.
- Avoid mocks almost always; only mock at hard boundaries (true external services) and keep minimal.
- Avoid brittle tests coupled to implementation details.
- Unit tests: high-value pure logic / edge cases only.

## Validation / “Done”
- Prefer repo package manager; if ambiguous, prefer `pnpm`.
- After changes, run what exists:
  - Tests (`pnpm test` or repo equivalent)
  - Typecheck (`pnpm tsc --noEmit` or repo equivalent)
  - Lint/format (eslint/prettier scripts)
- If repo has no tests: ask Shan to verify behavior before moving on.

## Git
- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `ci:`
- Big review command: `git --no-pager diff --color=never`
