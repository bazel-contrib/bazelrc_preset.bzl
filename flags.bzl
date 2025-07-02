"Database of Bazel flags which apply across every Bazel use-case"

load("//private:util.bzl", "ge", "lt")

# buildifier: keep-sorted
FLAGS = {
    "announce_rc": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, announce all announces command options read from the bazelrc file(s) when starting up at the
        beginning of each Bazel invocation. This is very useful on CI to be able to inspect which flags
        are being applied on each run based on the order of overrides.
        """,
    ),
    "build_runfile_links": [
        struct(
            default = False,
            description = """\
            Avoid creating a runfiles tree for binaries or tests until it is needed.
            See https://github.com/bazelbuild/bazel/issues/6627
            This may break local workflows that `build` a binary target, then run the resulting program outside of `bazel run`.
            In those cases, the script will need to call `bazel build --build_runfile_links //my/binary:target` and then execute the resulting program.
            """,
        ),
        struct(
            if_bazel_version = lt("8.0.0rc1"),
            default = True,
            command = "coverage",
            description = """\
            See https://github.com/bazelbuild/bazel/issues/20577
            """,
        ),
    ],
    "cache_test_results": struct(
        command = "common:debug",
        default = False,
        description = """\
        Always run tests even if they have cached results.
        This ensures tests are executed fresh each time, useful for debugging and ensuring test reliability.
        """,
    ),
    "color": struct(
        command = "common:ci",
        default = "yes",
        description = """\
        On CI, use colors to highlight output on the screen. Set to `no` if your CI does not display colors.
        """,
    ),
    "curses": struct(
        command = "common:ci",
        default = "yes",
        description = """\
        On CI, use cursor controls in screen output.
        """,
    ),
    "enable_platform_specific_config": struct(
        default = True,
        description = """\
        Bazel picks up host-OS-specific config lines from bazelrc files. For example, if the host OS is
        Linux and you run bazel build, Bazel picks up lines starting with build:linux. Supported OS
        identifiers are `linux`, `macos`, `windows`, `freebsd`, and `openbsd`. Enabling this flag is
        equivalent to using `--config=linux` on Linux, `--config=windows` on Windows, etc.
        """,
    ),
    "experimental_check_external_repository_files": struct(
        default = False,
        description = """\
        Speed up all builds by not checking if external repository files have been modified.
        For reference: https://github.com/bazelbuild/bazel/blob/1af61b21df99edc2fc66939cdf14449c2661f873/src/main/java/com/google/devtools/build/lib/bazel/repository/RepositoryOptions.java#L244
        """,
    ),
    "experimental_remote_cache_eviction_retries": struct(
        default = 5,
        if_bazel_version = ge("6.2.0") and lt("8.0.0rc1"),
        description = """\
        This flag was added in Bazel 6.2.0 with a default of zero:
        https://github.com/bazelbuild/bazel/commit/24b45890c431de98d586fdfe5777031612049135
        For Bazel 8.0.0rc1 the default was changed to 5:
        https://github.com/bazelbuild/bazel/commit/739e37de66f4913bec1a55b2f2a162e7db6f2d0f
        Back-port the updated flag default value to older Bazel versions.
        """,
    ),
    "experimental_repository_downloader_retries": struct(
        default = 5,
        if_bazel_version = ge("5.0.0") and lt("8.0.0"),
        description = """\
        This flag was added in Bazel 5.0.0 with a default of zero:
        https://github.com/bazelbuild/bazel/commit/a1137ec1338d9549fd34a9a74502ffa58c286a8e
        For Bazel 8.0.0 the default was changed to 5:
        https://github.com/bazelbuild/bazel/commit/9335cf989ee6a678ca10bc4da72214634cef0a57
        Back-port the updated flag default value to older Bazel versions.
        """,
    ),
    "flaky_test_attempts": struct(
        command = "test:ci",
        default = 2,
        description = """\
        Set this flag to enable re-tries of failed tests on CI.
        When any test target fails, try one or more times. This applies regardless of whether the "flaky"
        tag appears on the target definition.
        This is a tradeoff: legitimately failing tests will take longer to report,
        but we can "paper over" flaky tests that pass most of the time.

        An alternative is to mark every flaky test with the `flaky = True` attribute, but this requires
        the buildcop to make frequent code edits.
        This flag is not recommended for local builds: flakiness is more likely to get fixed if it is
        observed during development.

        Note that when passing after the first attempt, Bazel will give a special "FLAKY" status rather than "PASSED".
        """,
    ),
    "grpc_keepalive_time": struct(
        command = "common:ci",
        default = "30s",
        description = """\
        Fixes builds hanging on CI that get the TCP connection closed without sending RST packets.
        """,
    ),
    "heap_dump_on_oom": struct(
        default = True,
        description = """\
        Output a heap dump if an OOM is thrown during a Bazel invocation
        (including OOMs due to `--experimental_oom_more_eagerly_threshold`).
        The dump will be written to `<output_base>/<invocation_id>.heapdump.hprof`.
        You should configure CI to upload this artifact for later inspection.
        """,
    ),
    "remote_download_toplevel": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, only download remote outputs of top level targets to the local machine.
        """,
    ),
    "remote_local_fallback": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, fall back to standalone local execution strategy if remote execution fails.
        Otherwise, when a grpc remote cache connection fails, it would fail the build.
        """,
    ),
    "remote_timeout": struct(
        command = "common:ci",
        default = 3600,
        description = """\
        On CI, extend the maximum amount of time to wait for remote execution and cache calls.
        """,
    ),
    "remote_upload_local_results": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, upload locally executed action results to the remote cache.
        """,
    ),
    "reuse_sandbox_directories": struct(
        default = True,
        description = """\
        Reuse sandbox directories between invocations.
        Directories used by sandboxed non-worker execution may be reused to avoid unnecessary setup costs.
        Saves time on sandbox creation and deletion when many of the same kind of action is spawned during the build.
        """,
    ),
    "show_progress_rate_limit": struct(
        command = "common:ci",
        default = 60,
        description = """\
        Only show progress every 60 seconds on CI.
        We want to find a compromise between printing often enough to show that the build isn't stuck,
        but not so often that we produce a long log file that requires a lot of scrolling.
        """,
    ),
    "show_result": struct(
        default = 20,
        description = """\
        The printed files are convenient strings for copy+pasting to the shell, to execute them.
        This option requires an integer argument, which is the threshold number of targets above which result information is not printed.
        Show the output files created by builds that requested more than one target.
        This helps users locate the build outputs in more cases.
        """,
    ),
    "show_timestamps": struct(
        command = "common:ci",
        default = True,
        description = """\
        On CI, add a timestamp to each message generated by Bazel specifying the time at which the message was displayed.
        This makes it easier to reason about what were the slowest steps on CI.
        """,
    ),
    "terminal_columns": struct(
        command = "common:ci",
        default = 143,
        description = """\
        The terminal width in columns. Configure this to override the default value based on what your CI system renders.
        """,
    ),
    "test_output": [
        struct(
            default = "errors",
            description = """\
            Output test errors to stderr so users don't have to `cat` or open test failure log files when test fail.
            This makes the log noisier in exchange for reducing the time-to-feedback on test failures for users.
            """,
        ),
        struct(
            command = "common:debug",
            default = "streamed",
            description = """\
            Stream stdout/stderr output from each test in real-time.
            This provides immediate feedback during test execution, useful for debugging test failures.
            """,
        ),
    ],
    "test_strategy": struct(
        command = "common:debug",
        default = "exclusive",
        description = """\
        Run one test at a time in exclusive mode.
        This prevents test interference and provides clearer output when debugging test issues.
        """,
    ),
    "test_summary": struct(
        command = "test:ci",
        default = "terse",
        description = """\
        The default test_summary ("short") prints a result for every test target that was executed.
        In a large repo this amounts to hundreds of lines of additional log output when testing a broad wildcard pattern like //...
        This value means to print information only about unsuccessful tests that were run.
        """,
    ),
    "test_timeout": struct(
        command = "common:debug",
        default = 9999,
        description = """\
        Prevent long running tests from timing out.
        Set to a high value to allow tests to complete even if they take longer than expected.
        """,
    ),
}
