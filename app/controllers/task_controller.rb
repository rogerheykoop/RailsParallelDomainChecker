class TaskController < WebsocketRails::BaseController
	def completed_notfound
		logger.info("NOT FOUND " + message.inspect)
	end
	def completed_found
		logger.info("FOUND " + message.inspect)
	end
end
