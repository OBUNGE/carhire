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

def upload(file)
  # Skip if file is blank or not an uploaded file
  return nil if file.blank? || !file.respond_to?(:original_filename)

  file_name = "#{SecureRandom.uuid}_#{file.original_filename}"
  response = @client.storage.from(@bucket).upload(file_name, file.tempfile)

  if response.error
    Rails.logger.error("Supabase upload error: #{response.error.message}")
    nil
  else
    "#{@supabase_url}/storage/v1/object/public/#{@bucket}/#{file_name}"
  end
end


  private

  def public_url(path)
    "#{ENV['SUPABASE_URL']}/storage/v1/object/public/#{path}"
  end
end
