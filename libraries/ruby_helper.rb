module ChefRuby
  module Helper
    include Chef::Mixin::ShellOut

    def already_installed?(version)
      ruby_binary = "#{node[:ruby][:bin_dir]}/ruby"
      ruby_installed_command = shell_out(
          "[ -x #{ruby_binary} ] && #{ruby_binary} -v",  {returns: [0, 2]})
      expected_version = Regexp.escape(version.gsub("-", ""))
      ruby_18x_version_output =
          /#{version[0..4]} \((?:\d{4}-\d{2}-\d{2}) patchlevel #{patch_level(version)}\)/
      ruby_version_output = /#{expected_version}/

      ruby_installed_command.stderr.empty? &&
          !(ruby_installed_command.stdout.strip=~ruby_version_output).nil? ||
          !(ruby_installed_command.stdout.strip=~ruby_18x_version_output).nil?
    end

    def patch_level(version)
      start_of_patch_level = version.index("p")

      if start_of_patch_level
        version[start_of_patch_level + 1..-1]
      else
        '0'
      end
    end

    def rubygems_already_installed?
      gem_binary = "#{node[:ruby][:bin_dir]}/gem"
      rubygems_installed_command = shell_out(
          "[ -x #{gem_binary} ] && #{gem_binary} -v", {returns: [0, 2]})

      rubygems_installed_command.stderr.empty? &&
          rubygems_installed_command.stdout.strip == node[:ruby][:rubygems_version]
    end

    def patch_not_already_applied?(version)
      patch_dry_run_command = shell_out(
          'patch --dry-run -p1 < /tmp/ossl_no_ec2m.patch',
          cwd: "#{node[:ruby][:src_dir]}/ruby-#{version}",
          returns: [0, 2])

      patch_dry_run_command.exitstatus == 0
    end
  end

  module AutoconfHelper
    include Chef::Mixin::ShellOut

    def autoconf_already_installed?(version)
      autoconf_installed_command = shell_out(
          '[ -x /usr/bin/autoconf ] && /usr/bin/autoconf -V', returns: [0, 2])

      first_line = autoconf_installed_command.stdout.split("\n")[0]
      autoconf_installed_command.stderr.empty? && first_line.include?(version)
    end
  end
end

def requires_patch?(version)
  platform?('centos') && node[:platform_version].to_f >= 6.0 &&
      ChefRuby::Version.new(version) <= ChefRuby::Version.new('2.0.0-p247')
end

Chef::Resource::RemoteFile.send(:include, ChefRuby::Helper)
Chef::Resource::Execute.send(:include, ChefRuby::Helper)

Chef::Resource::RemoteFile.send(:include, ChefRuby::AutoconfHelper)
Chef::Resource::Execute.send(:include, ChefRuby::AutoconfHelper)

