source 'https://rubygems.org'

# This should be everything except :deploy; And by default, we mean any of
# the environments that are not used to execute the deploy scripts
group :default do
  gem 'mysql2'
  gem "rails", "~>4.0.2"
  gem "breach-mitigation-rails"
  gem 'sufia-models', '~>3.4.0'
  gem 'hydra-file_characterization', ">= 0.2.3"
  gem 'hydra-batch-edit', '~> 1.1.1'
  gem 'hydra-collections', '~> 1.3.0'
  gem 'mini_magick', '~> 3.8'
  gem 'simple_form', '~> 3.0.1'
  gem 'active_attr'
  gem 'browser'
  gem 'breadcrumbs_on_rails'
  gem 'active_fedora-registered_attributes', '~> 0.2.0'
  gem 'hydra-remote_identifier', '~> 0.6', '>= 0.6.7'
  gem 'hydra-derivatives', '~> 0.0.7'
  gem 'chronic', '>= 0.10.2'
  gem 'virtus'
  gem 'rails_autolink'
  gem 'rdiscount', '~> 2.1.7.1'
  gem 'rubydora', '~> 1.7.4'
  gem 'sanitize', '~> 3.0.2'
  gem 'select2-rails'
  gem 'httparty'
  gem 'qa'
  gem 'kaminari', github: 'harai/kaminari', branch: 'route_prefix_prototype'
  # gem 'active-fedora', github: 'jeremyf/active_fedora', branch: 'fixing-rdf-datastream-encoding'
  gem 'orcid', github: 'projecthydra-labs/orcid'
  gem 'devise-multi_auth', github: 'jeremyf/devise-multi_auth'
  gem 'nokogiri', "~>1.6.0"
  gem 'jettywrapper'
  gem 'jquery-rails'
  gem 'decent_exposure'
  gem 'devise_cas_authenticatable'
  gem 'devise_masquerade'
  gem 'rake'
  gem 'resque-pool'
  gem 'morphine'
  gem "unicode", :platforms => [:mri_18, :mri_19]
  gem "devise", "~>3.2.2"
  gem "devise-guests", "~> 0.3"
  # Need rubyracer to run integration tests.....really?!?
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'libv8', '3.16.14.3'
  gem 'therubyracer', '0.12.1', platforms: :ruby, require: 'v8'
  gem 'bootstrap-datepicker-rails'
  gem 'namae'
  gem 'unicorn', '~> 4.0'
  gem 'net-ldap'
  gem 'custom_configuration'
  gem 'noids_client', git: 'git://github.com/ndlib/noids_client'
  gem 'harbinger', git: 'git://github.com/ndlib/harbinger'
  gem 'newrelic_rpm'
  gem 'flipper'
  gem 'roboto'
  gem 'jshintrb'
  gem 'lograge'
  gem 'logstash-logger'
  gem 'logstash-event'
  gem 'citeproc-ruby', '~> 1.1'
  gem 'csl-styles', '~> 1.0'
  gem 'locabulary', github: 'ndlib/locabulary', branch: 'master', ref: '69ec6264ca8246d2f9809afc0fe83155116a1fa1'
end

# Hack to work around some bundler strangeness
#
# This gem was appearing in the lock file, but was not
# being listed in a `bundle list` command on the staging machine.
# Explicitly require it here.
gem 'addressable', '~> 2.3.5'

group :headless do
  gem 'clamav'
end

gem 'coffee-rails', '~> 4.0'
gem 'compass-rails', '~> 1.1.2'
gem 'sass-rails',   '~> 4.0'
gem 'uglifier', '>= 1.0.3'

group :test do
  gem 'capybara', "~> 2.4"
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~>4.2.0'
  gem 'rspec-html-matchers', '~>0.6'
  gem 'rspec-rails', '~>3.0'
  gem 'rspec-its', '~> 1.0'
  gem 'vcr'
  gem 'webmock'
  gem 'timecop'
  gem 'poltergeist', '~> 1.5'
  gem 'test_after_commit'
end

group :debug do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms => [:mri_19, :mri_20, :rbx]
  gem 'rails_best_practices'
  gem 'sextant'
  gem 'simplecov'
  gem 'method_locator'
  gem 'byebug'
  gem 'thin'
end

group :deploy do
  gem 'capistrano', '~> 2.15'
end

group :development do
  gem 'meta_request'
end
