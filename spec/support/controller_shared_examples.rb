RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

shared_context 'user signed in' do
  let!(:user) { create(:user) }
  before { sign_in user }
end

shared_context 'admin signed in' do
  let!(:admin) { create(:admin) }
  before { sign_in admin }
end
