module CASServer
  module Strategy
    module Dummy
      def self.registered(app)

        app.get '/confirm_authentication' do
          confirm_authentication!("someone", params[:service])
        end

      end
    end
  end
end
