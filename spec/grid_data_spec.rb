require "spec_helper"

describe GridData do
  it "should have a #config that is an OrderedOptions hash" do
    GridData.config.should be_a ActiveSupport::OrderedOptions
  end
end
