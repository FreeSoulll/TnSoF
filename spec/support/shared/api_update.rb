shared_examples_for 'API Updatable' do |resource_class|
  let!(:resource_name) { resource_class.name.underscore.to_sym }
  let(:method) { :patch }

  context 'authorized' do
    before do
      do_request(method, api_path, { access_token: access_token.token, "#{resource_name.to_sym}": update_params }.to_json, headers)
    end

    it 'update resource body' do
      resource.reload
      expect(resource.body).to eq("new #{resource_name} body")
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end
  end
end
