# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id best user_id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) do
      create(:answer, question: question,
                      files: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")])
    end
    let!(:comments) { create_list(:comment, 3, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id best user_id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let!(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns all public fields' do
          %w[id body user_id commentable_type commentable_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end
      end

      describe 'attached files' do
        let(:files_response) { answer_response['urls'].first }
        let(:file) { answer.files.first }

        it 'returns files urls' do
          expect(files_response['url']).to eq rails_blob_url(file, only_path: true).as_json
        end

        it 'returns list of files' do
          expect(answer_response['urls'].size).to eq 1
        end
      end

      describe 'links' do
        let(:link_response) { answer_response['links'].first }
        let(:link) { answer.links.first }

        it 'returns all public fields' do
          %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end

        it 'returns list of comments' do
          expect(answer_response['links'].size).to eq 3
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'valid answer params' do
        let(:valid_request) do
          post api_path, params: { access_token: access_token.token, question_id: question,
                                   answer: attributes_for(:answer) }, headers: headers
        end

        it 'returns 200 status' do
          valid_request
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          valid_request
          %w[id best user_id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end

        it 'change database' do
          expect { valid_request }.to change(Answer, :count).by(1)
        end
      end

      context 'invalid answer params' do
        let(:invalid_request) do
          post api_path, params: { access_token: access_token.token, question_id: question,
                                   answer: attributes_for(:answer, :invalid) }, headers: headers
        end

        it 'returns unprocessable entity status' do
          invalid_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change database' do
          expect { invalid_request }.to_not change(Answer, :count)
        end

        it 'returns errors message' do
          invalid_request
          expect(json['errors'].first).to eq "Body can't be blank"
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'with valid params' do
        let(:valid_request) do
          patch api_path, params: { access_token: access_token.token, question_id: question,
                                    answer: attributes_for(:answer) }, headers: headers
        end

        it 'returns 200 status' do
          valid_request
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          valid_request
          %w[id best user_id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end

        it 'change database' do
          expect { valid_request }.to change(Answer, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:invalid_request) do
          patch api_path, params: { access_token: access_token.token, question_id: question,
                                    answer: attributes_for(:answer, :invalid) }, headers: headers
        end

        it 'returns unprocessable entity status' do
          invalid_request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change database' do
          expect { invalid_request }.to_not change(answer, :body)
        end

        it 'returns errors message' do
          invalid_request
          expect(json['errors'].first).to eq "Body can't be blank"
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:valid_request) do
        delete api_path, params: { access_token: access_token.token, question_id: question,
                                   id: answer }, headers: headers
      end

      it 'returns 200 status' do
        valid_request
        expect(response).to be_successful
      end

      it 'change database' do
        expect { valid_request }.to change(Answer, :count).by(-1)
      end
    end
  end
end
