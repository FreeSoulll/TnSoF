shared_examples_for 'API Deletable' do |resource_class|
  context 'authorized' do
    subject { delete api_path, params: { access_token: access_token.token }.to_json, headers: headers }

    it 'delete the resource' do
      expect { subject }.to change(resource_class, :count).by(-1)
    end

    it 'returns 200 status' do
      subject
      expect(response).to be_successful
    end
  end
end
