namespace :active_storage do
  desc "Purge all attachments still tied to local service"
  task purge_local: :environment do
    attachments = ActiveStorage::Attachment.joins(:blob)
      .where(active_storage_blobs: { service_name: "local" })
    puts "Found #{attachments.count} local attachments"
    attachments.find_each do |att|
      puts "Purging attachment #{att.id} (#{att.record_type} ##{att.record_id})"
      att.purge
    end
  end
end
