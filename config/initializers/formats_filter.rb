# frozen_string_literal: true

# This monkey patch is a current vulnerability work-around.
# See https://groups.google.com/forum/#!topic/rubyonrails-security/GN7w9fFAQeI for further
# details. If you update the Rails version, please check that the patch is included.
raise "MonkeyPatch may no longer apply" unless Rails.version =~ /\A4\.2\.\d+/

ActionDispatch::Request.prepend(Module.new do
  def formats
    super().select do |format|
      format.symbol || format.ref == "*/*"
    end
  end
end)
