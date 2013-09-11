require Curate::Engine.root.join('app/repository_models/dataset.rb')

Dataset.attribute :assign_doi,
  label: 'Assign Digital Object Identifier (DOI)',
  hint: "A Digital Object Identifier (DOI) is a permanent link to your Dataset. It's an easy way for other people to cite your work",
  displayable: false, multiple: false,
  default: true