require 'spec_helper'

describe "GridData::Paginators::Kaminari" do
  subject{GridData::Paginators::Kaminari}
  describe "#page(chain, page, rows)" do
    it "should set offset and limit values" do
      result = subject.page(Country, 32, 15)

      result.offset_value.should == (32 - 1) * 15
      result.limit_value.should == 15

    end
  end
end
