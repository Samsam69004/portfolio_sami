ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    # Charge toutes les fixtures
    fixtures :all

    # >>> Ajouts pour tester emails/jobs <<<
    require "active_job/test_helper"
    require "action_mailer/test_helper"
    include ActiveJob::TestHelper
    include ActionMailer::TestHelper
  end
end
