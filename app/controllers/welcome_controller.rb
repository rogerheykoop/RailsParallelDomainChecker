class WelcomeController < ApplicationController
	def index
		@extensions = Extension.all.order("name asc")
		redirect_to extensions_path if (@extensions.nil? or @extensions == [])
	end

end
