# ACT Homebrew Tap

Instructions for installing Homebrew are available on the [Homebrew website](https://brew.sh/).

## Installing this tap

```bash
brew tap asyncvlsi/tap
```

## Installing ACT

This tap offers two options to install ACT:

- `actflow` installs the [entire suite](https://github.com/asyncvlsi/actflow) of tools
- `act-lang` installs only [ACT itself](https://github.com/asyncvlsi/act) and the [standard library](https://github.com/asyncvlsi/stdlib)

Follow the instructions in the respective sections below to install the desired option.

### Installing `actflow`

Once the tap is installed, run:

```bash
brew install --HEAD actflow
```

In your shell profile, set the `ACT_HOME` environment variable to the installation path:

```bash
export ACT_HOME=/opt/homebrew/opt/actflow
```

If you need to install the latest version of [act](https://github.com/asyncvlsi/act) and it has not yet been merged into the actflow repository, use the `with-newest-act` option:

```bash
brew install --HEAD --with-newest-act actflow
```

### Installing `act-lang`

Once the tap is installed, run:

```bash
brew install --HEAD act-lang
```

In your shell profile, set the `ACT_HOME` environment variable to the installation path:

```bash
export ACT_HOME=/opt/homebrew/opt/act-lang
```

## Upgrading ACT

Run the following, replacing `<OPTION>` with either `actflow` or `act-lang`:

```bash
brew upgrade --fetch-HEAD <OPTION>
```
