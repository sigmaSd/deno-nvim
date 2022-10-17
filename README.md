# deno-nvim

A plugin to improve deno experience

## Installation

using `packer.nvim`

```lua
use 'neovim/nvim-lspconfig'
use 'sigmasd/deno-nvim'
```

## Setup

This plugin automatically sets up nvim-lspconfig for deno for you, so don't do
that manually, as it causes conflicts.

Put this in your init.lua or any lua file that is sourced.<br>

Example config:

```lua
require("deno-nvim").setup({
  server = {
    on_attach = ...,
    capabilites = ...
  },
})
```

## Usage

<details>
  <summary>
	<b>deno test with code lens</b>
  </summary>

<p>use <i>vim.lsp.codelens</i> to activate this </p>
  <img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/test.gif"/>
</details>

<details>
  <summary>
	<b>auto complete import from deno registeries</b>
  </summary>
  <img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/auto_import.gif"/>
</details>

<details>
  <summary>
	<b>deno task</b>
  </summary>
  <img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/task.gif"/>
</details>

<details>
  <summary>
    <b>Inlay Hints</b>
  </summary>
<img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/inlay_hints.png"/>
  
Inlay hints are supported in deno from version 1.26.3 (not released yet), to use it install https://github.com/lvimuser/lsp-inlayhints.nvim and add this to your init.lua where you instantiate denols server:

```lua
require "deno-nvim".setup({
    server = {
        on_attach = ...,
        capabilities = ...,
        settings = {
            deno = {
                inlayHints = {
                    parameterNames = {
                        enabled = "all"
                    },
                    parameterTypes = {
                        enabled = true
                    },
                    variableTypes = {
                        enabled = true
                    },
                    propertyDeclarationTypes = {
                        enabled = true
                    },
                    functionLikeReturnTypes = {
                        enabled = true
                    },
                    enumMemberValues = {
                        enabled = true
                    },
                }

            }
        }
    }
})
```

Now you should be able to show the hints with
`require('lsp-inlayhints').toggle()`

</details>

The list of available user commands is here
https://github.com/sigmaSd/deno-nvim/blob/master/lua/deno-nvim/lsp.lua#L52

## Important

For the lsp to function 100% correctly you need:

- nvim 0.8.0
- deno 1.26.1

## More stuff

You can checkout https://github.com/sigmaSd/conjure-deno for deno repl
integration in nvim

## Credits

Thanks to https://github.com/simrat39/rust-tools.nvim for the nice readable and
commented codebase.
