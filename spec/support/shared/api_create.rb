shared_examples_for 'API Creatable' do |resource_class|
  let(:method) { :post }
  let!(:resource_name) { resource_class.name.underscore.to_sym }
  context 'authorized' do
    before do
      do_request(method, api_path, { access_token: access_token.token, "#{resource_name.to_sym}": attributes_for(resource_name) }.to_json, headers)
    end

    it 'returns 200 status' do
      do_request(method, api_path, { access_token: access_token.token, "#{resource_name.to_sym}": attributes_for(resource_name) }.to_json, headers)
      expect(response).to be_successful
    end

    it 'returns resource' do
      do_request(method, api_path, { access_token: access_token.token, "#{resource_name.to_sym}": attributes_for(resource_name) }.to_json, headers)
      expect(json[resource_name.to_s]).to include('body')
    end

    it 'create new resource' do
      expect { do_request(method, api_path, { access_token: access_token.token, "#{resource_name.to_sym}": attributes_for(resource_name) }.to_json, headers) }.to change(resource_class, :count).by(1)
    end
  end
end
