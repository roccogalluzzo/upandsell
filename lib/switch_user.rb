module SwitchUser
  class FromAdmin < ::Devise::Strategies::Base
    include ::SignInAs

    def valid?
      remember_admin_id?
    end

    def authenticate!
      resource = User.find(remember_admin_id)
      if resource
        clear_remembered_admin_id
        success!(resource)
      else
        pass
      end
    end
  end
end
Warden::Strategies.add(:switch_user, SwitchUser::FromAdmin)