require "rspec"

describe GridData::Config do
  subject { GridData::Config }
  before(:all) do
    @project_dir = Pathname.new(__FILE__ + "/../../../").expand_path
    @project_lib_dir = @project_dir + 'lib'
  end
  describe "#generate_default_file_list(top_dir, yaml_ext='yaml'')" do
    it "should generate an empty list if the given directory is nil" do
      subject.generate_default_file_list(nil).should be_a(Array) && be_empty
    end
    it "should raise ConfigError if the top_dir does not exist." do
      lambda{subject.generate_default_file_list('/foo/bar/baz')}.should raise_error(GridData::ConfigError,
                                                                                    /does not exist/)
    end
    it "should return an array of Pathnames for each file top_dir and below with a extension of yaml_ext" do
      result = subject.generate_default_file_list(@project_lib_dir, 'rb')
      result.should be_a Array
    end
  end

  describe "load_config_files_from_list(file_list)" do
    it "should return an empty hash if passed an empty list" do
      subject.load_config_files_from_list.should == {}
    end
    it "should return a hash containing a key for every name in list with value of YAML decoded contents of file" do
      file_list = ['/tmp/abc.yaml','/tmp/def.yaml'].map{|f| Pathname.new(f) }
      YAML.stub(:load_file).and_return(*file_list)
      subject.load_config_files_from_list(file_list).should == {abc: file_list[0],def: file_list[1]}
    end
  end

  describe "prep_extra_files(file_list)" do
    it "should raise a GridData::ConfigError if any of the files do not exist" do
      file_list = ['/tmp/abc.yaml','/tmp/def.yaml']
      lambda{subject.prep_extra_files(file_list)}.should raise_error(GridData::ConfigError,
                                                                     /extra_files.+abc.yaml.+def.yaml/)
    end
    it "should return an array of Pathnames if all the files exist" do
      file_list = [@project_lib_dir.to_s + '/grid_data.rb', @project_dir.to_s + '/spec/grid_data_spec.rb']
      result = subject.prep_extra_files(file_list)
      result.should be_a Array
      result.all?{|f| f.is_a?(Pathname)}.should be_true
    end
  end

  describe "#global_defaults(settings)" do
    it "should initialize an empty ConfigLibrary if passed empty extra and top_dir options" do
      result = GridData::Config.global_defaults()
      result.should be_a ConfigLibrary::Base
      result.search_order.should == []
      result.books.should == {}
    end

    it "should initialize a ConfigLibrary::Base with one entry given a single value in extra_files" do
      extra = @project_dir + "spec/support/bare/test_one.yaml"
      result = GridData::Config.global_defaults(extra_files: [extra.to_s])
      result.should be_a ConfigLibrary::Base
      result.search_order.should == [:test_one]
      result.books.should have_key(:test_one)
    end

    it "should initialize a ConfigLibrary::Base with 3 entries given spec/support as a config_dir" do
      top_dir = @project_dir.to_s + "/spec/support/bare"
      result = GridData::Config.global_defaults(config_dir: top_dir)
      result.should be_a ConfigLibrary::Base
      result.search_order.should == [:test_one, :test_three, :test_two]
      result.books.keys.should =~ [:test_one, :test_two, :test_three]
    end

    it "should initialize a ConfigLibrary::Base with 3 entries with order determined by numbers" do
      top_dir = @project_dir.to_s + "/spec/support/numbered"
      result = GridData::Config.global_defaults(config_dir: top_dir)
      result.should be_a ConfigLibrary::Base
      result.search_order.should == [:test_three, :test_two, :test_one]
    end

  end

end


