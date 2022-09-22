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

Install [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

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
- proto

## Todo

- Describe motivation
  - Make a simple movie
  - Write down goals and non-goals
  - Comparison with other formatters?
- Features
  - Merge two consecutive operators if applicable
  - Add negative modifier
- Bugfixes
  - Fix a bug regarding match_case node in vim
