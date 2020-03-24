require "depend_lister/depend_lister_core"

desc "Table list of dependence order"
task depend_lister: :environment do
  DependListerCore.new.execute
end

