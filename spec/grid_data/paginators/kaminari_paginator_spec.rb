require "spec_helper"

describe GridData::Paginators::KaminariPaginator do

  before(:each) {TestStuffKaminari.scrub_values_for_test}
  it "should return a chain having set a limit and offset" do
    result = subject.do_paging(TestStuffKaminari,3,16)
    result.offset_value.should == 32
    result.limit_value.should == 16
  end

end