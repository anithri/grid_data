require "spec_helper"
describe GridData::Strategy do

  before(:each) {GridData.config.delete(:registered_strategies)}

  describe "#determine_strategy(model)" do
    it "should raise an error if no strategies are defined" do
      expect {GridData::Strategy.determine_strategy(NilClass)}.to raise_error(GridData::NoStrategyFoundError)
    end

    it "should raise an error is given an invalid strategy" do
      GridData.config.registered_strategies = [InvalidStrategy]
      expect {GridData::Strategy.determine_strategy(NilClass)}.to raise_error(GridData::InvalidStrategyError, /InvalidStrategy/)
    end

    it "should raise an error if no strategy is found for a given model" do
      GridData.config.registered_strategies = [ValidStrategy]
      expect {GridData::Strategy.determine_strategy(NilClass)}.to raise_error(GridData::NoStrategyFoundError, /NilClass/)
    end

    it "should return ActiveRecord for an ActiveRecord model" do
      GridData.config.registered_strategies = [ValidActiveRecordStrategy]
      GridData::Strategy.determine_strategy(NilClass).should be_a ValidActiveRecordStrategy
    end
  end
end

module InvalidStrategy

end

module ValidStrategy
  extend self
  def self.applies_to_model?(*args)
    nil
  end
end

module ValidActiveRecordStrategy
  extend self
  def self.applies_to_model?(*args)
    return self
  end
end
