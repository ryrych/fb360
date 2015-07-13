require 'spec_helper'

describe FeedbackCreator do
  let!(:giver) { create(:user) }
  let!(:receiver) { create(:user) }

  describe '#perform' do
    let(:perform) { described_class.new(giver, params).perform }

    context 'good params' do
      context 'all feedback types' do
        let(:params) do
          {receiver_id: receiver.id, content: {bad: 'test bad', good: 'test good', future: 'test future'}}
        end

        it 'creates 3 feedbacks with correct params' do
          expect { perform }.to change { Feedback.count }.from(0).to(3)
          feedbacks = Feedback.all
          expect(feedbacks.map(&:receiver_id)).to eq [receiver.id]*3
          expect(feedbacks.map(&:giver_id)).to eq [giver.id]*3
          expect(feedbacks.map(&:published)).to eq [false]*3
          expect(feedbacks.map(&:published_at)).to eq [nil]*3
          expect(Feedback.find_by(feedback_type: 'good').content).to eq 'test good'
          expect(Feedback.find_by(feedback_type: 'bad').content).to eq 'test bad'
          expect(Feedback.find_by(feedback_type: 'future').content).to eq 'test future'
        end
      end

      context 'only good and bad feedback' do
        let(:params) do
          {receiver_id: receiver.id, content: {bad: 'test bad', good: 'test good', future: ''}}
        end

        it 'creates 2 feedbacks with correct params' do
          expect { perform }.to change { Feedback.count }.from(0).to(2)
          feedbacks = Feedback.all
          expect(feedbacks.map(&:receiver_id)).to eq [receiver.id]*2
          expect(feedbacks.map(&:giver_id)).to eq [giver.id]*2
          expect(feedbacks.map(&:published)).to eq [false]*2
          expect(feedbacks.map(&:published_at)).to eq [nil]*2
          expect(Feedback.find_by(feedback_type: 'good').content).to eq 'test good'
          expect(Feedback.find_by(feedback_type: 'bad').content).to eq 'test bad'
        end
      end

      context 'all future feedback' do
        let(:params) do
          {receiver_id: receiver.id, content: {bad: '', good: ' ', future: 'test future'}}
        end

        it 'creates 1 feedback with correct params' do
          expect { perform }.to change { Feedback.count }.from(0).to(1)
          feedback = Feedback.first
          expect(feedback.receiver_id).to eq receiver.id
          expect(feedback.giver_id).to eq giver.id
          expect(feedback.published).to eq false
          expect(feedback.published_at).to eq nil
          expect(feedback.feedback_type).to eq 'future'
          expect(feedback.content).to eq 'test future'
        end
      end
    end

    context 'bad params' do
      context 'receiver_id is missing' do
        let(:params) { {content: {bad: '', good: '', future: 'test future'}} }

        it 'raises error' do
          expect { perform }.to raise_error(KeyError, 'key not found: "receiver_id"')
        end
      end

      context 'content is missing' do
        let(:params) { {receiver_id: receiver.id} }

        it 'raises error' do
          expect { perform }.to raise_error(KeyError, 'key not found: "content"')
        end
      end
    end
  end
end
