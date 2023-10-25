# frozen_string_literal: true

require_relative 'options'
require_relative 'company_summary'
require_relative 'user'
require_relative 'company'

module Challenge
  # Runner for the command-line applicaton.  Requires -u (user's file), -c (company's file)
  # and -o the output file path to be generated.  The input files must be in json format as an array 
  # of objects for the content.  The report will sum up the balance per user and calculating the new 
  # balance.  
  class Runner
    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
      begin
        user_data = Challenge::User.load_from_file @options.user_file_path
        company_data = Challenge::Company.load_from_file @options.company_file_path
        Challenge::CompanySummary.print_summary_to_file(company_data, user_data, @options.output_file_path)
      rescue StandardError => e
        warn e.message, "\n"
        exit(-1)
      end
      puts "Created report: #{@options.output_file_path}"
      exit 0
    end
  end
end
