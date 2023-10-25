# frozen_string_literal: true

require_relative 'company'
require_relative 'user'

module Challenge
  class CompanySummary
    UserBalance = Struct.new(:user, :balance)
    attr_accessor :id, :name, :top_up, :email_status
    attr_reader :total, :users_emailed, :users_not_emailed

    def initialize(company)
      raise ArgumentError, "company: #{company} is invalid" unless Challenge::Company.valid?(company)

      @id = company.id
      @name = company.name
      @top_up = company.top_up
      @email_status = company.email_status
      @users_emailed = []
      @users_not_emailed = []
      @total = 0
    end

    private

    def user_already_exists?(id)
      users_not_emailed.find_index { |ub| ub.user.id == id } || users_emailed.find_index { |ub| ub.user.id == id }
    end

    def can_top_up?(user)
      user.company_id == @id && user.active_status
    end

    def can_email?(user)
      @email_status && user.email_status
    end

    def append_user!(user, email_arr)
      balance = user.tokens + @top_up
      user_balance = UserBalance.new(user, balance)
      # TODO: 
      # there is an issue on the test data for id: 33 where there are 2 users with the same id
      # unless user_already_exists?(user.id)
      #   email_arr << user_balance
      #   @total += @top_up
      # end
      email_arr << user_balance
      @total += @top_up
      self
    end

    public

    def add_user!(user)
      raise ArgumentError, "user: #{user} is invalid" unless Challenge::User.valid?(user)

      return unless can_top_up?(user)

      can_email?(user) ? append_user!(user, @users_emailed) : append_user!(user, @users_not_emailed)
    end

    def self.process(company_arr, user_arr)
      sorted_company_arr = company_arr.sort_by(&:id)
      summary_hash = sorted_company_arr.each_with_object({}) do |i, hash|
        hash[i.id] = Challenge::CompanySummary.new(i)
      end
      user_arr.each_with_object(summary_hash) do |u, hash|
        cs = hash[u.company_id]
        cs.add_user! u if cs
      end
    end

    def self.write_summary(company_arr, user_arr, &block)
      result = process(company_arr, user_arr)
      result.each(&block)
    end

    def self.print_summary(company_arr, user_arr, io = $stdout)
      write_summary(company_arr, user_arr) do |_, v|
        users_emailed = v.users_emailed.sort_by { |ub| ub.user.last_name }
        users_not_emailed = v.users_not_emailed.sort_by { |ub| ub.user.last_name }
        io.puts
        io.puts "\tCompany Id: #{v.id}"
        io.puts "\tCompany Name: #{v.name}"
        io.puts "\tUsers Emailed:"
        users_emailed.each do |ub|
          io.puts "\t\t#{ub.user.last_name}, #{ub.user.first_name}, #{ub.user.email}"
          io.puts "\t\t  Previous Token Balance, #{ub.user.tokens}"
          io.puts "\t\t  New Token Balance #{ub.balance}"
        end
        io.puts "\tUsers Not Emailed:"
        users_not_emailed.each do |ub|
          io.puts "\t\t#{ub.user.last_name}, #{ub.user.first_name}, #{ub.user.email}"
          io.puts "\t\t  Previous Token Balance, #{ub.user.tokens}"
          io.puts "\t\t  New Token Balance #{ub.balance}"
        end
        io.puts "\t\tTotal amount of top ups for #{v.name}: #{v.total}"
      end
      nil
    end

    def self.print_summary_to_file(company_arr, user_arr, output_file_path)
      File.open(output_file_path, 'w') do |f|
        print_summary(company_arr, user_arr, f)
      end
      true
    end
  end
end
