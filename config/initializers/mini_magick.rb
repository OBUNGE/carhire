require "mini_magick"

MiniMagick.configure do |config|
  config.tmpdir = Rails.root.join("tmp", "mini_magick").to_s
end