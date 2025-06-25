# bazelrc Presets

Bazel has a tremendously large number of flags.
Many are obscure, many are important to use, and many have an undesirable default value.

Bazel options may be stored in `*.bazelrc` files, in several places on disk.
Read [the Bazel bazelrc documentation](https://bazel.build/run/bazelrc).

This rule generates a custom bazelrc file that matches your bazel version
and makes it convenient to vendor into your repo.
We call this a "preset".

> [!NOTE]  
> Preset changes can cause behavior changes in your repo that are undesirable or even break the build.
> Since vendoring is required, changes will be code-reviewed when they arrive in your repo, rather than as an invisible side-effect of updating the version of bazelrc-presets.
> For this reason, this ruleset does not stricly follow Semantic Versioning.

## Usage

First add `bazelrc-preset.bzl` to your `MODULE.bazel` file.
Then call it from a BUILD file, for example in `tools/BUILD`:

```starlark
load("@bazelrc-preset.bzl", "bazelrc_preset")

bazelrc_preset(
    name = "preset",
)
```

Now create the preset with `bazel run //tools:preset.update`.
Note that you don't need to remember the command.
A test target `preset.update_test` is also created, which prints the command if the file is missing or has outdated contents.

Finally, import it into your project `/.bazelrc` file.
We suggest you add it at the top, so that project-specific flags may override, as follows:

```
# Import bazelrc presets
import %workspace%/tools/preset.bazelrc
...

### Project-specific flags ###

...

# Load any settings & overrides specific to the current user from `user.bazelrc`.
# This file should appear in `.gitignore` so that settings are not shared with team members. This
# should be last statement in this config so the user configuration is able to overwrite flags from
# this file. See https://bazel.build/configure/best-practices#bazelrc-file.
try-import %workspace%/user.bazelrc
```

## References and Credits

This was originally a feature of Aspect's bazel-lib:
https://github.com/bazel-contrib/bazel-lib/tree/main/.aspect/bazelrc

This rule is maintained by the Rules Authors SIG, see https://github.com/bazel-contrib/SIG-rules-authors/issues/106
