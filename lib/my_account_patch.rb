require_dependency 'my_controller' 

module LocalAvatarsPlugin
  module MyAccountPatch
    def self.included(base) # :nodoc:    
      base.send(:include, InstanceMethods)     
      base.class_eval do      
        unloadable
        alias_method_chain :account, :avatar
      end
    end
    module InstanceMethods    
      def account_with_avatar
        @user = User.current
        file_field = params[:avatar] rescue nil
        if file_field
          @user.attachments.clear
          attachments = Attachment.attach_files(@user, {'first' => {'file' => file_field, 'description' => 'avatar'}}) 
          @user.save
        end
        account_without_avatar
      end
    end
  end
end

MyController.send(:include, LocalAvatarsPlugin::MyAccountPatch)

