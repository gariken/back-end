require 'rails_helper'

RSpec.describe Api::V1::Users::AuthenticationController, type: :controller do

  describe "POST #send_password" do
    it "sends password for existing user" do
      post :send_password, params: {phone_number: create(:user).phone_number}
      resp = JSON.parse(response.body)
      expect(resp['data']['state']).to eq('old')
    end

    it "creates user and sends password for new user" do
      post :send_password, params: {phone_number: '79011234567'}
      resp = JSON.parse(response.body)
      expect(resp['data']['state']).to eq('new')
    end

    it "sends pass fo new user" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        post :send_password, params: {phone_number: '79011234567'}
      }.to have_enqueued_job(PassSendingJob)
    end

    it "sends pass fo existing user" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        post :send_password, params: {phone_number: create(:user).phone_number}
      }.to have_enqueued_job(PassSendingJob)
    end
  end
end
