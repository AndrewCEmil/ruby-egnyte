#encoding: UTF-8

require 'spec_helper'

describe Egnyte::Helper do
  describe "#normalize_path" do
  	it 'should remove leading and trailing slashes' do
	    expect(Egnyte::Helper.normalize_path('/banana')).to eq('banana')
	    expect(Egnyte::Helper.normalize_path('banana/')).to eq('banana')
	    expect(Egnyte::Helper.normalize_path('/banana/')).to eq('banana')
	    expect(Egnyte::Helper.normalize_path('banana')).to eq('banana')
	    expect(Egnyte::Helper.normalize_path('/ban/ana/')).to eq('ban/ana')
	end
  end

  describe "#params_to_s" do
    it 'should convert a parameters hash to an properly formatted params query string' do
      expect(Egnyte::Helper.params_to_s({email: 'test@egnyte.com'})).to eq "?email=test@egnyte.com"
      # expect(Egnyte::Helper.params_to_filter_string({authType: 'ad', userType: 'power'})).to eq "?filter=authType%20eq%20%22ad%22&filter=userType%20eq%20%22power%22"
    end
  end

  describe "#params_to_filter_string" do
  	it 'should convert a parameters hash to an Egnyte formatted filter string' do
  		expect(Egnyte::Helper.params_to_filter_string({email: 'test@egnyte.com'})).to eq "?filter=email eq \"test@egnyte.com\""
  		expect(Egnyte::Helper.params_to_filter_string({authType: 'ad', userType: 'power'})).to eq "?filter=authType eq \"ad\"&filter=userType eq \"power\""
  	end
  end

end
