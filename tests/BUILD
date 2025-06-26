load("@bazel_skylib//rules:native_binary.bzl", "native_test")
load("//:bazelrc-preset.bzl", "generate_preset")

generate_preset(
    name = "preset",
    out = "preset.bazelrc",
)

# To inspect the changes to presets when contributors send a PR
native_test(
    name = "test",
    args = ["$(rootpath :preset)"],
    data = [":preset"],
    src = "cat.sh",
)
