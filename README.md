# Introduction

This is a command-line application challenge takes in a users json file and a companies json file and aggregates the token balance for each company. The results are written to a generated file.

# Requirements

Ruby version 3.2 installed

The solution is built using ruby version 3.2.2 on windows.

# Design

The project is broken down to 6 ruby files in the 'lib' folder:

- company_summary.rb This is the core class that includes the business logic and generating the output file
- company.rb domain object class. It is mostly POCO and uses json_helper methods to assist instantiation from json
- user.rb is also a domain object class similar to company.rb
- json_helper.rb has a module that contains utility methods
- options.rb contains the parser for command line arguments
- runner.rb is the "main" method that executes using the parser from options

The 'spec' folder contains the tests using Rspec. If you have rspec installed via `gem install rspec` you can run the tests (all the tests in the spec folder):

```
> rspec --color spec
```

The wrapper script to run the CLI is in bin/challenge. The program loads both input files into memory and incrementally builds the resulting hash.

# How to Run

Go to the project root direction (i.e. cd /path/to/challenge). On windows, the Windows Terminal can be used.

```
> ruby -I lib ./bin/challenge -c ./path/to/companies.json -u ./path/to/users.json -o o
```

The 'data' folder contains sample input files.

```
> ruby -I lib ./bin/challenge -c ./data/companies.json -u ./data/users.json -o output.txt
```

# Caveats

If there are duplicate users in the input, they will be processed. See CompanySummary#append_user! method and the skipped test.
