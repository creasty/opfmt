# opfmt

Format operators and delimiters as you type, using tree-sitter.

## Motivation

TBA.

```typescript
// Without opfmt:
foo+=123*fn('abc',{ bar:[4,5] });

// With opfmt:
foo += 123 * fn('abc', { bar: [4, 5] });
```

## Quick start

```lua
require('nvim-treesitter.configs').setup {
  opfmt = {
    enable = true,
  },
}
```

## Supported languages

- ecma
  - javascript
  - jsx
  - typescript
  - tsx
- lua
- toml
- vim
