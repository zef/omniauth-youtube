require 'spec_helper'
require 'omniauth-soundcloud'

describe OmniAuth::Strategies::SoundCloud do
  subject do
    OmniAuth::Strategies::SoundCloud.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'should have the correct SoundCloud site' do
      subject.client.site.should eq("https://api.soundcloud.com")
    end

    it 'should have the correct authorization url' do
      subject.client.options[:authorize_url].should eq("/connect")
    end

    it 'should have the correct token url' do
      subject.client.options[:token_url].should eq('/oauth2/token')
    end
  end

  describe '#callback_path' do
    it 'should have the correct callback path' do
      subject.callback_path.should eq('/auth/soundcloud/callback')
    end
  end
end
