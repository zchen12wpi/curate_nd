require Curate::Engine.root.join('app/models/help_request')
class HelpRequest
  def sender_email
    user.email
  end
end
