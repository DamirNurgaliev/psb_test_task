require "swagger_helper"

describe "Courses API", type: :request do
  let(:author) { create :author, name: "Test Author1", email: "test1@mail.ru" }
  let(:course_1) { create(:course, title: "ATest Course 1", description: "Test1", author: author ) }
  let!(:course_2) { create(:course, title: "BTest Course 2", description: "Test2", author: author ) }
  let!(:competency_1) { create(:competency, courses: [course_1], name: "Competency 1") }
  let!(:competency_2) { create(:competency, courses: [course_1], name: "Competency 2") }

  let(:response_data) { JSON.parse(response.body) }

  let(:expected_author) do
    {
      "id" => author.id,
      "name" => "Test Author1",
      "email" => "test1@mail.ru",
      "created_at" => author.created_at.iso8601.to_s,
      "updated_at" => author.updated_at.iso8601.to_s
    }
  end

  let(:expected_competencies) do
    [
      {
        "id" => competency_1.id,
        "name" => "Competency 1",
        "created_at" => competency_1.created_at.iso8601.to_s,
        "updated_at" => competency_1.updated_at.iso8601.to_s
      },
      {
        "id" => competency_2.id,
        "name" => "Competency 2",
        "created_at" => competency_2.created_at.iso8601.to_s,
        "updated_at" => competency_2.updated_at.iso8601.to_s
      },
    ]
  end

  path "/api/v1/courses" do
    get("list courses") do
      tags "Courses"
      produces "application/json"

      response(200, "successful") do
        schema type: :array, items: { "$ref" => "#/components/schemas/CourseWithRelations" }

        let(:expected_response_data) do
          [
            {
              "id"=> course_1.id,
              "title" => "ATest Course 1",
              "description" => "Test1",
              "created_at" => course_1.created_at.iso8601.to_s,
              "updated_at" => course_1.updated_at.iso8601.to_s,
              "author" => expected_author,
              "competencies" => expected_competencies
            },
            {
              "id"=> course_2.id,
              "title" => "BTest Course 2",
              "description" => "Test2",
              "created_at" => course_2.created_at.iso8601.to_s,
              "updated_at" => course_2.updated_at.iso8601.to_s,
              "author" => expected_author,
              "competencies" => []
            }
          ]
        end

        run_test! do |response|
          expect(response_data).to eq(expected_response_data)
        end
      end
    end

    post("create course") do
      tags "Courses"
      consumes "application/json"
      produces "application/json"
      parameter name: :course, in: :body, schema: {
        "$ref" => "#/components/schemas/Course"
      }

      response(201, "created") do
        let(:course) { { title: "New Course", description: "Course description", author_id: author.id } }

        run_test! do |response|
          expect(response_data["title"]).to eq("New Course")
          expect(response_data["description"]).to eq("Course description")
          expect(response_data["author_id"]).to eq(author.id)
        end
      end

      response(422, "unprocessable entity") do
        let(:course) { { description: "Test" } }

        run_test!
      end
    end
  end

  path "/api/v1/courses/{id}" do
    parameter name: "id", in: :path, type: :string, description: "course id"

    get("show course") do
      tags "Courses"
      produces "application/json"

      response(200, "successful") do
        let(:id) { course_1.id }

        let(:expected_response_data) do
          {
            "id"=> id,
            "title" => "ATest Course 1",
            "description" => "Test1",
            "created_at" => course_1.created_at.iso8601.to_s,
            "updated_at" => course_1.updated_at.iso8601.to_s,
            "author" => expected_author,
            "competencies" => expected_competencies
          }
        end

        schema "$ref" => "#/components/schemas/CourseWithRelations"

        run_test! do |response|
          expect(response_data).to eq(expected_response_data)
        end
      end
    end

    patch("update course") do
      tags "Courses"
      consumes "application/json"
      produces "application/json"
      parameter name: :course, in: :body, schema: {
        "$ref" => "#/components/schemas/Course"
      }

      response(200, "successful") do
        let(:id) { course_1.id }
        let(:course) do
          {
            title: "Updated Course Title",
            description: "Updated Course Description"
          }
        end

        run_test! do |response|
          expect(response_data["title"]).to eq("Updated Course Title")
          expect(response_data["description"]).to eq("Updated Course Description")
        end
      end

      response(422, "unprocessable entity") do
        let(:id) { course_1.id }
        let(:course) { { author_id: 999 } }

        run_test!
      end
    end

    delete("delete course") do
      tags "Courses"
      response(204, "successful") do
        let(:id) { course_1.id }

        run_test!
      end
    end
  end
end
