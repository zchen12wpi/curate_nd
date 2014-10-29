require Curate::Engine.root.join('app/controllers/users_controller.rb')
class UsersController
  with_themed_layout 'user_profile_layout'
end

