require "swagger_helper"

describe "Authors API", type: :request do
  let!(:author_1) { create :author, name: "Test Author1", email: "test1@mail.ru" }
  let!(:author_2) { create :author, name: "Test Author2", email: "test2@mail.ru" }

  let(:response_data) { JSON.parse(response.body) }

  path "/api/v1/authors" do
    get("list authors") do
      tags "Authors"
      produces "application/json"

      response(200, "successful") do
        schema type: :array, items: { "$ref" => "#/components/schemas/Author" }

        let(:expected_response_data) do
          [
            {
              "id"=> author_1.id,
              "name" => "Test Author1",
              "email" => "test1@mail.ru",
              "created_at" => author_1.created_at.iso8601.to_s,
              "updated_at" => author_1.updated_at.iso8601.to_s,
            },
            {
              "id"=> author_2.id,
              "name" => "Test Author2",
              "email" => "test2@mail.ru",
              "created_at" => author_2.created_at.iso8601.to_s,
              "updated_at" => author_2.updated_at.iso8601.to_s,
            }
          ]
        end

        run_test! do |response|
          expect(response_data).to eq(expected_response_data)
        end
      end
    end

    post("create Author") do
      tags "Authors"
      consumes "application/json"
      produces "application/json"
      parameter name: :author, in: :body, schema: {
        "$ref" => "#/components/schemas/Author"
      }

      response(201, "created") do
        let(:author) { { name: "New Author", email: "new@email.ru" } }

        run_test! do |response|
          expect(response_data["name"]).to eq("New Author")
          expect(response_data["email"]).to eq("new@email.ru")
        end
      end

      response(422, "unprocessable entity") do
        let(:author) { { email: "wrongemail" } }

        run_test!
      end
    end
  end

  path "/api/v1/authors/{id}" do
    parameter name: "id", in: :path, type: :string, description: "author id"

    get("show author") do
      tags "Authors"
      produces "application/json"

      response(200, "successful") do
        let(:id) { author_1.id }

        let(:expected_response_data) do
          {
            "id"=> id,
            "name" => "Test Author1",
            "email" => "test1@mail.ru",
            "created_at" => author_1.created_at.iso8601.to_s,
            "updated_at" => author_1.updated_at.iso8601.to_s,
          }
        end

        schema "$ref" => "#/components/schemas/Author"

        run_test! do |response|
          expect(response_data).to eq(expected_response_data)
        end
      end
    end

    patch("update author") do
      tags "Authors"
      consumes "application/json"
      produces "application/json"
      parameter name: :author, in: :body, schema: {
        "$ref" => "#/components/schemas/Author"
      }

      response(200, "successful") do
        let(:id) { author_1.id }
        let(:author) do
          {
            name: "New Name",
            email: "new@email.ru"
          }
        end

        run_test! do |response|
          expect(response_data["name"]).to eq("New Name")
          expect(response_data["email"]).to eq("new@email.ru")
        end
      end

      response(422, "unprocessable entity") do
        let(:id) { author_1.id }
        let(:author) { { email: "wrongemail" } }

        run_test!
      end
    end

    delete("delete author") do
      tags "Authors"
      response(204, "successful") do
        let(:id) { author_1.id }

        run_test!
      end
    end
  end
end
