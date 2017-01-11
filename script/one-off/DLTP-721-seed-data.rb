attributes = {
  osf_project_identifier: 'abcde',
  source: 'https://osf.io/abcde',
  title: 'Example OSF Project',
  description: "Many Bothan's died to bring you this project",
  visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
}

previous_project = OsfArchive.create!(attributes.merge(date_archived: '2016-01-02'))
registration = OsfArchive.create!(attributes.merge(date_archived: '2016-02-02', source: 'https://osf.io/12345'))
project = OsfArchive.create!(attributes.merge(date_archived: '2016-03-02', previousVersion: previous_project))

puts "Previous Project URL: http://localhost:3000/show/#{previous_project.noid}"
puts "Registration URL: http://localhost:3000/show/#{registration.noid}"
puts "Project URL: http://localhost:3000/show/#{project.noid}"
`open http://localhost:3000/show/#{project.noid}`
