require "depend_lister/depend_lister_core"

desc "依存関係順のテーブル一覧"
task depend_lister: :environment do
  DependListerCore.new.execute
end

