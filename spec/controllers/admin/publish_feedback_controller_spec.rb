require 'rails_helper'

describe Admin::PublishFeedbackController do
  render_views
  include_context 'admin signed in'

  describe '#show' do
    let(:call_request) { get :show }

    it 'renders show' do
      expect(call_request).to render_template 'show'
    end
  end

  describe '#update' do
    let(:call_request) { put :update }

    it 'redirects to admin_publish_feedback_path' do
      expect(call_request).to redirect_to admin_publish_feedback_path
    end

    it 'publish feedback' do
      expect(Feedback).to receive(:publish_all)
      call_request
    end
  end
end
