desc "依存関係順のテーブル一覧"
task depend_lister: :environment do
  DependListerMain.new.execute
end

class DependListerMain
  def execute
    tables = gain_tables
    models = to_models(tables)
    # テーブル名がキーで値がモデルのハッシュを生成
    table_model_hash = to_table_model_hash(tables, models)
    # テーブル名がキーで値がbelongs_to先テーブル名のハッシュを生成
    table_belongs_hash = to_table_belongs_hash(table_model_hash, tables)
    #debug_hash(table_belongs_hash)
    # レベルがキーで値がテーブル名のハッシュを生成
    level_table_hash = to_level_table_hash_main(table_belongs_hash)
    # レベルを整理する
    organized_level_table_hash = organize_level(level_table_hash, table_belongs_hash)
    debug_hash(organized_level_table_hash)
  end

  private
  
  def organize_level(level_table_hash, table_belongs_hash)
    organized_level_table_hash = {}
    pre_tables = []
    level_table_hash.each do |level, tables|
      if level == 1
        organized_level_table_hash[level] = tables
        pre_tables = tables
        next
      end
      exist_belongs = []
      tables.each do |table|
        belongs = table_belongs_hash.fetch(table, [])
        exist_belongs << belongs.find{ |belong| pre_tables.include?(belong) }
      end
      exist_belongs.compact!
      if exist_belongs.empty?
        level_tables = organized_level_table_hash[level-1] || []
        level_tables << tables
        organized_level_table_hash[level-1] = level_tables.flatten
        pre_tables << tables
      else
        organized_level_table_hash[level] = tables
        pre_tables = tables
      end
    end
    organized_level_table_hash
  end

  def to_level_table_hash_main(arg_table_belongs_hash)
    table_belongs_hash = arg_table_belongs_hash.dup
    level = 0;
    level_table_hash = {}
    loop do
      level += 1
      level_table_hash.merge!(to_level_table_hash!(table_belongs_hash, level))
      break if table_belongs_hash.empty?
      raise 'over loop' if level > 99
    end
    level_table_hash
  end

  # テーブル名を取得
  def gain_tables
    ActiveRecord::Base.connection.tables.sort
  end

  def to_models(tables)
    tables.map{ |table| Object.const_get(table.classify) rescue nil } 
  end

  # テーブル名がキーで値がモデルのハッシュを生成
  def to_table_model_hash(tables, models)
    Hash[*tables.zip(models).flatten]
  end

  # テーブル名がキーで値がモデルのハッシュを生成
  def models_per_table(tables, models)
    Hash[*tables.zip(models).flatten]
  end

    # テーブル名がキーで値がbelongs_to先テーブルのハッシュを生成
  def to_table_belongs_hash(table_model_hash, all_tables)
    belogs = {}
    table_model_hash.each do |table, model|
      next unless model # モデルが存在しないtableは無視する
      tables = belong_tables(model)
      # 別名のmodelやparents(自身のモデルをbelongs_toのみしているものは)は除外
      belogs[table] = tables & all_tables
    end
    belogs
  end

  # モデルのbelongs_to先のテーブル名を取得
  def belong_tables(model)
    model.reflect_on_all_associations(:belongs_to).map do |belong|
      belong.name.to_s.pluralize
    end.sort
  end

  # ハッシュが空ではなかったら1.から繰り返す。
  def to_level_table_hash!(table_belongs_hash, level)
    level_table_hash = {}
    # 1. ハッシュの値が空のテーブル名のテーブル名を空テーブル名を取得する。
    top_tables = table_belongs_hash.select do |table, belongs|
      belongs.empty?
    end.keys
    if top_tables.empty?
      top_tables = table_belongs_hash.select do |table, belongs|
        belongs.size == 1
      end.keys
    end
    # 2. 空テーブル名をレベルiとする。
    level_table_hash[level] = top_tables
    # 3. ハッシュから空テーブル名をキーにして除去する。
    top_tables.each do |table|
      table_belongs_hash.delete(table)
    end
    # 4. ハッシュの値から空テーブル名を削除する。
    tables = table_belongs_hash.keys
    tables.each do |table|
      belongs = table_belongs_hash[table]
      table_belongs_hash[table] = belongs - top_tables
    end
    level_table_hash
  end

  def debug_hash(hash)
    hash.each{|key, value| puts "#{key}:#{value}" }
  end
end
