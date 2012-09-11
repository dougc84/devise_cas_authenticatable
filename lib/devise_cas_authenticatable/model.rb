module Devise
  module Models
    # Extends your User class with support for CAS ticket authentication.
    module CasAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Authenticate a CAS ticket and return the resulting user object.  Behavior is as follows:
        # 
        # * Check ticket validity using RubyCAS::Client.  Return nil if the ticket is invalid.
        # * Find a matching user by username (will use find_for_authentication if available).
        # * If the user does not exist, but Devise.cas_create_user is set, attempt to create the
        #   user object in the database.  If cas_extra_attributes= is defined, this will also
        #   pass in the ticket's extra_attributes hash.
        # * Return the resulting user object.
        def authenticate_with_cas_ticket(ticket)
          ::Devise.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
					begin
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      uri = URI.parse(validate_url)
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      h = uri.query ? query_to_hash(uri.query) : {}
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      h['service'] = st.service
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      h['ticket'] = st.ticket
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      h['renew'] = "1" if st.renew
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      h['pgtUrl'] = proxy_callback_url if proxy_callback_url
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      uri.query = hash_to_query(h)
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
			      response = request_cas_response(uri, ValidationResponse)
				    #   st.user = response.user
				    #   st.extra_attributes = response.extra_attributes
				    #   st.pgt_iou = response.pgt_iou
				    #   st.success = response.is_success?
				    #   st.failure_code = response.failure_code
				    #   st.failure_message = response.failure_message
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! model.rb - get_cas_validate_url\n") }
						File.open(Rails.root.join('/srv/checkout/current/log/params.log'), 'a') { |f| f.write("!#{Time.now}! #{::Devise.get_cas_validate_url}\n") }
						
					rescue Exception => e
						
					end
					
					

			    # def validate_service_ticket(st)
			    # 
			    #   return st
			    # end



          if ticket.is_valid?
           conditions = {::Devise.cas_username_column => ticket.respond_to?(:user) ? ticket.user : ticket.response.user} 
            # We don't want to override Devise 1.1's find_for_authentication
            resource = if respond_to?(:find_for_authentication)
              find_for_authentication(conditions)
            else
              find(:first, :conditions => conditions)
            end
            
            resource = new(conditions) if (resource.nil? and ::Devise.cas_create_user?)
            return nil unless resource
            
            if resource.respond_to? :cas_extra_attributes=
              resource.cas_extra_attributes = ticket.respond_to?(:extra_attributes) ? ticket.extra_attributes : ticket.response.extra_attributes
            end
            resource.save
            resource
          end
        end
      end
    end
  end
end
