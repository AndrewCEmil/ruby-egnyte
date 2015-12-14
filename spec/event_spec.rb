#encoding: UTF-8

require 'spec_helper'

describe Egnyte::Event do
  before(:each) do
    stub_request(:get, "https://test.egnyte.com/pubapi/v1/userinfo").
             with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access_token', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => "", :headers => {})
    @session = Egnyte::Session.new({
      key: 'api_key',
      domain: 'test',
      access_token: 'access_token'
    }, :implicit, 0.0)
    @client = Egnyte::Client.new(@session)
  end

  describe "#Event::latest" do

    it "it should return the latest event_id" do
      stub_request(:get, "https://test.egnyte.com/pubapi/v1/events/cursor")
                  .to_return(:status => 201, :body => {"timestamp"=>"2015-01-01T00:00:10.000Z", "latest_event_id"=>1111, "oldest_event_id"=>11}.to_json, :headers => {})
      latest = Egnyte::Event.latest(@session)
      expect(latest).to eq 1111
    end

  end

  describe "#Event::oldest" do

    it "it should return the oldest event_id" do
      stub_request(:get, "https://test.egnyte.com/pubapi/v1/events/cursor")
                  .to_return(:status => 201, :body => {"timestamp"=>"2015-01-01T00:00:10.000Z", "latest_event_id"=>1111, "oldest_event_id"=>11}.to_json, :headers => {})
      oldest = Egnyte::Event.oldest(@session)
      expect(oldest).to eq 11
    end

  end

  describe "#Event::latest_and_oldest" do

    it "it should return the latest and oldest event_ids" do
      stub_request(:get, "https://test.egnyte.com/pubapi/v1/events/cursor")
                  .to_return(:status => 201, :body => {"timestamp"=>"2015-01-01T00:00:10.000Z", "latest_event_id"=>1111, "oldest_event_id"=>11}.to_json, :headers => {})
      pair = Egnyte::Event.latest_and_oldest(@session)
      expect(pair[:latest]).to eq 1111
      expect(pair[:oldest]).to eq 11
    end

  end

  describe "#Event::since_event" do
    it 'should yeild each event' do
      example_event = {"id" => 1, "timestamp"=>Time.now, "actor"=>1, "type"=>"file_system", "action"=>"create", "data"=>{"target_path"=>"/Private/username/My Notes", "is_folder"=>true}, "action_source"=>"System", "object_detail"=>"https://test.egnyte.com/pubapi/v1/fs/Private/username/My%20Notes"}
      first_body = {"count"=> 101, "latest_id"=>100, "events" => []}
      100.times do |i|
        example_event["id"] = i + 1
        first_body["events"] << example_event.clone
      end

      example_event["id"] = 101
      second_body = {"count"=> 1, "latest_id"=>101, "events"=> [example_event]}
      stub_request(:get, "https://test.egnyte.com/pubapi/v1/events?id=1&count=100")
          .to_return(:body => first_body.to_json, :status => 200)
      stub_request(:get, "https://test.egnyte.com/pubapi/v1/events?id=100&count=100")
          .to_return(:body => second_body.to_json, :status => 200)
      counter = 1
      block = Proc.new do |event|
        expect(event["id"]).to eq(counter)
        counter += 1
      end
      Egnyte::Event.each_event_since(@session, 1, block)
      expect(counter).to eq(102)
    end

  end
end
