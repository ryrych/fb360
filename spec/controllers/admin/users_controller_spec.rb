require 'rails_helper'

describe Admin::UsersController do
  render_views
  include_context 'admin signed in'

  describe '#index' do
    let(:call_request) { get :index }
    let!(:user) { create(:user) }

    context 'after request' do
      before { call_request }

      it { expect(controller.users).to eq [admin, user] }
      it { should render_template 'index' }
    end
  end

  describe '#new' do
    let(:call_request) { get :new }

    context 'after request' do
      before { call_request }

      it { expect(controller.user.persisted?).to be false }
      it { should render_template 'new' }

    end
  end

  describe '#edit' do
    let(:user) { create(:user) }
    let(:call_request) { get :edit, id: user.id }

    context 'after request' do
      before { call_request }

      it { should render_template 'edit' }
      it { expect(controller.user).to eq user }
    end
  end

  describe '#update' do
    let!(:user) { create(:user, first_name: 'Steve', last_name: 'Rogers') }
    let(:call_request) { put :update, id: user.id, user: attributes }

    context 'valid request' do
      let(:attributes) { {first_name: 'Natasha', last_name: 'Romanova'} }

      it { expect { call_request }.to change { user.reload.first_name }.from('Steve').to('Natasha') }
      it { expect { call_request }.to change { user.reload.last_name }.from('Rogers').to('Romanova') }

      context 'after request' do
        before { call_request }

        it { should redirect_to admin_users_path }
        it { expect(controller.user).to eq user }
      end
    end

    context 'invalid request' do
      let(:attributes) { {first_name: '', last_name: 'Banner'} }

      it { expect { call_request }.not_to change { user.reload.first_name } }
      it { expect { call_request }.not_to change { user.reload.last_name } }

      context 'after request' do
        before { call_request }

        it { should render_template 'edit' }
        it { expect(controller.user).to eq user }
      end
    end
  end

  describe '#create' do
    let(:call_request) { post :create, user: attributes }

    context 'valid request' do
      let(:attributes) do
        {email: 'captain.america@selleo.com',
         first_name: 'Steve',
         last_name: 'Rogers',
         password: 'secret',
         password_confirmation: 'secret'}
      end

      it { expect { call_request }.to change { User.count }.by(1) }

      context 'after request' do
        before { call_request }
        let(:created_user) { User.last }

        it { should redirect_to admin_users_path }
      end
    end

    context 'invalid request' do
      let(:attributes) { attributes_for(:user, email: nil) }

      it { expect { call_request }.not_to change { User.count } }

      context 'after request' do
        before { call_request }

        it { should render_template 'new' }
      end
    end
  end
end
