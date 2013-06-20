def job_is_complete(jid)
  waiting = Sidekiq::Queue.new
  working = Sidekiq::Workers.new
  pending = Sidekiq::ScheduledSet.new
  return "pending" if pending.find { |job| job.jid == jid }
  return "pending" if waiting.find { |job| job.jid == jid }
  return "pending" if working.find { |worker, info| info["payload"]["jid"] == jid }
  "success"
end
