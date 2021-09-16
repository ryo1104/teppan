require 'rails_helper'

RSpec.describe IncomingsMailbox, type: :mailbox do
  it 'routes email to proper mailbox' do
    expect(IncomingsMailbox).
      to receive_inbound_email(to: 'test@dev.gentle-cloud.com')
  end
end
