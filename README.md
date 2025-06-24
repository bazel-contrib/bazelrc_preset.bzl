# bazelrc Presets

Bazel has a tremendously large number of flags.
Many are obscure, many are important to use, and many have an undesirable default value.

Bazel options may be stored in `*.bazelrc` files, in several places on disk.
Read [the Bazel bazelrc documentation](https://bazel.build/run/bazelrc).
This repo provides bazelrc files you may vendor into your repo, which we call "presets".

> [!NOTE]  
> Ideally bazelrc would allow import statements from external repositories, so that you wouldn't be forced to copy presets into your repo.
> However the current behavior is that imports must be repository-relative.
> This could also be considered a feature, since it means that newer preset changes will be code-reviewed when they arrive in your repo,
> rather than as an invisible side-effect of updating the version of bazelrc-presets.

## Usage

First add `bazelrc-preset.bzl` to your `MODULE.bazel` file.
Then call it from a BUILD file, for example in `tools/BUILD`:

```
load("@bazelrc-preset.bzl", "bazelrc_preset")

bazelrc_preset(
    name = "preset", # writes preset.bazelrc
)
```

Now create the preset with `bazel run //tools:preset.update`.
Note, you don't need to remember the command, it will be printed if the file is missing
or has outdated contents.

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

See https://github.com/bazel-contrib/SIG-rules-authors/issues/106
