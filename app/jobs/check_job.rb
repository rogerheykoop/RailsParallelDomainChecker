class CheckJob
  include SuckerPunch::Job
  require 'dnsruby'

  def perform(name,ext)
    WebsocketRails[:searchresults].trigger 'startsearch', [name,ext]
    res = Dnsruby::Resolver.new
    res.retry_times=(2)
    ns_req = nil
    begin
      ns_req = res.query(name + "." + ext, "NS")
    rescue Exception => e
      WebsocketRails[:searchresults].trigger 'completed_notfound', [name,ext]
      return false
    end
    if (ns_req.header.ancount == 0)
      WebsocketRails[:searchresults].trigger 'completed_notfound', [name,ext]
      return false
    else
      WebsocketRails[:searchresults].trigger 'completed_found', [name,ext]
      return true
    end
  end
end
