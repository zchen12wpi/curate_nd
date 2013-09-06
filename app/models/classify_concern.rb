require Curate::Engine.root.join('app/models/classify_concern')
class ClassifyConcern
  VALID_CURATION_CONCERN_CLASS_NAMES = [
    'SeniorThesis',
    'Article',
    'Dataset'
  ]
  UPCOMING_CONCERNS = [
    ['Image', 'Deposite photographs or generated images.'],
    ['Video', 'Upload your video files.']
  ]
end
