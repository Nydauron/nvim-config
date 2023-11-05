function VersionAtLeast(minimum_version, actual_version)
    return minimum_version.major < actual_version.major or
        minimum_version.major == actual_version.major and (
            minimum_version.minor < actual_version.minor or
            minimum_version.minor == actual_version.minor and (
                minimum_version.patch <= actual_version.patch))
end

return VersionAtLeast
