# Used only under Bazel 6 or earlier
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "aspect_bazel_lib",
    sha256 = "9a44f457810ce64ec36a244cc7c807607541ab88f2535e07e0bf2976ef4b73fe",
    strip_prefix = "bazel-lib-2.19.4",
    url = "https://github.com/bazel-contrib/bazel-lib/releases/download/v2.19.4/bazel-lib-v2.19.4.tar.gz",
)

load("@aspect_bazel_lib//lib:repositories.bzl", "aspect_bazel_lib_dependencies")

aspect_bazel_lib_dependencies()

http_archive(
    name = "bazel_features",
    sha256 = "07bd2b18764cdee1e0d6ff42c9c0a6111ffcbd0c17f0de38e7f44f1519d1c0cd",
    strip_prefix = "bazel_features-1.32.0",
    url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.32.0/bazel_features-v1.32.0.tar.gz",
)

load("@bazel_features//:deps.bzl", "bazel_features_deps")

bazel_features_deps()
