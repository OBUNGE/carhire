# lib/tasks/cleanup.rake
namespace :active_storage do
  desc "Purge all blobs still tied to local service"
  task purge_local: :environment do
    ActiveStorage::Attachment.joins(:blob)
      .where(active_storage_blobs: { service_name: "local" })
      .find_each(&:purge)
  end
end
