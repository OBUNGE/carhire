require 'net/http'
require 'uri'
require 'json'
require 'securerandom'

class SupabaseStorageService
  def initialize
    @supabase_url = ENV['SUPABASE_URL']        # e.g. https://xyz.supabase.co
    @supabase_key = ENV['SUPABASE_KEY']
    @bucket = ENV['SUPABASE_BUCKET'] || 'car-images'
  end

  def upload(file)
    return nil unless file.present? && file.respond_to?(:original_filename)

    file_name = "#{SecureRandom.uuid}_#{file.original_filename}"
    uri = URI("#{@supabase_url}/storage/v1/object/#{@bucket}/#{file_name}")

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@supabase_key}"
    request['apikey'] = @supabase_key
    request['Content-Type'] = file.content_type
    request.body = file.tempfile.read

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      "#{@supabase_url}/storage/v1/object/public/#{@bucket}/#{file_name}"
    else
      Rails.logger.error("❌ Supabase upload failed: #{response.code} - #{response.body}")
      nil
    end
  rescue => e
    Rails.logger.error("🔥 Supabase upload exception: #{e.message}")
    nil
  end
end
