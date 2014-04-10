class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  
  
  
  
  
  
  
  
  # Overriding Devise https://github.com/plataformatec/devise
  def after_sign_in_path_for(user)
    if user.sign_in_count == 1
      return welcome_new_user_path
    else
      return welcome_back_existing_user_path
    end      
  end
  
    
  
  def after_sign_out_path_for(user)
    super
  end
end
