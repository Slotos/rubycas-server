require 'sinatra/r18n'

module CASServer
  module Localization
    def self.included(mod)
      mod.module_eval do
        register Sinatra::R18n
        ::R18n.default_places { File.dirname( File.dirname self.root ) + "/locales" }
      end
    end
  end
end
