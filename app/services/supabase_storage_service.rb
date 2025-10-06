require 'supabase'
require 'securerandom'

class SupabaseStorageService
  def initialize
    @supabase_url  = ENV['SUPABASE_URL']
    @supabase_key  = ENV['SUPABASE_KEY']
    @bucket        = ENV['SUPABASE_BUCKET'] || 'car-images'

    # ✅ Correct client initialization (for Supabase v0.1.0+)
    @client = Supabase::Client.new do |config|
      config.url = @supabase_url
      config.api_key = @supabase_key
    end
  end

  def upload(file)
    # 🧠 Skip if file is empty or not an uploaded file object
    return nil unless file.present? && file.respond_to?(:original_filename)

    # Generate a unique file name
    file_name = "#{SecureRandom.uuid}_#{file.original_filename}"

    # Upload the file to the specified bucket
    response = @client.storage.from(@bucket).upload(file_name, file.tempfile)

    # Check for upload errors
    if response.error
      Rails.logger.error("❌ Supabase upload failed: #{response.error.message}")
      nil
    else
      # Return the public URL of the uploaded image
      "#{@supabase_url}/storage/v1/object/public/#{@bucket}/#{file_name}"
    end
  rescue => e
    # Log any unexpected exceptions
    Rails.logger.error("🔥 Supabase upload exception: #{e.message}")
    nil
  end
end
