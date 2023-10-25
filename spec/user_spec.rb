require_relative '../lib/challenge/user'

describe Challenge::User, '#load_from_file' do
  context 'Takes in a users json file' do
    it 'loads the file successfully' do
      actual = Challenge::User.load_from_file('./spec/testdata/valid_users.json')
      expect(actual).to_not be_nil
      expect(actual.size).to be(1)
      u = actual.first
      expect(u.id).to be 1
      expect(u.first_name).to eq 'Tanya'
      expect(u.last_name).to eq 'Nichols'
      expect(u.email).to eq 'tanya.nichols@test.com'
      expect(u.company_id).to be 2
      expect(u.email_status).to be true
      expect(u.active_status).to be false
      expect(u.tokens).to be 23
    end
  end
end
