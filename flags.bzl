"Database of Bazel flags which apply across every Bazel use-case"

load("//private:util.bzl", "ge", "lt")

# buildifier: keep-sorted
FLAGS = {
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
}
