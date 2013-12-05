require Curate::Engine.root.join('app/controllers/common_objects_controller')
class CommonObjectsController
  append_view_path(Curate::Engine.root.join('app/views/curation_concern/base'))
end