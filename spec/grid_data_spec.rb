require "rspec"

describe GridData do
  subject{GridData}
  describe "#settings" do
    it "should return a hash" do
      subject.settings.should be_a Hash
      subject.settings.keys.should =~ [:config_dir, :yaml_extension, :extra_files]
    end

    it "should allow new values to be set in hash" do
      subject.settings[:testing] = 123
      subject.settings.should have_key :testing
      subject.settings[:testing].should == 123
    end
  end

  describe "#config" do
    it "should be nil unless #init has run" do
      subject.config.should be_nil
    end

    it "should return a ConfigLibrary after init" do
      subject.config.should be_nil
      subject.settings[:config_dir]= nil
      subject.init
      subject.config.should be_a ConfigLibrary::Base
    end

  end
end
