# *kli* Action

A GitHub Action for installing the [konstellation-io/kli](https://github.com/konstellation-io/kli) CLI tool.

### Inputs

For more information on inputs, see the [API Documentation](https://developer.github.com/v3/repos/releases/#input)

- `version`: The chart-testing version to install (default: `v1.0-alpha.4`)

### Example Workflow

Create a workflow (eg: `.github/workflows/lint-test.yaml`):

```yaml
name: Kli

on: push

jobs:
  install-kli:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Set up kli
        uses: blopezpi/action-kli@v1.0.0
        with:
          version: v1.0-alpha.4
```
