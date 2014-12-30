default[:ruby][:version] = "1.9.2-p320"
default[:ruby][:rubygems_version] = "1.8.24"
default[:ruby][:installation_dir] = "/usr/local"
default[:ruby][:src_dir] = "#{node[:ruby][:installation_dir]}/src"
default[:ruby][:bin_dir] = "#{node[:ruby][:installation_dir]}/bin"
case node.platform_family
    when 'debian'
        default[:ruby][:dependencies] = [
            "openssl", "libreadline6", "libreadline6-dev",
            "zlib1g", "zlib1g-dev", "libssl-dev",
            "libyaml-dev", "libxml2-dev", "libxslt-dev",
            "libc6-dev", "libtool"
        ]

    when 'rhel'
        default[:ruby][:dependencies] = [
            "readline", "readline-devel", "zlib", "zlib-devel",
            "libyaml-devel", "libffi-devel", "bzip2", "libtool",
            "openssl", "openssl-devel", "libxml2",
            "libxml2-devel", "libxslt", "libxslt-devel"
        ]

end
