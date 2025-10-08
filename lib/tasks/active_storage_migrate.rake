# lib/tasks/active_storage_migrate.rake
namespace :active_storage do
  desc "Migrate ActiveStorage blobs from local to Supabase"
  task migrate_to_supabase: :environment do
    puts "🚀 Starting migration of ActiveStorage blobs from local → supabase..."

    ActiveStorage::Attachment.find_each do |attachment|
      blob = attachment.blob

      # Only migrate blobs stored in local
      next unless blob.service_name == "local"

      begin
        puts "Migrating blob ##{blob.id} (#{blob.filename})..."

        # Download from local and re-attach to supabase
        blob.open do |file|
          attachment.record.send(attachment.name).attach(
            io: file,
            filename: blob.filename,
            content_type: blob.content_type
          )
        end

        # Destroy the old blob (optional — comment out if you want to keep both)
        blob.destroy

      rescue => e
        puts "⚠️ Failed to migrate blob ##{blob.id}: #{e.message}"
      end
    end

    puts "✅ Migration complete!"
  end
end
