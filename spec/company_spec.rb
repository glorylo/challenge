require_relative '../lib/challenge/company'

describe Challenge::Company, '#load_from_file' do
  context 'Take in a companies file in json' do
    it 'loads the file successfully' do
      actual = Challenge::Company.load_from_file('./spec/testdata/valid_companies.json')
      expect(actual).to_not be_nil
      expect(actual.size).to be(1)
      c = actual.first
      expect(c.id).to be 1
      expect(c.name).to eq 'Blue Cat Inc.'
      expect(c.top_up).to be 71
      expect(c.email_status).to be false
    end
  end
end
