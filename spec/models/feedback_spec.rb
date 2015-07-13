require 'rails_helper'

describe Feedback do
  it 'has valid factory' do
    expect(build(:feedback)).to be_valid
  end

  describe '#save' do
    context 'giver is the same as receiver' do
      let(:user) { create(:user) }
      let(:feedback) { build(:feedback, giver: user, receiver: user) }

      it 'cannot save feedback when ' do
        expect(feedback).not_to be_valid
      end
    end
  end

  describe '.publish_all' do
    let!(:feedback) { create(:feedback, published: false) }
    let!(:feedback_2) { create(:feedback, published: false) }
    let!(:feedback_3) { create(:feedback, published: true, published_at: '2015-01-01') }
    let(:perform) { described_class.publish_all }

    it 'makes all feedback published' do
      expect(feedback.reload.published).to be false
      expect(feedback_2.reload.published).to be false
      perform
      expect(feedback.reload.published).to be true
      expect(feedback_2.reload.published).to be true
    end

    it 'change published_at for previously not published feedback' do
      expect { perform }.to change { feedback_2.reload.published_at }.from(nil).to(Date.today)
    end

    it 'does not change published_at for previously published feedback' do
      expect { perform }.not_to change { feedback_3.reload.published_at }
    end
  end

  describe '.feedback_types_for_select' do
    it 'returns all types' do
      expect(described_class.feedback_types_for_select).to eq [['Improve it', 'bad'],
                                                               ['Keep it up', 'good'],
                                                               ['Start it', 'future']]
    end
  end

  describe '#tr_class' do
    it 'return "success" for good feedback' do
      expect(create(:good_feedback).tr_class).to eq 'success'
    end

    it 'return "orange" for bad feedback' do
      expect(create(:bad_feedback).tr_class).to eq 'orange'
    end

    it 'return "info" for future feedback' do
      expect(create(:future_feedback).tr_class).to eq 'info'
    end
  end
end
