class RecurringBillJob < ApplicationJob
  queue_as :default

  # include Sidekiq::Worker

  # sidekiq_options retry: 3, queue: :default

  def perform
    RecurringBillRunner.run!
  end
end
