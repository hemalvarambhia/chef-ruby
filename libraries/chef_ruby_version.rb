module ChefRuby
  class Version
    include Comparable
    attr_reader :version
    def initialize(version)
      raise Exception.new("This version is invalid") if version.split(".").size < 3 or version.split(".").size > 3
      @version = version
    end

    def <=>(other)
      @version <=> other.version
    end
  end
end
