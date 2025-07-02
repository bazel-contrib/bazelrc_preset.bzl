# Preset for bazelrc

Bazel has a tremendously large number of flags.
Many are obscure, many are important to use, and many have an undesirable default value.

This rule generates a custom `bazelrc` file that matches your Bazel version and makes it convenient to vendor into your repo.
We call this a "preset".

> [!NOTE]
> Preset changes can cause behavior changes in your repo that are undesirable or even break the build.
> Since vendoring is required, changes will be code-reviewed when they arrive in your repo, rather than as an invisible side-effect of updating the version of bazelrc_preset.
> For this reason, this rule does not strictly follow Semantic Versioning.

Bazel options may be stored in `*.bazelrc` files, in several places on disk.
Read [the Bazel bazelrc documentation](https://bazel.build/run/bazelrc).

## Install

1. Add `bazelrc_preset.bzl` to your `MODULE.bazel` file.
2. Call it from a BUILD file, for example in `tools/BUILD`:

```starlark
load("@bazelrc_preset.bzl", "bazelrc_preset")

bazelrc_preset(
    name = "preset",
)
```

3. Create the preset by running `bazel run //tools:preset.update`.
Note that you don't need to remember the command.
A test target `preset.update_test` is also created, which prints the command if the file is missing or has outdated contents.

4. Import it into your project's `/.bazelrc` file.
We suggest you add it at the top, so that project-specific flags may override values.
See https://bazel.build/configure/best-practices#bazelrc-file

You can copy this template to get started:

```
########################
# Import bazelrc presets
import %workspace%/tools/preset.bazelrc
...

########################
# Project-specific flags
# This is also a place to override settings from the presets

...

########################
# User preferences
# Load any settings & overrides specific to the current user from `user.bazelrc`.
# This file should appear in `.gitignore` so that settings are not shared with team members.
# This should be last statement in this config so the user configuration overrides anything above.
try-import %workspace%/user.bazelrc
```

5. Some flags are enabled only under a given config.
   For example, many flags apply only when running on CI.
   Configure your CI system to always pass `--config=ci` when running Bazel (for example, put it in the system bazelrc on CI runner machines).

## References and Credits

This was originally a feature of Aspect's bazel-lib:
https://github.com/bazel-contrib/bazel-lib/tree/main/.aspect/bazelrc

This rule is maintained by the Rules Authors SIG, see https://github.com/bazel-contrib/SIG-rules-authors/issues/106
