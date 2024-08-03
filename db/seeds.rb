competencies = 15.times.map do
  Competency.create(
    name: Faker::Educator.unique.subject
  )
end

authors = 10.times.map do
  Author.create(
    name: Faker::Name.name,
    email: Faker::Internet.email
  )
end

50.times do
  course = Course.create(
    title: Faker::Educator.course_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    author: authors.sample
  )

  course.competencies << competencies.sample(rand(0..3))
end
