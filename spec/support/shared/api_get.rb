shared_examples 'API Getable' do |resource_type|
  let(:method) { :get }

  case resource_type
  when 'status'
    it 'returns 200 status' do
      expect(response).to be_successful
    end
  when 'object'
    it 'contains user object' do
      expect(resource_response['user']['id']).to eq resource.user.id
    end

  when 'files'
    it 'contains files urls' do
      expect(resource_response['file_urls'].size).to eq 1
    end
    it 'returns url' do
      expect(resource_response['file_urls'].first).to include('test_file.txt')
    end

  when 'links'
    it 'contains links' do
      expect(resource_response['links'].size).to eq 1
    end

    it 'returns all public fields' do
      %w[id name url created_at updated_at].each do |attr|
        expect(resource_response['links'].first[attr]).to eq resource_link.send(attr).as_json
      end
    end

  when 'comments'
    it 'contains comments' do
      expect(resource_response['comments'].size).to eq 1
    end

    it 'returns all public fields' do
      %w[id body created_at updated_at].each do |attr|
        expect(resource_response['comments'].first[attr]).to eq resource_comment.send(attr).as_json
      end
    end
  end
end
