class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::ImageOptimizer
  include CarrierWave::MiniMagick

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

  process resize_to_limit: [1920, nil]

  after :store, :delete_old_tmp_file

  version :thumb do
    process resize_to_fit: [200, 200]
    process optimize: [{ quality: 70, quiet: true }]
  end

  version :large do
    process resize_to_fit: [900, 900]
    process optimize: [{ quality: 70, quiet: true }]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def store_dir
    version = version_name || "_original"
    "uploads/#{model.class.to_s.underscore}/#{version}/#{index_store_dir}"
  end

  def index_store_dir(depth = 3)
    chars = model.id.to_i.to_s(36).chars.reverse
    chars.fill(0, depth) { |i| chars[i] || 0 }[0, depth].join("/")
  end

  def filename
    if original_filename
      if model && model[mounted_as].present?
        model[mounted_as]
      else
        "#{hash_name}.#{file.extension}"
      end
    end
  end

  def cache!(new_file)
    super
    @old_tmp_file = new_file
  end

  def delete_old_tmp_file(*)
    @old_tmp_file.try :delete
  end

  private

  def hash_name
    @hash_name ||= Digest::MD5.hexdigest("#{SecureRandom.hex(5)}_#{original_filename}")[0..16]
  end
end
