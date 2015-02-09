class DomainsearchController < ApplicationController
  def search
    search = domainsearch_params
    if !search[:name].nil?
      extensions = Extension.all
      for ext in extensions
        # Fork off a new worker job for every extension
        logger.info(ext.inspect)
        CheckJob.new.async.perform(search[:name],ext[:name])
      end
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def domainsearch_params
    params.permit([:name])
  end

end
