require_relative '../lib/challenge/options'

describe Challenge::Options, '#new' do
  context 'for the summary report, take in a companies file in json' do
    it 'should parse -u users.json -c companies.json and -o output.txt' do
      o = Challenge::Options.new(['-c', 'company.json', '-u', 'users.json', '-o', 'output.txt'])
      expect(o.company_file_path).to eq 'company.json'
      expect(o.user_file_path).to eq 'users.json'
      expect(o.output_file_path).to eq 'output.txt'
    end

    it 'missing required arguments, output-file, should exit' do
      expect { Challenge::Options.new(['-c', 'company.json', '-u', 'users.json']) }.to raise_error(SystemExit)
    end

    it 'missing required arguments, company-file, should exit' do
      expect { Challenge::Options.new(['-o', 'output.txt', '-u', 'users.json']) }.to raise_error(SystemExit)
    end

    it 'missing required arguments, users-file, should exit' do
      expect { Challenge::Options.new(['-o', 'output.txt', '-c', 'company.json']) }.to raise_error(SystemExit)
    end
  end
end
