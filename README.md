# Description

This repository contains dev container features, following the [Dev Container Features reference](https://containers.dev/implementors/features/).

# Development

To get started developing, read through the references below and simply run the following command to see the features in action:

```
devcontainer features test
```

# Release

Run the `Publish devcontainers features and generate documentation` workflow to create a new release.

## Allow workflow to generate and commit documentation

Allow the release workflow to auto gemerate and commit a `README.md` file for each feature in the repository, by going to the repositorys `Settings` page and:

1. Under `Code and automation`, expand `Actions`
2. Select `General`
3. Under `Workflow permissions`, ensure the `Read and write permissions` permission is selected and the `Allow GitHub Actions to create and approve pull requests` checkmark is checked.


# References

https://github.com/devcontainers/features
https://github.com/devcontainers/feature-starter
https://containers.dev/implementors/features/
https://containers.dev/guide/feature-authoring-best-practices
