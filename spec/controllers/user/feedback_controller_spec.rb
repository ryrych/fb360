require 'rails_helper'

describe User::FeedbacksController do
  render_views
  include_context 'user signed in'

  describe '#index' do
    let(:user_2) { create(:user) }
    let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: true, published_at: Date.today) }
    let!(:feedback_2) { create(:feedback, giver: user_2, receiver: user, published: true, published_at: Date.today) }
    let!(:feedback_3) { create(:feedback, giver: user, receiver: user_2, published: false, published_at: Date.today) }
    let!(:feedback_wrong) { create(:feedback, giver: user_2, receiver: user, published: false, published_at: Date.today) }

    let(:call_request) { get :index }

    context 'after request' do
      before { call_request }

      it { expect(controller.feedbacks).to include(*[feedback, feedback_2, feedback_3]) }
      it { should render_template 'index' }
    end
  end

  describe '#new' do
    let!(:user_2) { create(:user, first_name: 'Steve', last_name: 'Rogers') }
    let!(:user_3) { create(:user, first_name: 'Natasha', last_name: 'Romanova') }
    before { create(:user, first_name: 'Bruce', last_name: 'Banner', archived: true) }

    context 'without receiver_id' do
      let(:call_request) { get :new }

      it 'renders new' do
        expect(call_request).to render_template 'new'
      end

      it 'set receiver to first user' do
        call_request
        expect(controller.send(:receiver)).to eq user_3
      end
    end

    context 'with receiver_id' do
      let(:call_request) { get :new, receiver_id: user_2.id }

      it 'renders new' do
        expect(call_request).to render_template 'new'
      end

      it 'set receiver to first user' do
        call_request
        expect(controller.send(:receiver)).to eq user_2
      end
    end
  end

  describe '#edit' do
    let(:user_2) { create(:user) }
    let(:call_request) { get :edit, id: feedback.id }

    context 'my feedback' do
      context 'published' do
        let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: true, published_at: Date.today) }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['alert']).to eq 'You cannot edit published feedback!' }
        end
      end

      context 'not published' do
        let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: false, published_at: nil) }

        context 'after request' do
          before { call_request }

          it { should render_template 'edit' }
          it { expect(controller.feedback).to eq feedback }
        end
      end
    end

    context 'not my feedback' do
      context 'published' do
        let!(:feedback) { create(:feedback, giver: user_2, receiver: user, published: true, published_at: Date.today) }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['alert']).to eq 'You cannot edit feedback created by someone else!' }
        end
      end
    end

    context 'not published' do
      let!(:feedback) { create(:feedback, giver: user_2, receiver: user, published: false, published_at: nil) }

      context 'after request' do
        before { call_request }

        it { should redirect_to user_feedbacks_path }
        it { expect(flash['alert']).to eq 'You cannot edit feedback created by someone else!' }
      end
    end
  end

  describe '#destroy' do
    let(:user_2) { create(:user) }
    let(:call_request) { delete :destroy, id: feedback.id }

    context 'my feedback' do
      context 'published' do
        let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: true, published_at: Date.today) }

        it { expect { call_request }.not_to change { Feedback.count } }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['alert']).to eq 'You cannot edit published feedback!' }
        end
      end

      context 'not published' do
        let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: false, published_at: nil) }

        it { expect { call_request }.to change { Feedback.count }.by(-1) }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['notice']).to eq 'Feedback has been removed.' }
          it { expect(controller.feedback).to eq feedback }
        end
      end
    end

    context 'not my feedback' do
      context 'published' do
        let!(:feedback) { create(:feedback, giver: user_2, receiver: user, published: true, published_at: Date.today) }

        it { expect { call_request }.not_to change { Feedback.count } }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['alert']).to eq 'You cannot edit feedback created by someone else!' }
        end
      end
    end

    context 'not published' do
      let!(:feedback) { create(:feedback, giver: user_2, receiver: user, published: false, published_at: nil) }

      it { expect { call_request }.not_to change { Feedback.count } }

      context 'after request' do
        before { call_request }

        it { should redirect_to user_feedbacks_path }
        it { expect(flash['alert']).to eq 'You cannot edit feedback created by someone else!' }
      end
    end
  end

  describe '#update' do
    let(:user_2) { create(:user) }
    let(:call_request) { put :update, id: feedback.id, feedback: {content: 'new text', feedback_type: 'bad'} }

    context 'my feedback' do
      context 'published' do
        let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: true, published_at: Date.today) }

        it { expect { call_request }.not_to change { feedback.reload.content } }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['alert']).to eq 'You cannot edit published feedback!' }
        end
      end

      context 'not published' do
        let!(:feedback) { create(:feedback, giver: user, receiver: user_2, published: false, published_at: nil) }

        context 'valid request' do
          it { expect { call_request }.to change { feedback.reload.content }.to 'new text' }
          it { expect { call_request }.to change { feedback.reload.feedback_type }.to 'bad' }

          context 'after request' do
            before { call_request }

            it { should redirect_to user_feedbacks_path }
            it { expect(flash['notice']).to eq 'Feedback has been updated.' }
            it { expect(controller.feedback).to eq feedback }
          end
        end

        context 'invalid request' do
          context 'blank content' do
            let(:call_request) { put :update, id: feedback.id, feedback: {content: '', feedback_type: 'bad'} }

            it { expect { call_request }.not_to change { feedback.reload.content } }
            it { expect { call_request }.not_to change { feedback.reload.feedback_type } }

            context 'after request' do
              before { call_request }

              it { should render_template 'edit' }
              it { expect(controller.feedback).to eq feedback }
            end
          end

          context 'receiver set to myself' do
            let(:call_request) { put :update, id: feedback.id, feedback: {content: 'new text', receiver_id: user.id} }

            it { expect { call_request }.not_to change { feedback.reload.receiver_id } }
            it { expect { call_request }.not_to change { feedback.reload.feedback_type } }

            context 'after request' do
              before { call_request }

              it { should render_template 'edit' }
              it { expect(controller.feedback).to eq feedback }
            end
          end
        end
      end
    end

    context 'not my feedback' do
      context 'published' do
        let!(:feedback) { create(:feedback, giver: user_2, receiver: user, published: true, published_at: Date.today) }

        it { expect { call_request }.not_to change { feedback.reload.content } }

        context 'after request' do
          before { call_request }

          it { should redirect_to user_feedbacks_path }
          it { expect(flash['alert']).to eq 'You cannot edit feedback created by someone else!' }
        end
      end
    end

    context 'not published' do
      let!(:feedback) { create(:feedback, giver: user_2, receiver: user, published: false, published_at: nil) }

      it { expect { call_request }.not_to change { feedback.reload.content } }

      context 'after request' do
        before { call_request }

        it { should redirect_to user_feedbacks_path }
        it { expect(flash['alert']).to eq 'You cannot edit feedback created by someone else!' }
      end
    end
  end

  describe '#create' do
    let(:call_request) { post :create, attributes }
    let!(:user_2) { create(:user, first_name: 'Steve', last_name: 'Rogers') }
    let!(:user_3) { create(:user, first_name: 'Natasha', last_name: 'Romanova') }
    before { create(:user, first_name: 'Bruce', last_name: 'Banner', archived: true) }

    context 'valid request' do
      let(:attributes) { {receiver_id: user_3.id, content: {bad: 'test bad', good: 'test good', future: ''}} }

      it { expect { call_request }.to change { Feedback.count }.from(0).to(2) }

      context 'after request' do
        before { call_request }

        it { should redirect_to new_user_feedback_path(receiver_id: user_2) }
      end
    end

    context 'invalid request' do
      let(:attributes) { {receiver_id: user.id, content: {bad: 'test bad', good: 'test good', future: ''}} }

      it { expect { call_request }.not_to change { Feedback.count } }

      context 'after request' do
        before { call_request }

        it { should redirect_to new_user_feedback_path(receiver_id: user_3) }
      end
    end
  end
end


