module WebpackBundleHelper
  class BundleNotFound < StandardError; end

  def asset_bundle_path(entry, **options)
    raise BundleNotFound, "Could not find bundle with name #{entry}" unless manifest.key? entry

    asset_path(manifest.fetch(entry), **options)
  end

  def javascript_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.js")

    options = {
      src: path,
      defer: true
    }.merge(options)

    # async と defer を両方指定した場合、ふつうは async が優先されるが、
    # defer しか対応してない古いブラウザの挙動を考えるのが面倒なので、両方指定は防いでおく
    options.delete(:defer) if options[:async]

    javascript_include_tag '', **options
  end

  def stylesheet_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.css")

    options = {
      href: path
    }.merge(options)

    stylesheet_link_tag '', **options
  end

  # image_bundle_tag の場合は、entry はちゃんと拡張子付きで書いて欲しい
  def image_bundle_tag(entry, **options)
    raise ArgumentError, "Extname is missing with #{entry}" unless File.extname(entry).present?

    image_tag asset_bundle_path("images/#{entry}"), **options
  end

  def favicon_bundle_tag(entry, **options)
    path = asset_bundle_path("images/#{entry}")
    favicon_link_tag(path, options)
  end
  
  def apple_touch_icon_tag(entry, **options)
    path = asset_bundle_path("images/#{entry}")
    favicon_link_tag(path, options)
  end

  private

  MANIFEST_PATH = 'public/packs/manifest.json'.freeze

  def manifest
    @manifest ||= JSON.parse(File.read(MANIFEST_PATH))
  end
end
