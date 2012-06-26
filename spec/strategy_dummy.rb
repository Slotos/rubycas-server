module CASServer
  module Strategy
    module Dummy
      def self.registered(app)

        app.get '/confirm_authentication' do
          establish_session!("someone", params[:service])
        end

      end
    end
  end
end
