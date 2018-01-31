require 'rails_helper'

RSpec.describe Api::V1::Drivers::AuthenticationController, type: :controller do

  describe "POST #send_password" do
    it "sends password for existing driver" do
      post :send_password, params: {phone_number: create(:driver).phone_number}
      resp = JSON.parse(response.body)
      expect(resp['data']['state']).to eq('old')
    end

    it "creates driver and sends password for new driver" do
      post :send_password, params: {phone_number: '79011234567'}
      resp = JSON.parse(response.body)
      expect(resp['data']['state']).to eq('new')
    end

    it "sends pass fo new driver" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        post :send_password, params: {phone_number: '79011234567'}
      }.to have_enqueued_job(PassSendingJob)
    end

    it "sends pass fo existing driver" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        post :send_password, params: {phone_number: create(:driver).phone_number}
      }.to have_enqueued_job(PassSendingJob)
    end
  end
end
