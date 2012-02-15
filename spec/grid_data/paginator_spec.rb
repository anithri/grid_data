require "spec_helper"

describe GridData::Paginator do
  describe "#determine_paginator" do
    context "If no GridData.config.paginator is set" do
      before(:each) {GridData.config.delete(:paginator)}

      it "should raise an exception if it finds no paginator" do
        lambda{subject.determine_paginator(String)}.should raise_error(GridData::NoPaginatorFoundError,/String/)
      end

      it "should raise an exception if it find an invalid paginator in the model" do
        lambda{subject.determine_paginator(ModelWithInvalidConfig)}.should raise_error(GridData::InvalidPaginatorError,/ModelWithInvalidConfig/)
      end

      it "should return the paginator defined in Grid_data" do
        subject.determine_paginator(ModelWithValidConfig).should == ValidPaginator
      end
    end

    context "If GridData.config.paginator is set" do
      it "should raise an exception if the paginator can't be found or does not have #do_paging'" do
        GridData.config.paginator = "String"
        lambda{subject.determine_paginator(Hash)}.should raise_error(GridData::InvalidPaginatorError,/String/)

        GridData.config.paginator = "SomeMessedUpName"
        lambda{subject.determine_paginator(Array)}.should raise_error(GridData::InvalidPaginatorError,/SomeMessedUpName/)
      end

      it "return the model paginator" do
        subject.determine_paginator(ModelWithValidConfig).should == ValidPaginator
      end
    end
  end
end
