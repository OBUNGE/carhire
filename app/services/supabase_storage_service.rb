require 'net/http'
require 'uri'
require 'json'
require 'securerandom'

class SupabaseStorageService
  def initialize
    @supabase_url = ENV['SUPABASE_URL']        # e.g. https://xyzcompany.supabase.co
    @supabase_key = ENV['SUPABASE_KEY']
    @bucket = ENV['SUPABASE_BUCKET'] || 'carhirehub'
  end

  def upload(file)
    return nil unless file.present? && file.respond_to?(:original_filename)

    file_name = "#{SecureRandom.uuid}_#{sanitize_filename(file.original_filename)}"
    uri = URI("#{@supabase_url}/storage/v1/object/#{@bucket}/#{file_name}")

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@supabase_key}"
    request['apikey'] = @supabase_key
    request['Content-Type'] = file.content_type
    request.body = File.read(file.tempfile)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      # Supabase makes public assets available at /object/public/
      "#{@supabase_url}/storage/v1/object/public/#{@bucket}/#{file_name}"
    else
      Rails.logger.error("❌ Supabase upload failed: #{response.code} - #{response.body}")
      nil
    end
  rescue => e
    Rails.logger.error("🔥 Supabase upload exception: #{e.message}")
    nil
  end

  private

  def sanitize_filename(filename)
    filename.gsub(/[^0-9A-Za-z.\-]/, '_')
  end
end
