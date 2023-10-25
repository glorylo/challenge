# frozen_string_literal: true

require 'optparse'

module Challenge
  # Options parser for command-line arguments
  class Options
    attr_reader :user_file_path, :company_file_path, :output_file_path

    def initialize(argv)
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.on('-c', '--companies-file <companies-file-path>', String, 'Path to companies file in json format') do |v|
          @company_file_path = v
        end

        opts.on('-u', '--users-file <users-file-path>', String, 'Path to users file in json format') do |v|
          @user_file_path = v
        end

        opts.on('-o', '--output-file <output-file-path>', String, 'Path to generated file') do |v|
          @output_file_path = v
        end

        opts.on('-h', '--help', 'Show this help message') do
          puts opts
          exit
        end

        begin
          argv = ['-h'] if argv.empty?
          opts.parse!(argv)

          if @company_file_path.nil? || @user_file_path.nil? || @output_file_path.nil?
            raise OptionParser::ParseError, 'Required arguments for -c, -u and -o'
          end
        rescue OptionParser::ParseError => e
          warn e.message, "\n", opts
          exit(-1)
        end
      end
    end
  end
end
