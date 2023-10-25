require_relative "../lib/challenge/company_summary"

describe Challenge::CompanySummary, "#initialize" do
  context "Create a company summary with given company argument" do
    it "instantiates successfully" do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: true })
      actual = Challenge::CompanySummary.new(company)
      expect(actual).to_not be_nil
      expect(actual.id).to be 1
      expect(actual.name).to eq "Blue Cat Inc."
      expect(actual.top_up).to be 23
      expect(actual.users_emailed).to eq []
      expect(actual.users_not_emailed).to eq []
      expect(actual.total).to be 0
    end
  end
end

describe Challenge::CompanySummary, "#add_user!" do
  context "Add a user to the company user and update the emailed user lists and totals" do
    it "update email lists and total correctly with company email_status is true" do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: true })
      company_summary = Challenge::CompanySummary.new(company)
      user = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                   email: "edgar.simpson@notreal.com", company_id: 1, email_status: true, active_status: true, tokens: 67 })
      user2 = Challenge::User.new({ id: 14, first_name: "Tommy", last_name: "Simpson",
                                    email: "tommy.simpson@notreal.com", company_id: 1, email_status: false, active_status: true, tokens: 10 })
      company_summary.add_user!(user)
      company_summary.add_user!(user2)
      expect(company_summary.users_emailed.size).to eq 1
      expect(company_summary.users_not_emailed.size).to eq 1
      expect(company_summary.users_emailed[0].balance).to eq 90
      expect(company_summary.users_not_emailed[0].balance).to eq 33
      expect(company_summary.total).to eq 46
    end

    it "update email lists and total correctly with company email_status is false" do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: false })
      company_summary = Challenge::CompanySummary.new(company)
      user = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                   email: "edgar.simpson@notreal.com", company_id: 1, email_status: true, active_status: true, tokens: 67 })
      user2 = Challenge::User.new({ id: 14, first_name: "Tommy", last_name: "Simpson",
                                    email: "tommy.simpson@notreal.com", company_id: 1, email_status: false, active_status: true, tokens: 10 })
      company_summary.add_user!(user)
      company_summary.add_user!(user2)
      expect(company_summary.users_emailed.size).to eq 0
      expect(company_summary.users_not_emailed.size).to eq 2
      expect(company_summary.users_not_emailed[0].balance).to eq 90
      expect(company_summary.users_not_emailed[1].balance).to eq 33
      expect(company_summary.total).to eq 46
    end

    # TODO: double check to see if id shoudl be unique or be allowed to be added multiple times
    it "will skip adding user if the user has already been added", skip: true do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: true })
      company_summary = Challenge::CompanySummary.new(company)
      user = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                   email: "edgar.simpson@notreal.com", company_id: 1, email_status: true, active_status: true, tokens: 67 })
      user2 = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                    email: "edgar.simpson@notreal.com", company_id: 1, email_status: true, active_status: true, tokens: 67 })
      company_summary.add_user!(user)
      company_summary.add_user!(user2)
      expect(company_summary.users_emailed.size).to eq 1
      expect(company_summary.users_not_emailed.size).to eq 0
      expect(company_summary.users_emailed[0].balance).to eq 90
      expect(company_summary.total).to eq 23
    end

    it "should not update nor top up when the company ids do not match" do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: true })
      company_summary = Challenge::CompanySummary.new(company)
      user = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                   email: "edgar.simpson@notreal.com", company_id: 10, email_status: true, active_status: true, tokens: 67 })
      user2 = Challenge::User.new({ id: 14, first_name: "Tommy", last_name: "Simpson",
                                    email: "tommy.simpson@notreal.com", company_id: 10, email_status: false, active_status: true, tokens: 10 })
      company_summary.add_user!(user)
      company_summary.add_user!(user2)
      expect(company_summary.users_emailed.size).to eq 0
      expect(company_summary.users_not_emailed.size).to eq 0
      expect(company_summary.total).to eq 0
    end

    it "should not update when the user active_status is false" do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: true })
      company_summary = Challenge::CompanySummary.new(company)
      user = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                   email: "edgar.simpson@notreal.com", company_id: 10, email_status: true, active_status: false, tokens: 67 })
      company_summary.add_user!(user)
      expect(company_summary.users_emailed.size).to eq 0
      expect(company_summary.users_not_emailed.size).to eq 0
      expect(company_summary.total).to eq 0
    end
  end
end

describe Challenge::CompanySummary, "#process" do
  context "Processes the users and companies array and returns a hashed CompanySummary" do
    it "produces the correct result" do
      company = Challenge::Company.new({ id: 1, name: "Blue Cat Inc.", top_up: 23, email_status: true })

      user = Challenge::User.new({ id: 17, first_name: "Edgar", last_name: "Simpson",
                                   email: "edgar.simpson@notreal.com", company_id: 1, email_status: true, active_status: true, tokens: 67 })
      user2 = Challenge::User.new({ id: 14, first_name: "Tommy", last_name: "Simpson",
                                    email: "tommy.simpson@notreal.com", company_id: 1, email_status: false, active_status: true, tokens: 10 })
      users = [user, user2]
      companies = [company]
      actual = Challenge::CompanySummary.process(companies, users)
      expect(actual.size).to eq 1
      cs = actual.first[1]
      expect(cs.id).to be 1
      expect(cs.name).to eq "Blue Cat Inc."
      expect(cs.top_up).to be 23
      expect(cs.users_emailed.size).to eq 1
      expect(cs.users_emailed[0].user.id).to eq 17
      expect(cs.users_emailed[0].user.first_name).to eq "Edgar"
      expect(cs.users_emailed[0].user.last_name).to eq "Simpson"
      expect(cs.users_emailed[0].user.tokens).to eq 67
      expect(cs.users_emailed[0].balance).to eq 90
      expect(cs.users_not_emailed.size).to eq 1
      expect(cs.users_not_emailed[0].user.id).to eq 14
      expect(cs.users_not_emailed[0].user.first_name).to eq "Tommy"
      expect(cs.users_not_emailed[0].user.last_name).to eq "Simpson"
      expect(cs.users_not_emailed[0].user.tokens).to eq 10
      expect(cs.users_not_emailed[0].balance).to eq 33
      expect(cs.total).to be 46
    end
  end
end

# TODO: create test for #print_summary
