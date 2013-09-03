
# Gems
# ==================================================
gem_group :development do
  # Rspec for tests (https://github.com/rspec/rspec-rails)
  gem "rspec-rails", "~> 2.14.0"
  gem "factory_girl_rails", "~> 4.2.1"
end

gem_group :test do
  gem "rspec-rails", "~> 2.14.0"
  gem "factory_girl_rails", "~> 4.2.1"
  # Capybara for integration testing (https://github.com/jnicklas/capybara)
  gem "faker", "~> 1.1.2"
  gem "capybara", "~> 2.1.0"
  gem "database_cleaner", "~> 1.0.1"
  gem "launchy", "~> 2.3.0"
  gem "selenium-webdriver", "~> 2.35.1"
end

run "bundle install"

# Create databases
# ===================================================
run "bundle exec rake db:create:all"

# add a schema to the test database
run "rake db:test:clone"


# rspec install
# ===================================================
run "bundle exec rails generate rspec:install"


# Edit the .rspec file
# ===================================================
run "echo '--format documentation' >>  .rspec"


# edit config/application.rb in order to tell Rails to generate spec files for you
# ================================================================================
if yes?("Want to manually specify generators? (y or n?)")
  run "sed -i '' -e $'15 a\\\n\\\s''  # start manual config generators' config/application.rb"
  run "sed -i '' -e $'16 a\\\n\\\s''    config.generators do |g|' config/application.rb"
  run "sed -i '' -e $'17 a\\\n\\\s''      g.test_framework :rspec,' config/application.rb"
  run "sed -i '' -e $'18 a\\\n\\\s''        fixtures: true,' config/application.rb"
  run "sed -i '' -e $'19 a\\\n\\\s''        view_specs: false,' config/application.rb"
  run "sed -i '' -e $'20 a\\\n\\\s''        helper_specs: false,' config/application.rb"
  run "sed -i '' -e $'21 a\\\n\\\s''        routing_specs: false,' config/application.rb"
  run "sed -i '' -e $'22 a\\\n\\\s''        controller_specs: true,' config/application.rb"
  run "sed -i '' -e $'23 a\\\n\\\s''        request_specs: false' config/application.rb"
  run "sed -i '' -e $'24 a\\\n\\\s''      g.fixture_replacement :factory_girl, dir: \"spec/factories\"' config/application.rb"
  run "sed -i '' -e $'25 a\\\n\\\s''    end' config/application.rb"
  run "sed -i '' -e $'26 a\\\n\\\s''  # end manual config generators' config/application.rb"
end


# An augmented .gitignore file according to http://ruby.railstutorial.org/ruby-on-rails-tutorial-book by Michael Hartl
# ===================================================
run "cat << EOF >> .gitignore
# Ignore bundler config.
/.bundle

# Ignore the default SQLite database.
/db/*.sqlite3
/db/*.sqlite3-journal

# Ignore all logfiles and tempfiles.
/log/*.log
/tmp

# Ignore other unneeded files.
database.yml
doc/
*.swp
*~
.project
.DS_Store
.idea
.secret
EOF"


# Git: Initialize
# ==================================================
git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }

