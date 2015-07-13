require 'rails_helper'

describe User::ProfileController do
  render_views
  include_context 'user signed in'

  describe '#edit' do
    let(:call_request) { get :edit }

    context 'after request' do
      before { call_request }

      it { should render_template 'edit' }
      it { expect(controller.user).to eq user }
    end
  end

  describe '#update' do
    let(:call_request) { put :update, user: attributes }

    context 'valid request' do
      let(:attributes) { {first_name: 'Natasha', password: 'secret', password_confirmation: 'secret'} }

      it { expect { call_request }.not_to change { user.reload.first_name } }
      it { expect { call_request }.to change { user.reload.encrypted_password } }

      context 'after request' do
        before { call_request }

        it { should redirect_to edit_user_profile_path }
        it { expect(controller.user).to eq user }
      end
    end

    context 'invalid request' do
      let(:attributes) { {password: 'secret', password_confirmation: ''} }

      it { expect { call_request }.not_to change { user.reload.first_name } }
      it { expect { call_request }.not_to change { user.reload.encrypted_password } }

      context 'after request' do
        before { call_request }

        it { should render_template 'edit' }
        it { expect(controller.user).to eq user }
      end
    end
  end
end
