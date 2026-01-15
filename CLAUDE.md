# Coding Preferences

## Core Principles
- Functional programming style - prefer pure functions, immutability
- `const` over `let` - only use `let` when reassignment is truly necessary
- Use `map`, `filter`, `reduce` over imperative loops
- Self-documenting code - descriptive names over comments
- Longer descriptive variable/function names over terse abbreviations

## TypeScript
- Strict mode always (`strict: true`)
- Never use `any` - use `unknown` with type guards if type is uncertain
- Prefer nullish coalescing (`??`) over logical OR (`||`)
- Use optional chaining (`?.`) where appropriate
- Named exports only - no default exports
- Explicit return types on exported functions

## Code Style
- Arrow functions for React components: `const Component = () => {}`
- `async/await` over `.then()` chains
- Early returns for guard clauses within try/catch blocks
- No classes - functional patterns only
- No direct mutations - spread operators, `map`, `filter` for updates

## Imports
Organize imports in this order, alphabetized within each group:
1. External packages
2. Internal modules
3. Types

## File Naming
- camelCase for all files: `userProfile.tsx`, `apiUtils.ts`

## Comments
- Minimal comments - code should be self-explanatory
- Only comment complex business logic or non-obvious "why"
- No JSDoc unless it's a public library API

## React / Next.js
- Prefer Next.js App Router patterns
- Start with React hooks (`useState`, `useReducer`)
- Use React Query (TanStack Query) for server state
- Context for simple shared state, avoid prop drilling
- No Redux

## Styling
- Tailwind CSS for styling
- shadcn/ui components for personal projects
- Lucide icons

## Frontend Aesthetics
Avoid generic "AI slop" aesthetics. Create distinctive, creative frontends that surprise and delight.

**Typography:** Choose beautiful, unique fonts. Avoid generic fonts (Arial, Inter, Roboto, system fonts). Opt for distinctive choices that elevate the design.

**Color & Theme:** Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. Draw inspiration from IDE themes and cultural aesthetics.

**Motion:** Use animations for effects and micro-interactions. Prioritize CSS-only solutions. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (`animation-delay`) creates more delight than scattered micro-interactions.

**Backgrounds:** Create atmosphere and depth - don't default to solid colors. Layer CSS gradients, use geometric patterns, or add contextual effects matching the overall aesthetic.

**Avoid these clichés:**
- Overused font families (Inter, Roboto, Arial, Space Grotesk)
- Purple gradients on white backgrounds
- Predictable layouts and cookie-cutter component patterns
- Designs that lack context-specific character

Interpret creatively. Make unexpected choices. Vary between light/dark themes, different fonts, different aesthetics per project.

## Validation
- Use zod for schema validation and type inference

## Web3 (wagmi/viem)
- Always use typed ABIs for contract interactions
- User-friendly error messages for transaction failures
- Handle wallet connection states explicitly

## Avoid
- Classes and OOP patterns
- Magic strings - use constants or enums
- `console.log` in committed code - use proper logging or remove
- Default exports
- `any` type
- Direct object/array mutations

## Git
- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`

## Proactive Checks
After writing code, run:
1. Tests (`npm test` or `bun test`)
2. Type check (`tsc --noEmit`)
3. Lint (`npm run lint` or fix with `npm run lint:fix`)
