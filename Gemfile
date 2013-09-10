source 'https://rubygems.org'

# This should be everything except :deploy; And by default, we mean any of
# the environments that are not used to execute the deploy scripts
group :default do
  gem 'mysql2'
  gem 'hydra-derivatives', git:"git://github.com/projecthydra/hydra-derivatives", branch: 'e2a6540044e5bb3045016646663f70a9d627c0aa'
  # gem 'curate', git: 'git://github.com/ndlib/curate.git', branch: 'master'
  gem 'sufia-models', git: 'git://github.com/projecthydra/sufia.git', ref: 'b97d8e8970278fad3dc87da265e76f6dc328a580'
  gem 'curate', git: 'git://github.com/ndlib/curate.git', ref: 'a18b8f0270eb1faff3484c5e7b97d80a757d3053'
  gem 'rsolr'
  gem 'nokogiri', "~>1.6.0"
  gem 'jettywrapper'
  gem 'jquery-rails'
  gem 'decent_exposure'
  gem 'devise_cas_authenticatable'
  gem 'rake'
  gem 'resque-pool'
  gem 'morphine'
  gem "unicode", :platforms => [:mri_18, :mri_19]
  gem "devise", "~>3.0.3"
  gem "devise-guests", "~> 0.3"
  # Need rubyracer to run integration tests.....really?!?
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'bootstrap-datepicker-rails'
  gem 'namae'
  gem 'unicorn', '~> 4.0'
  gem 'net-ldap'
  gem 'method_decorators'
end

# Hack to work around some bundler strangeness
#
# This gem was appearing in the lock file, but was not
# being listed in a `bundle list` command on the staging machine.
# Explicitly require it here.
gem 'addressable', '~> 2.3.5'

group :pre_production, :production do
  gem "sentry-raven"
end

group :headless do
  gem 'clamav'
end

gem 'bootstrap-sass', '~> 2.2.0'
gem 'coffee-rails', '~> 4.0'
gem 'compass-rails', '~> 2.0.alpha.0'
gem 'sass-rails',   '~> 4.0'
gem 'uglifier', '>= 1.0.3'

group :test do
  gem 'capybara', "~> 2.1"
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'webmock'
  gem 'timecop'
  gem 'poltergeist'
  gem 'test_after_commit', :group => :test
end

group :debug do
  gem 'debugger', ">= 1.4"
  gem 'rails_best_practices'
  gem 'sextant'
  gem 'simplecov'
  gem 'method_locator'
end

group :deploy do
  gem 'capistrano'
end
