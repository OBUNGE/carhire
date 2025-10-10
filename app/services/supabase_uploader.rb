# app/services/supabase_uploader.rb
require 'supabase'

class SupabaseUploader
  def initialize
    @client = Supabase::Client.new(
      supabase_url: ENV['SUPABASE_URL'],
      supabase_key: ENV['SUPABASE_SERVICE_ROLE_KEY']
    )
  end

  def upload(file, path:)
    # Upload the file to the bucket
    response = @client.storage
                      .from('carhirehub')
                      .upload(path, file.tempfile, content_type: file.content_type)

    if response.error
      Rails.logger.error("Supabase upload failed: #{response.error}")
      return nil
    end

    # Get the public URL
    public_url = @client.storage
                        .from('carhirehub')
                        .get_public_url(path)
                        .data['publicUrl']

    public_url
  end
end
