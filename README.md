# ACT Homebrew Tap

Instructions for installing Homebrew are available on the [Homebrew website](https://brew.sh/).

To install the entire [actflow](https://github.com/asyncvlsi/actflow/) suite, simply run:

```bash
brew install --HEAD asyncvlsi/tap/actflow
```

In your shell profile, set the `ACT_HOME` environment variable to the installation path:

```bash
export ACT_HOME=/opt/homebrew/opt/actflow
```

If you need to install the latest version of [act](https://github.com/asyncvlsi/act) and it has not yet been merged into the actflow repository, use the `with-newest-act` option:

```bash
brew install --HEAD --with-newest-act asyncvlsi/tap/actflow
```
