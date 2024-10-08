require "spec_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s
  config.openapi_strict_schema_validation = true
  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1"
      },
      paths: {},
      components: {
        schemas: {
          Course: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Unique identifier for course" },
              title: { type: :string, description: "Title of course" },
              description: { type: :string, description: "Description of course" },
              created_at: { type: :string, format: "date-time",
                            description: "Timestamp when the competency was created" },
              updated_at: { type: :string, format: "date-time",
                            description: "Timestamp when the competency was created" }
            }
          },
          CourseWithRelations: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Unique identifier for course" },
              title: { type: :string, description: "Title of course" },
              description: { type: :string, description: "Description of course" },
              created_at: { type: :string, format: "date-time",
                            description: "Timestamp when the competency was created" },
              updated_at: { type: :string, format: "date-time",
                            description: "Timestamp when the competency was created" },
              author: { "$ref" => "#/components/schemas/Author" },
              competencies: {
                type: :array,
                items: { "$ref" => "#/components/schemas/Competency" }
              }
            }
          },
          NewCourse: {
            type: :object,
            properties: {
              title: { type: :string, description: "Title of course", example: "Test Course Title" },
              description: { type: :string, description: "Description of course", example: "Test desc" },
              author_id: { type: :integer, description: "Id of author", example: 1 },
              competency_ids: { type: :array, description: "Ids of competencies of this course", example: [1, 2] }
            }
          },
          Author: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Unique identifier for author" },
              name: { type: :string, description: "Name of author" },
              email: { type: :string, description: "Email of author" },
              created_at: { type: :string, format: "date-time", description: "Timestamp when the author was created" },
              updated_at: { type: :string, format: "date-time", description: "Timestamp when the author was updated" }
            }
          },
          NewAuthor: {
            type: :object,
            properties: {
              name: { type: :string, description: "Name of author", example: "TestName" },
              email: { type: :string, description: "Email of author", example: "test@mail.ru" }
            }
          },
          Competency: {
            type: :object,
            properties: {
              id: { type: :integer, description: "Unique identifier for competency" },
              name: { type: :string, description: "Name of competency" },
              created_at: { type: :string, format: "date-time",
                            description: "Timestamp when the competency was created" },
              updated_at: { type: :string, format: "date-time",
                            description: "Timestamp when the competency was updated" }
            }
          },
          NewCompetency: {
            type: :object,
            properties: {
              name: { type: :string, description: "Name of competency", example: "Test Competency 1" }
            }
          }
        }
      },
      servers: [
        {
          url: "http://{defaultHost}",
          variables: {
            defaultHost: {
              default: "localhost:3000"
            }
          }
        }
      ]
    }
  }
end
