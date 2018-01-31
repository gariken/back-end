# require 'rails_helper'

# RSpec.describe SynchronizationChannel do
#   subject(:channel) { described_class.new(connection, {}) }

#   # let(:current_profile) { double(id: "1", name: "Bob") }

#   # Connection is `identified_by :current_profile`
#   # let(:connection) { TestConnection.new(current_profile: current_profile) }

#   let(:action_cable) { ActionCable.server }

#   # ActionCable dispatches actions by the `action` attribute.
#   # In this test we assume the payload was successfully parsed (it could be a JSON payload, for example).
#   # let(:data) do
#   #   {
#   #     "action" => "test_action",
#   #     "times_to_say_hello" => 3
#   #   }
#   # end

#   it "broadcasts 'Hello, Bob!' 3 times" do
#     data = { data: "data" }
#     expect(action_cable).to receive(:broadcast).with("synchronization", data)

#     # channel.perform_action(data)
#   end
# end
