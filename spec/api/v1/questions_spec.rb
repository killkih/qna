# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer_response) { question_response['answers'].first }
        let(:answer) { answers.first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, files: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")]) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let!(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns all public fields' do
          %w[id body user_id commentable_type commentable_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end
      end

      describe 'attached files' do
        let(:files_response) { question_response['urls'].first }
        let(:file) { question.files.first }

        it 'returns files urls' do
          expect(files_response['url']).to eq rails_blob_url(file, only_path: true).as_json
        end

        it 'returns list of files' do
          expect(question_response['urls'].size).to eq 1
        end
      end

      describe 'links' do
        let(:link_response) { question_response['links'].first }
        let(:link) { question.links.first }

        it 'returns all public fields' do
          %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end

        it 'returns list of comments' do
          expect(question_response['links'].size).to eq 3
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      context 'valid question params' do
        let(:valid_request) do
          post api_path, params: { access_token: access_token.token,
                                   question: attributes_for(:question) }, headers: headers
        end

        it 'returns 200 status' do
          valid_request
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          valid_request
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end

        it 'change database' do
          expect { valid_request }.to change(Question, :count).by(1)
        end
      end

      context 'invalid question params' do
        let(:invalid_request) do
          post api_path, params: { access_token: access_token.token,
                                   question: attributes_for(:question,
                                                            :invalid) }, headers: headers
        end

        it 'returns unprocessable entity status' do
          invalid_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change database' do
          expect { invalid_request }.to_not change(Question, :count)
        end

        it 'returns errors message' do
          invalid_request
          expect(json['errors'].first).to eq "Title can't be blank"
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      context 'with valid params' do
        let(:valid_request) do
          patch api_path, params: { access_token: access_token.token, id: question.id,
                                    question: attributes_for(:question) }, headers: headers
        end

        it 'returns 200 status' do
          valid_request
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          valid_request
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end

        it 'change database' do
          expect { valid_request }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_request) do
          patch api_path, params: { access_token: access_token.token, id: question.id,
                                    question: attributes_for(:question, :invalid) }, headers: headers
        end

        it 'returns unprocessable entity status' do
          invalid_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change database' do
          expect { invalid_request }.to_not change(question, :title)
        end

        it 'returns errors message' do
          invalid_request
          expect(json['errors'].first).to eq "Title can't be blank"
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:valid_request) do
        delete api_path, params: { access_token: access_token.token, id: question }, headers: headers
      end

      it 'returns 200 status' do
        valid_request
        expect(response).to be_successful
      end

      it 'change database' do
        expect { valid_request }.to change(Question, :count).by(-1)
      end
    end
  end
end
