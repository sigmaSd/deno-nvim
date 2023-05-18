# deno-nvim

A plugin to improve deno experience

## Installation

using `packer.nvim`

```lua
use 'neovim/nvim-lspconfig'
use 'sigmasd/deno-nvim'

-- Debugging
use 'mfussenegger/nvim-dap'
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
  -- if you're using dap to debug (see the README for more info)
  dap = {
    adapter = ...
  }
})
```

## Local settings

To use local settings for each project, checkout
https://github.com/folke/neoconf.nvim which can even parse
`.vscode/settings.json`

The default settings are located here
https://github.com/denoland/vscode_deno/blob/main/package.json

Its also recomended to install jsonls with lspconfig to get autocompletion
inside the settings

## Usage

<details>
  <summary>
	<b>deno test with code lens</b>
  </summary>

<p>use <i>vim.lsp.codelens</i> to activate this </p>
<p>
Example of keybindings:

```lua
vim.keymap.set("n", "<space>dr", function()
    vim.lsp.codelens.refresh();
    vim.lsp.codelens.run()
end, opts)
```
</p>
  <img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/test.gif"/>
</details>

<details>
  <summary>
	<b>dap support</b>
  </summary>
  <p>
Support debugging with https://github.com/mfussenegger/nvim-dap

Follow the instruction here https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-deno to download and extract dapDebugServer.

Then you will need to set `dap.adapter.executable.args`  to `{dapDebugServerPath, "${port}"}` when using `deno.nvim.setup`. (don't change `"${port}"` its not a place holder)

Example:

```lua
    require("deno-nvim").setup {
      dap = {
        adapter = {
          executable = {
            args = {
              "/absolute-path/to/js-debug/src/dapDebugServer.js", "${port}"
            }
          }
        }
      }
    }
```
  </p>
  <img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/dap.gif"/>
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

Inlay hints are supported in deno from version 1.27.0, to use it install
https://github.com/lvimuser/lsp-inlayhints.nvim

You can set it locally by using neoconf with these settings
https://github.com/denoland/vscode_deno/blob/main/package.json#L245

You can set it globally by adding this to your init.lua where you instantiate
denols server:

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

<details>
  <summary>
	<b>Custom useful commands</b>
  </summary>
  <p>This part is WIP, currently I'm adding some commands that I personaly find useful. 
  Feel free to open an issue or PR to improve this part. Usage `:Deno custom_command` (press Tab for completion)</p>
  <i>Check/Update dependencies</i>
  <img src="https://github.com/sigmaSd/nvim-deno-demos/raw/master/update_check_deps.gif"/>
</details>

The list of available user commands is here
https://github.com/sigmaSd/deno-nvim/blob/master/lua/deno-nvim/lsp.lua#L52

## Important

For the lsp to function 100% correctly you need atleast:

- nvim 0.8.0
- deno 1.26.1

## More stuff

You can checkout https://github.com/sigmaSd/conjure-deno for deno repl
integration in nvim

## Credits

Thanks to https://github.com/simrat39/rust-tools.nvim for the nice readable and
commented codebase.
