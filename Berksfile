site :opscode

metadata

# Rbenv coobook is not released on community site
cookbook 'rbenv', github: 'fnichol/chef-rbenv'
cookbook 'mysql', '~> 3.0'

group :integration do
  cookbook 'apt'
  cookbook 'ohai', '~> 2.0.0'
end
