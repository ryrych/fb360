require 'rails_helper'

describe Admin::ResetPasswordController do
  render_views
  include_context 'admin signed in'

  context '#update' do
    let!(:user) { create(:user) }
    let(:call_request) { put :update, user_id: user.id }

    it 'redirects to edit_admin_user_path' do
      expect(call_request).to redirect_to edit_admin_user_path(user)
    end

    it 'changes password' do
      expect { call_request }.to change { user.reload.encrypted_password }
    end
  end
end
