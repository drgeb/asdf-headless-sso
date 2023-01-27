<div align="center">

# asdf-headless-sso [![Build](https://github.com/drgeb/asdf-headless-sso/actions/workflows/build.yml/badge.svg)](https://github.com/drgeb/asdf-headless-sso/actions/workflows/build.yml) [![Lint](https://github.com/drgeb/asdf-headless-sso/actions/workflows/lint.yml/badge.svg)](https://github.com/drgeb/asdf-headless-sso/actions/workflows/lint.yml)


[headless-sso](https://github.com/mziyabo/headless-sso) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add headless-sso
# or
asdf plugin add headless-sso https://github.com/drgeb/asdf-headless-sso.git
```

headless-sso:

```shell
# Show all installable versions
asdf list-all headless-sso

# Install specific version
asdf install headless-sso latest

# Set a version globally (on your ~/.tool-versions file)
asdf global headless-sso latest

# Now headless-sso commands are available
headless-sso --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/drgeb/asdf-headless-sso/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Gerry Bennett](https://github.com/drgeb/)
