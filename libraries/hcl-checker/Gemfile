source 'https://rubygems.org'

# This is needed due https://nvd.nist.gov/vuln/detail/CVE-2018-14404
# A NULL pointer dereference vulnerability exists in the xpath.c:xmlXPathCompOpEval()
# function of libxml2 through 2.9.8 when parsing an invalid XPath expression in the
# XPATH_OP_AND or XPATH_OP_OR case. Applications processing untrusted XSL format inputs
# with the use of the libxml2 library may be vulnerable to a denial of service attack due
# to a crash of the application.
# Nokogiri >= 1.8.5 solves this problem
gem 'nokogiri', '>= 1.10.8'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in hcl-checker.gemspec
gemspec
