require 'rails_helper'

describe HomeController do
  render_views

  describe '#show' do
    let(:call_request) { get :show }

    context 'user not signed in' do
      it 'renders show' do
        expect(call_request).to render_template 'show'
      end
    end

    context 'user signed in' do
      include_context 'user signed in'

      it 'renders show' do
        expect(call_request).to render_template 'show'
      end
    end
  end
end
