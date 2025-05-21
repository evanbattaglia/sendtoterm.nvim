# Sendtoterm.nvim

## Overview

Sendtoterm is a neovim plugin that allows you to:
* send text from a buffer to a terminal (or terminals)
* easily set up an autorun command to send a specific string to a terminal (or
  terminals) when a file is saved

A terminal can be:
* a neovim terminal
* the previous or next Zellij pane

Example usages:
* incrementally writing or modifying a script, and testing it by sending
  contents to a REPL (irb, ipython, node, etc.)
* Jupyter-style workbooks -- send \`\`\` blocks to a repl
* running commands on multiple terminals (e.g. locally + remote SSH server)

## Usage
1. Open neovim
2. Open a terminal, either:
  a. a terminal within neovim, and run :SendtotermSet or :SendtotermAdd (add
     can add multiple times, so you can send text to multiple at a time)
  b. OR, open another terminal panel in Zellij, and run :SendtotermZNext or
    :SendtotermZPrev in vim, depending on whether the terminal is after of
    before the pane with neovim.
3. In a neovim buffer, add some shell commands like "echo hello" and "ls". You
   can send text to the terminal in several ways:
  a. run :Sendtoterm while on the line with the shell command
  b. select text in visual mode and run :Sendtoterm to send the selected lines
  c. run :%Sendtoterm to send the whole buffer to the terminal
  d. it can be useful to set up a macro or shortcut key to send text in-between
     lines of triple backquotes. I use the following in which-key to make
     `<Leader>T` make a mark "t", selects the lines in between triple
     backquotes, send the lines, and return the cursor to its original position.
     ```
      ['<Leader>T' = { "mt?^ *```<CR>jVk/^ *```<CR>k:Sendtoterm<CR>:noh<CR>`t", "Send code block to terminal" },
     ```

## Demos
Demo 1: send whole file to zellij pane with :%Sendtoterm
![demo 1](https://github.com/evanbattaglia/sendtoterm.nvim/blob/assets/images/demo1.gif?raw=true)

Demo 2: using a macro to send text in between \`\`\` to zellij pane
![demo 2](https://github.com/evanbattaglia/sendtoterm.nvim/blob/assets/images/demo2.gif?raw=true)

Demo 3: send line to multiple neovim terminals
![demo 3](https://github.com/evanbattaglia/sendtoterm.nvim/blob/assets/images/demo3.gif?raw=true)


## Plugin development

Based on [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template)

This is my first nvim plugin, so it's a little rough around the edges still.

```
# Run tests using nvim (might require plenary.nvim?)
make 
# Formatter, see https://github.com/JohnnyMorganz/StyLua
stylua .
```
