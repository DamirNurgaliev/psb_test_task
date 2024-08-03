require "swagger_helper"

describe "Competencies API", type: :request do
  let(:course1) { create(:course) }
  let(:course2) { create(:course) }

  let!(:competency1) { create(:competency, courses: [course1, course2], name: "Comp 1") }
  let!(:competency2) { create(:competency, courses: [course1], name: "Comp 2") }

  let(:response_data) { response.parsed_body }

  path "/api/v1/competencies" do
    get("list competencies") do
      tags "Competencies"
      produces "application/json"

      response(200, "successful") do
        schema type: :array, items: { "$ref" => "#/components/schemas/Competency" }

        let(:expected_response_data) do
          [
            {
              "id" => competency1.id,
              "name" => "Comp 1",
              "created_at" => competency1.created_at.iso8601.to_s,
              "updated_at" => competency1.updated_at.iso8601.to_s
            },
            {
              "id" => competency2.id,
              "name" => "Comp 2",
              "created_at" => competency2.created_at.iso8601.to_s,
              "updated_at" => competency2.updated_at.iso8601.to_s
            }
          ]
        end

        run_test! do |_response|
          expect(response_data).to eq(expected_response_data)
        end
      end
    end

    post("create Competency") do
      tags "Competencies"
      consumes "application/json"
      produces "application/json"
      parameter name: :competency, in: :body, schema: {
        "$ref" => "#/components/schemas/Competency"
      }

      response(201, "created") do
        let(:competency) { { name: "New Comp" } }

        run_test! do |_response|
          expect(response_data["name"]).to eq("New Comp")
        end
      end

      response(422, "unprocessable entity") do
        let(:competency) { { name: "a" * 101 } }

        run_test!
      end
    end
  end

  path "/api/v1/competencies/{id}" do
    parameter name: "id", in: :path, type: :string, description: "competency id"

    get("show competency") do
      tags "Competencies"
      produces "application/json"

      response(200, "successful") do
        let(:id) { competency1.id }

        let(:expected_response_data) do
          {
            "id" => id,
            "name" => "Comp 1",
            "created_at" => competency1.created_at.iso8601.to_s,
            "updated_at" => competency1.updated_at.iso8601.to_s
          }
        end

        schema "$ref" => "#/components/schemas/Competency"

        run_test! do |_response|
          expect(response_data).to eq(expected_response_data)
        end
      end
    end

    patch("update competency") do
      tags "Competencies"
      consumes "application/json"
      produces "application/json"
      parameter name: :competency, in: :body, schema: {
        "$ref" => "#/components/schemas/Competency"
      }

      response(200, "successful") do
        let(:id) { competency1.id }
        let(:competency) { { name: "New Comp 1" } }

        run_test! do |_response|
          expect(response_data["name"]).to eq("New Comp 1")
        end
      end

      response(422, "unprocessable entity") do
        let(:id) { competency1.id }
        let(:competency) { { name: "a" * 101 } }

        run_test!
      end
    end

    delete("delete competency") do
      tags "Competencies"
      response(204, "successful") do
        let(:id) { competency1.id }

        run_test!
      end
    end
  end
end
