# This controller contains rules which apply to all other
# defined controllers

class ApplicationController < ActionController::Base
  # Prevents cross-site request forgery attacks
  protect_from_forgery
  # Allows Sessions helper methods to be available in
  # the controllers as well
  include SessionsHelper
end
