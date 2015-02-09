# -*- encoding: utf-8 -*-
# stub: dnsruby 1.57.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dnsruby"
  s.version = "1.57.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alex Dalitz"]
  s.date = "2014-12-31"
  s.description = "Dnsruby is a pure Ruby DNS client library which implements a\nstub resolver. It aims to comply with all DNS RFCs, including\nDNSSEC NSEC3 support."
  s.email = "alex@caerkettontech.com"
  s.extra_rdoc_files = ["DNSSEC", "EXAMPLES", "README.md", "EVENTMACHINE"]
  s.files = ["DNSSEC", "EVENTMACHINE", "EXAMPLES", "README.md"]
  s.homepage = "https://github.com/alexdalitz/dnsruby"
  s.licenses = ["Apache License, Version 2.0"]
  s.post_install_message = "Installing dnsruby...\n  For issues and source code: https://github.com/alexdalitz/dnsruby\n  For general discussion (please tell us how you use dnsruby): https://groups.google.com/forum/#!forum/dnsruby"
  s.rubygems_version = "2.2.2"
  s.summary = "Ruby DNS(SEC) implementation"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<pry>, ["~> 0.10"])
      s.add_development_dependency(%q<pry-byebug>, ["~> 2.0"])
      s.add_development_dependency(%q<rake>, [">= 10.3.2", "~> 10"])
      s.add_development_dependency(%q<minitest>, ["~> 5.4"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.7"])
    else
      s.add_dependency(%q<pry>, ["~> 0.10"])
      s.add_dependency(%q<pry-byebug>, ["~> 2.0"])
      s.add_dependency(%q<rake>, [">= 10.3.2", "~> 10"])
      s.add_dependency(%q<minitest>, ["~> 5.4"])
      s.add_dependency(%q<coveralls>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<pry>, ["~> 0.10"])
    s.add_dependency(%q<pry-byebug>, ["~> 2.0"])
    s.add_dependency(%q<rake>, [">= 10.3.2", "~> 10"])
    s.add_dependency(%q<minitest>, ["~> 5.4"])
    s.add_dependency(%q<coveralls>, ["~> 0.7"])
  end
end
