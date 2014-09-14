class AdminSubdomain
  def self.matches?(request)
    subdomain = request.subdomains(SubdomainFu.config.tld_size).join(".")
    case subdomain
    when 'admin'
      true
    else
      false
    end
  end
end

class ClientSubdomain
  def self.matches?(request)
    subdomain = request.subdomain(0)
    p"=================Sub Domain: #{subdomain}"
    #subdomain = request.subdomains(SubdomainFu.config.tld_size).join(".")    
    case subdomain
    when  nil
      false
    else
      true
    end
  end
end

class OnlyAjaxRequest
  def self.matches?(request)
    request.xhr?
  end
end
#
#class UserSubdomain
#  def self.matches?(request)
#    case request.subdomain
#    when 'www', '', nil
#      false
#    else
#      true
#    end
#  end
#end
