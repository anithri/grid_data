require "rspec"

describe "GridData::SqlOperations" do
  subject{GridData::SqlOperations}
  describe "#clause" do
    it "should raise a GridData::SearchError when passed a op that doesn't exist" do
      lambda{ subject.clause("zz", "a", "b") }.should raise_error GridData::SearchError, /do not understand op: zz/
    end

    it "should return a  element array back" do
      subject.clause("eq", "a", "b").should == ["a = ?", "b"]
      subject.clause("cn", "a", "b").should == ["a LIKE ?", "%b%"]
    end
    it "should take a hash as input" do
      subject.clause("op" => "ne", "field" => "a", "data" => "b").should == ["a != ?", "b"]
    end
    describe "it should correctly do numerous ops" do
      specify{subject.clause("eq","a","b").should == ["a = ?", "b"]}
      specify{subject.clause("ne","a","b").should == ["a != ?", "b"]}
      specify{subject.clause("lt","a","b").should == ["a < ?", "b"]}
      specify{subject.clause("le","a","b").should == ["a <= ?", "b"]}
      specify{subject.clause("gt","a","b").should == ["a > ?", "b"]}
      specify{subject.clause("ge","a","b").should == ["a >= ?", "b"]}
      specify{subject.clause("bw","a","b").should == ["a LIKE ?", "b%"]}
      specify{subject.clause("bn","a","b").should == ["a NOT LIKE ?", "b%"]}
      specify{subject.clause("ew","a","b").should == ["a LIKE ?", "%b"]}
      specify{subject.clause("en","a","b").should == ["a NOT LIKE ?", "%b"]}
      specify{subject.clause("cn","a","b").should == ["a LIKE ?", "%b%"]}
      specify{subject.clause("nc","a","b").should == ["a NOT LIKE ?", "%b%"]}
    end
  end

end
