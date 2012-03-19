require "rspec"

describe GridData do
  subject{GridData}
  after(:each) {subject.reset}
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

  describe "#setup" do
    it "should take a block, and set values on the settings hash" do
      subject.setup do |config|
        config.test_one = 1
        config.yaml_extension = "yml"
      end
      subject.settings.should have_key(:test_one)
      subject.settings[:test_one].should == 1
      subject.settings.yaml_extension.should == "yml"
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

  describe "#add_new_bookd(file_list)" do
    it "should take a list of files, load them, and assign them to the configLibrary" do
      subject.setup do |config|
        config.config_dir = Dir.pwd + "/spec/support/numbered"
      end
      files = Dir.glob(Dir.pwd + "/spec/support/extra/*.yaml")
      subject.add_new_books(files)
      subject.config.search_order.should include(:extra_one, :extra_two)
    end
  end
end
