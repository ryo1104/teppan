require 'rails_helper'

RSpec.describe WebpackBundleHelper, type: :helper do
  before do
    manifest = {
      "account.js": '/packs/js/account-44b20c130756b62e6152.js',
      "application.css": '/packs/css/application-44b20c130756b62e6152.css',
      "application.js": '/packs/js/application-44b20c130756b62e6152.js',
      "bankaccount.js": '/packs/js/bankaccount-44b20c130756b62e6152.js',
      "hashtag-autocomplete.js": '/packs/js/hashtag-autocomplete-44b20c130756b62e6152.js',
      "hashtag-entry.js": '/packs/js/hashtag-entry-44b20c130756b62e6152.js',
      "topic.js": '/packs/js/topic-44b20c130756b62e6152.js',
      "trade.js": '/packs/js/trade-44b20c130756b62e6152.js',
      "user.js": '/packs/js/user-44b20c130756b62e6152.js',
      "images/apple-touch-icon.png": '/packs/images/apple-touch-icon.png',
      "images/cancel-off.png": '/packs/images/cancel-off.png',
      "images/cancel-on.png": '/packs/images/cancel-on.png',
      "images/favicon.ico": '/packs/images/favicon.ico',
      "images/google.png": '/packs/images/google.png',
      "images/logo-color-1.png": '/packs/images/logo-color-1.png',
      "images/no_user_image.png": '/packs/images/no_user_image.png',
      "images/photo_icon.png": '/packs/images/photo_icon.png',
      "images/star-half.png": '/packs/images/star-half.png',
      "images/star-off.png": '/packs/images/star-off.png',
      "images/star-on.png": '/packs/images/star-on.png',
      "images/teppan_gray.jpeg": '/packs/images/teppan_gray.jpeg',
      "images/twitter.png": '/packs/images/twitter.png',
      "images/yahoo.png": '/packs/images/yahoo.png'
    }.stringify_keys

    allow_any_instance_of(WebpackBundleHelper).to receive(:manifest).and_return(manifest)
  end

  describe '#asset_bundle_path' do
    context 'given existing *.js entry name' do
      subject { asset_bundle_path('application.js') }

      it 'returns actual file name' do
        is_expected.to eq '/packs/js/application-44b20c130756b62e6152.js'
      end
    end

    context 'given existing *.css entry name' do
      subject { asset_bundle_path('application.css') }

      it 'returns actual file name' do
        is_expected.to eq '/packs/css/application-44b20c130756b62e6152.css'
      end
    end

    context 'given non-existing entry name' do
      subject do
        -> { asset_bundle_path('not_found.js') }
      end

      it 'raises' do
        is_expected.to raise_error WebpackBundleHelper::BundleNotFound
      end
    end
  end

  describe '#javascript_bundle_tag' do
    context 'given existing *.js entry name' do
      subject { javascript_bundle_tag('application') }

      it 'renders a nice <script> tag' do
        is_expected.to eq '<script src="/packs/js/application-44b20c130756b62e6152.js" defer="defer"></script>'
      end
    end

    context 'given existing *.js entry name with async' do
      subject { javascript_bundle_tag('application', async: true) }

      it 'renders a nice <script> tag' do
        is_expected.to eq '<script src="/packs/js/application-44b20c130756b62e6152.js" async="async"></script>'
      end
    end

    context 'given non-existing *.js entry name' do
      subject do
        -> { javascript_bundle_tag('not_found') }
      end

      it 'raises' do
        is_expected.to raise_error WebpackBundleHelper::BundleNotFound
      end
    end
  end

  describe '#stylesheet_bundle_tag' do
    context 'given existing *.css entry name' do
      subject { stylesheet_bundle_tag('application') }

      it 'renders a nice <link> tag' do
        is_expected.to eq '<link rel="stylesheet" media="screen" href="/packs/css/application-44b20c130756b62e6152.css" />'
      end
    end

    context 'given non-existing *.css entry name' do
      subject do
        -> { stylesheet_bundle_tag('not_found') }
      end

      it 'raises' do
        is_expected.to raise_error WebpackBundleHelper::BundleNotFound
      end
    end
  end

  describe '#image_bundle_tag' do
    context 'given existing *.png entry name' do
      subject { image_bundle_tag('star-on.png', alt: 'star-on') }

      it 'renders a nice <img> tag' do
        is_expected.to eq '<img alt="star-on" src="/packs/images/star-on.png" />'
      end
    end

    context 'given non-existing *.png entry name' do
      subject do
        -> { image_bundle_tag('not_found.png') }
      end

      it 'raises' do
        is_expected.to raise_error WebpackBundleHelper::BundleNotFound
      end
    end

    context 'given without extname' do
      subject do
        -> { image_bundle_tag('not_found') }
      end

      it 'raises' do
        is_expected.to raise_error ArgumentError
      end
    end
  end

  describe '#favicon_bundle_tag' do
    context 'given existing *.ico entry name' do
      subject { favicon_bundle_tag('favicon.ico') }

      it 'renders a nice <link> tag' do
        is_expected.to eq '<link rel="shortcut icon" type="image/x-icon" href="/packs/images/favicon.ico" />'
      end
    end
    context 'given non-existing *.png entry name' do
      subject do
        -> { favicon_bundle_tag('not_found.ico') }
      end

      it 'raises' do
        is_expected.to raise_error WebpackBundleHelper::BundleNotFound
      end
    end
  end

  describe '#apple_touch_icon_tag' do
    context 'given existing *.png entry name' do
      subject { apple_touch_icon_tag('apple-touch-icon.png', rel: 'apple-touch-icon') }

      it 'renders a nice <link> tag' do
        is_expected.to eq '<link rel="apple-touch-icon" type="image/x-icon" href="/packs/images/apple-touch-icon.png" />'
      end
    end
    context 'given non-existing *.png entry name' do
      subject do
        -> { apple_touch_icon_tag('not_found.ico', rel: 'apple-touch-icon') }
      end

      it 'raises' do
        is_expected.to raise_error WebpackBundleHelper::BundleNotFound
      end
    end
  end
end
