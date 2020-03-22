require "depend_lister/core"

desc "依存関係順のテーブル一覧"
task depend_lister: :environment do
  DependLister::Core.new.execute
end

