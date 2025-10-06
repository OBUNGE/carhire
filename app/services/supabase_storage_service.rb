require 'supabase'
require 'securerandom'

class SupabaseStorageService
  def initialize
    @supabase_url = ENV['SUPABASE_URL']
    @supabase_key = ENV['SUPABASE_KEY']
    @bucket = ENV['SUPABASE_BUCKET'] || 'car-images'

    # ✅ Correct initialization for the current Supabase gem
    @client = Supabase::Client.new(url: @supabase_url, key: @supabase_key)
  end

  def upload(file)
    return nil unless file.present? && file.respond_to?(:original_filename)

    file_name = "#{SecureRandom.uuid}_#{file.original_filename}"

    # ✅ Upload file to the Supabase storage bucket
    response = @client.storage.from(@bucket).upload(file_name, file.tempfile)

    # ✅ Handle upload response
    if response.respond_to?(:error) && response.error
      Rails.logger.error("❌ Supabase upload failed: #{response.error.message}")
      nil
    else
      "#{@supabase_url}/storage/v1/object/public/#{@bucket}/#{file_name}"
    end
  rescue => e
    Rails.logger.error("🔥 Supabase upload exception: #{e.message}")
    nil
  end
end
