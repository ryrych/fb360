require 'rails_helper'

describe User do
  let!(:user) { create(:user, first_name: 'Steve', last_name: 'Rogers') }

  it 'has valid factory' do
    expect(build(:user)).to be_valid
  end

  describe '#full_name' do
    it 'returns full name' do
      expect(user.full_name).to eq 'Steve Rogers'
    end
  end

  describe '#to_s' do
    it 'returns full name' do
      expect(user.to_s).to eq 'Steve Rogers'
    end
  end

  context 'previous & next' do
    let!(:user_2) { create(:user, first_name: 'Natasha', last_name: 'Romanova') }
    let!(:user_3) { create(:user, first_name: 'Tony', last_name: 'Stark') }
    let!(:user_4) { create(:user, first_name: 'Bruce', last_name: 'Banner', archived: true) }

    describe '#next' do
      it 'returns next users, and if there is no next users then starts from the beginning (archived user is excluded)' do
        expect(user.next.to_s).to eq 'Tony Stark'
        expect(user_3.next.to_s).to eq 'Natasha Romanova'
        expect(user_2.next.to_s).to eq 'Steve Rogers'
      end
    end

    describe '#previous' do
      it 'returns previous users, and if there is no previous users then starts from the end (archived user is excluded)' do
        expect(user.previous.to_s).to eq 'Natasha Romanova'
        expect(user_3.previous.to_s).to eq 'Steve Rogers'
        expect(user_2.previous.to_s).to eq 'Tony Stark'
      end
    end
  end
end
