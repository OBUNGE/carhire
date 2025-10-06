require 'supabase'

class SupabaseStorageService
  def initialize
    @supabase_url = ENV['SUPABASE_URL']
    @supabase_key = ENV['SUPABASE_KEY']
    @bucket = ENV['SUPABASE_BUCKET'] || 'car-images'
    @client = Supabase::Client.new(@supabase_url, @supabase_key)
  end

  def upload(file)
    # 🧠 Skip if file is empty or not an uploaded file object
    return nil unless file.present? && file.respond_to?(:original_filename)

    file_name = "#{SecureRandom.uuid}_#{file.original_filename}"

    response = @client.storage.from(@bucket).upload(file_name, file.tempfile)

    if response.error
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
