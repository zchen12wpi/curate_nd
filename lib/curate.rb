require 'sufia/models'
require 'chronic'
require "curate/active_model_adaptor"
require "curate/configuration"
require "curate/date_formatter"
require "curate/text_formatter"
require 'simple_form'
require 'bootstrap-datepicker-rails'
require 'hydra-batch-edit'
require 'active_fedora/registered_attributes'
require 'hydra/remote_identifier'
require 'inline_reflection'
require 'contributors_association'
require 'rails_autolink'
require 'select2-rails'
require 'curate/migration_services'
require 'qa'

module Curate
  extend ActiveSupport::Autoload
  autoload :Ability

  delegate :application_root_url, to: :configuration

  module_function
  def permanent_url_for(object)
    File.join(Curate.configuration.application_root_url, 'show', object.noid)
  end

end
