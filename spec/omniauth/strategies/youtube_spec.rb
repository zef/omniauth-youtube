require 'spec_helper'
require 'omniauth-youtube'

describe OmniAuth::Strategies::YouTube do
  subject do
    OmniAuth::Strategies::YouTube.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'should have the correct YouTube site' do
      subject.client.site.should eq("https://gdata.youtube.com")
    end

    it 'should have the correct authorization url' do
      subject.client.options[:authorize_url].should eq("https://accounts.google.com/o/oauth2/auth")
    end

    it 'should have the correct token url' do
      subject.client.options[:token_url].should eq('https://accounts.google.com/o/oauth2/token')
    end
  end

  describe '#callback_path' do
    it 'should have the correct callback path' do
      subject.callback_path.should eq('/auth/youtube/callback')
    end
  end
end
