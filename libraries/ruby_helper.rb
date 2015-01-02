module ChefRuby
  module Helper
    include Chef::Mixin::ShellOut

    def already_installed?
      shell_out("ruby -v | grep #{node[:ruby][:version][0..4]} | grep p#{patch_level}",  {returns: [0, 2]})
    end

    def patch_level
      start_of_patch_level = node[:ruby][:version].index("p")
      node[:ruby][:version][start_of_patch_level + 1..-1]
    end
  end
end