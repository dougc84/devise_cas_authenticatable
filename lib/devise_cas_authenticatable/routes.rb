if defined? ActionDispatch::Routing
  # Rails 3, 4
  ActionDispatch::Routing::Mapper.class_eval do
    protected
  
    def devise_cas_authenticatable(mapping, controllers)
      # service endpoint for CAS server
      get "service", to: "#{controllers[:cas_sessions]}#service", as: "service"
      post "service", to: "#{controllers[:cas_sessions]}#single_sign_out", as: "single_sign_out"

      resource :session, only: [], controller: controllers[:cas_sessions], path: "" do
        get :new, path: mapping.path_names[:sign_in], as: "new"
        get :unregistered
        post :create, path: mapping.path_names[:sign_in]
        delete :destroy, path: mapping.path_names[:sign_out], as: "destroy"
      end
    end
  end
else
  # Rails 2 support removed
  raise
end
