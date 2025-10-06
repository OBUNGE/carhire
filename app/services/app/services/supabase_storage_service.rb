# app/services/supabase_storage_service.rb
require "faraday"

class SupabaseStorageService
  def initialize
    @base_url = "#{ENV['SUPABASE_URL']}/storage/v1/object"
    @headers = {
      "Authorization" => "Bearer #{ENV['SUPABASE_KEY']}",
      "Content-Type" => "application/octet-stream"
    }
  end

  def upload(file, folder: "car-images")
    filename = "#{folder}/#{SecureRandom.uuid}-#{file.original_filename}"
    response = Faraday.put("#{@base_url}/#{filename}", file.read, @headers)

    if response.success?
      public_url(filename)
    else
      Rails.logger.error "Supabase upload failed: #{response.status} #{response.body}"
      nil
    end
  end

  private

  def public_url(path)
    "#{ENV['SUPABASE_URL']}/storage/v1/object/public/#{path}"
  end
end
