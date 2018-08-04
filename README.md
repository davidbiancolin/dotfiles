David's hacky ass dotfiles.
==========================

Typical use case:
```
./setup <optional/path/to/LOCAL>
```

By default setup.sh will put LOCAL at $HOME/.local, if a different path is
specified it will `cat` an export to `~/.zshrc_local`.
