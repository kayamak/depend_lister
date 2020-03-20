require "depend_lister/version"

module DependLister
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "tasks/depend_lister.rake"
    end
  end
end
