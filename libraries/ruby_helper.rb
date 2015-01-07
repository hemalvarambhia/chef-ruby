module ChefRuby
  module Helper
    include Chef::Mixin::ShellOut

    def already_installed?
      command = shell_out("ruby -v",  {returns: [0, 2]})
      expected_version = Regexp.escape(node[:ruby][:version].gsub("-", ""))
      command.stderr.empty? and not (command.stdout=~/#{expected_version}/).nil?
    end

    def patch_level
      start_of_patch_level = node[:ruby][:version].index("p")
      node[:ruby][:version][start_of_patch_level + 1..-1]
    end
  end
end