require 'rails_helper'

describe UploadService do
  let(:service) { UploadService.new }
  let(:config) { Rails.application.secrets.aws }
  let(:file_key) {
    FOG.put_object(config["bucket"], '/uploads/products/guid/ciao.png', "test")
    return '/uploads/temp/products/guid/ciao.png'
  }
  let(:temp_file_key) {
    FOG.put_object(config["bucket"], '/uploads/temp/products/guid/ciao.png', "test")
    return '/uploads/temp/products/guid/ciao.png'
  }

  describe '#confirm' do
    it 'move uploaded file to definitive path' do
      expect(service.confirm(temp_file_key)[:key]).to eq('/uploads/products/guid/ciao.png')
    end
    it 'returns false for non exsist files' do
      expect(service.confirm('uploads/temp/products/guid/not_exsit.png')).to eq false
    end
  end

  describe '#delete' do
    it 'delete file on S3' do
      expect(service.delete(file_key)).to eq true
    end
  end

  describe '#url' do
    it 'return file download url' do
      expect(service.url(file_key)).to match 'https://upandsell-s3-dev.s3-eu-west-1.amazonaws.com//uploads/temp/products/guid/ciao.png'
    end
  end

  describe '#request' do
    it 'return form input values for upload to S3' do
      expect(UploadService.new.request('test_request'))
      .to include("X-Amz-Algorithm", 'X-Amz-Credential', 'key', 'acl',
       'policy', 'X-Amz-Date', 'X-Amz-Signature')
    end
  end

  describe '#upload_from_url' do
    it 'upload specified url' do
      VCR.use_cassette("service_upload_from_url", :record => :new_episodes) do
        expect(UploadService.new.upload_from_url('rails_logo.png', 'http://rubyonrails.org/images/rails.png'))
        .to include file_key: 'rails_logo.png'
      end
    end
    it 'return fail if network error' do
      WebMock::API.stub_request(:get, "http://rubyonrails.org/images/rails.png")
      .to_return( :status => ['404', 'Not Found'])
      expect(UploadService.new.upload_from_url('rails_logo.png', 'http://rubyonrails.org/images/rails.png'))
      .to eq false
    end
  end
end

