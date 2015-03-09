module ChefRuby
  module Helper
    include Chef::Mixin::ShellOut

    def already_installed?
      command = shell_out("ruby -v",  {returns: [0, 2]})
      expected_version = Regexp.escape(node[:ruby][:version].gsub("-", ""))
      ruby_18x_version_output = /#{node[:ruby][:version][0..4]} \((?:\d{4}-\d{2}-\d{2}) patchlevel #{patch_level}\)/
      ruby_version_output = /#{expected_version}/
      command.stderr.empty? and !(command.stdout=~ruby_version_output).nil? or
          !(command.stdout=~ruby_18x_version_output).nil?
    end

    def patch_level
      start_of_patch_level = node[:ruby][:version].index("p")

      if start_of_patch_level
        node[:ruby][:version][start_of_patch_level + 1..-1]
      else
        "0"
      end
    end

    def rubygems_already_installed?
      command = shell_out("gem -v", {returns: [0, 2]})

      command.stderr.empty? and command.stdout == node[:ruby][:rubygems_version]
    end

    def patch_not_already_applied?
      patch_dry_run_command = shell_out("patch --dry-run -p1 < /tmp/ossl_no_ec2m.patch",
                                        cwd: "#{node[:ruby][:src_dir]}/ruby-#{node[:ruby][:version]}",
                                        returns: [0, 2])

      patch_dry_run_command.exitstatus == 0
    end
  end
end

def requires_patch?

  platform?("centos") and node.platform_version.to_f >= 6.0 and
      ChefRuby::Version.new(node[:ruby][:version]) <= ChefRuby::Version.new("2.0.0-p247")
end

