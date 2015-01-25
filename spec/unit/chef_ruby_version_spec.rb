require_relative "../spec_helper"

describe "Ruby Version" do
  describe "edge cases" do
    it "is invalid if it is blank" do
      expect(lambda {
        ChefRuby::Version.new("")
      }).to raise_exception.with_message("This version is invalid")
    end

    it "is invalid if there is only one character" do
      expect(lambda {
               ChefRuby::Version.new("1")
             }).to raise_exception.with_message("This version is invalid")
    end

    it "is invalid if there are more than 3 characters" do
      expect(lambda {
               ChefRuby::Version.new("1.2.3.4")
             }).to raise_exception.with_message("This version is invalid")
    end

  end

  it "is valid if the version is like 'major.minor.teeny'" do
    expect(lambda {
             ChefRuby::Version.new("2.1.2")
           }).to_not raise_exception
  end

  it "is valid if the version has a patch number" do
    expect(lambda {
             ChefRuby::Version.new("1.9.2-p320")
           }).to_not raise_exception
  end

  context "Comparing versions" do
    it "confirms versions with the same major, minor, teeny and patch number are the same" do
      expect(ChefRuby::Version.new("1.9.2-p320")).to eq(ChefRuby::Version.new("1.9.2-p320"))
    end

    it "confirms that a version with a higher patch number is the later" do
      ChefRuby::Version.new("1.9.2-p330").should > ChefRuby::Version.new("1.9.2-p320")
    end

    it "confirms that a version with a higher major version number is the later" do
      ChefRuby::Version.new("2.9.2-p320").should > ChefRuby::Version.new("1.9.2-p320")
    end

    it "confirms that a version with a higher minor version number is the later" do
      ChefRuby::Version.new("1.9.2-p320").should > ChefRuby::Version.new("1.8.2-p320")
    end

    it "confirms that a version with a higher teeny version number is the later" do
      ChefRuby::Version.new("1.9.3-p320").should > ChefRuby::Version.new("1.9.2-p320")
    end

    it "confirms that a version with a higher patch number is later than the same version without the path number" do
      ChefRuby::Version.new("1.9.2-p320").should > ChefRuby::Version.new("1.9.2")
    end

    it "confirms that version 1.11.0-p576 is older than version 2.1.0-p576" do
      ChefRuby::Version.new("2.1.0-p576").should > ChefRuby::Version.new("1.11.0-p576")
    end
  end
end