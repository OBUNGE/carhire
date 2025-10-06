require 'supabase'
require 'securerandom'

class SupabaseStorageService
  def initialize
    @supabase_url = ENV['SUPABASE_URL']           # e.g., https://xyz.supabase.co
    @supabase_key = ENV['SUPABASE_KEY']           # Your Supabase anon/public key
    @bucket = ENV['SUPABASE_BUCKET'] || 'car-images'

    # ❌ Older gem does NOT accept arguments
    @client = Supabase::Client.new
  end

  def upload(file)
    return nil unless file.present? && file.respond_to?(:original_filename)

    file_name = "#{SecureRandom.uuid}_#{file.original_filename}"

    # ✅ Upload with API key in headers (gem 0.1.0 requirement)
    response = @client.storage.from(@bucket).upload(
      file_name,
      file.tempfile,
      headers: { "apikey" => @supabase_key }
    )

    if response.respond_to?(:error) && response.error
      Rails.logger.error("❌ Supabase upload failed: #{response.error.message}")
      nil
    else
      # Return public URL
      "#{@supabase_url}/storage/v1/object/public/#{@bucket}/#{file_name}"
    end
  rescue => e
    Rails.logger.error("🔥 Supabase upload exception: #{e.message}")
    nil
  end
end
