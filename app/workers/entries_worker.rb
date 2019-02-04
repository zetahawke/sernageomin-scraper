class EntriesWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1,
                         backtrace: 5,
                         dead: false

  def perform(args)
    args = args.with_indifferent_access
    puts args
    sm = Sernageomin.new(args[:url])
    sm.scrap(args[:region], args[:page])
  rescue => e
    Sidekiq::Queue.new().clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
  end
end