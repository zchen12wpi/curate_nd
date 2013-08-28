require Curate::Engine.root.join('app/models/classify_concern')
class ClassifyConcern
  VALID_CURATION_CONCERN_CLASS_NAMES = [
    'SeniorThesis'
  ]
  UPCOMING_CONCERNS = [
    ['Article', 'Deposit your preprint or open access articles.'],
    ['Dataset', 'Store research data.'],
    ['Image', 'Deposite photographs or generated images.'],
    ['Video', 'Upload your video files.']
  ]
end
