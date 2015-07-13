require 'rails_helper'

describe Admin::PresentFeedbackController do
  render_views
  include_context 'admin signed in'

  describe '#show' do
    let!(:user_1) { create(:user, first_name: 'Steve', last_name: 'Rogers') }
    let!(:user_2) { create(:user, first_name: 'Natasha', last_name: 'Romanova') }
    before { create(:user, first_name: 'Bruce', last_name: 'Banner', archived: true) }

    context 'without receiver_id' do
      let(:call_request) { get :show }

      it 'renders show' do
        expect(call_request).to render_template 'show'
      end

      it 'set receiver to first user' do
        call_request
        expect(controller.send(:receiver)).to eq user_2
      end

      context 'feedback is created' do
        let!(:feedback_ok) { create(:feedback, giver: user_1, receiver: user_2, published: true, published_at: Date.today) }
        let!(:feedback_outdated) { create(:feedback, giver: user_1, receiver: user_2, published: true, published_at: 4.weeks.ago) }
        let!(:feedback_wrong_user) { create(:feedback, giver: user_2, receiver: user_1, published: true, published_at: Date.today) }

        it 'set receiver to firs user' do
          call_request
          expect(controller.send(:feedbacks)).to eq [feedback_ok]
        end
      end
    end

    context 'with receiver_id' do
      let(:call_request) { get :show, receiver_id: user_1.id }

      it 'renders show' do
        expect(call_request).to render_template 'show'
      end

      it 'set receiver to first user' do
        call_request
        expect(controller.send(:receiver)).to eq user_1
      end

      context 'feedback is created' do
        let!(:feedback_ok) { create(:feedback, giver: user_2, receiver: user_1, published: true, published_at: Date.today) }
        let!(:feedback_outdated) { create(:feedback, giver: user_2, receiver: user_1, published: true, published_at: 4.weeks.ago) }
        let!(:feedback_wrong_user) { create(:feedback, giver: user_1, receiver: user_2, published: true, published_at: Date.today) }

        it 'set receiver to firs user' do
          call_request
          expect(controller.send(:feedbacks)).to eq [feedback_ok]
        end
      end
    end
  end
end
