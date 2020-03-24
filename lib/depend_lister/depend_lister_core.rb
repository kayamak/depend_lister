class DependListerCore
  def execute
    # テーブル名がキーで値がbelongs_to先テーブル名のハッシュを生成
    table_belongs_hash = to_table_belongs_hash
    # レベルがキーで値がテーブル名のハッシュを生成
    table_belongs_hash_bak = table_belongs_hash.dup
    level_tables_hash = to_level_tables_hash_main!(table_belongs_hash)

    unless table_belongs_hash.empty?
      extract_no_belong!(table_belongs_hash)
      table, blong = find_circulation(table_belongs_hash)
      if table
        table_belongs_hash[table] = []
        table_belongs_hash[blong] = []
        next_level = level_tables_hash.keys.max + 1
        next_level_tables_hash = to_level_tables_hash_main!(next_level, table_belongs_hash)
        level_tables_hash.merge!(next_level_tables_hash)
      end
    end
    displayed = display_hash(level_tables_hash, table_belongs_hash_bak)
  end
  
  private

  def extract_belogs_to_self!(table_belongs_hash)
    table_belongs_hash.each do |table, belongs|
      if belongs.include?(table)
        table_belongs_hash[table] = belongs - [table]
      end
    end
  end
    
  def organize_level(level_tables_hash, table_belongs_hash)
    organized_level_tables_hash = {}
    pre_tables = []
    level_tables_hash.each do |level, tables|
      if level == 1
        organized_level_tables_hash[level] = tables
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
        level_tables = organized_level_tables_hash[level-1] || []
        level_tables << tables
        organized_level_tables_hash[level-1] = level_tables.flatten
        pre_tables << tables
      else
        organized_level_tables_hash[level] = tables
        pre_tables = tables
      end
    end
    organized_level_tables_hash
  end

  def to_level_tables_hash_main!(level=1, table_belongs_hash)
    extract_belogs_to_self!(table_belongs_hash)
    level_tables_hash = {}
    top_tables = to_top_tables!(table_belongs_hash)
    level_tables_hash[level] = top_tables
    loop do
      level += 1
      next_hash = to_level_tables_hash!(table_belongs_hash, level, level_tables_hash)
      level_tables_hash.merge!(next_hash)
      break if level_tables_hash[level].empty?
      if level > 99
        puts 'over loop'
        break
      end
    end
    level_tables_hash
  end

  def extract_no_belong!(table_belongs_hash)
    tables = table_belongs_hash.keys
    table_belongs_hash.each do |table, belongs|
      table_belongs_hash[table] = belongs.select { |belong| tables.include?(belong) }
    end
  end

  def find_circulation(table_belongs_hash)
    tables = table_belongs_hash.keys
    table_belongs_hash.each do |table, belongs|
      belongs.each do |belong|
        # 参照先がないbelongは対象外
        next unless tables.include?(belong)
        # 参照先belog
        next_belongs = table_belongs_hash[belong]
        if next_belongs.include?(table)
          # 参照先belogに元tableが含まれる場合
          return [table, belong].sort
        end
      end
    end
    return [nil, nil]
  end

  def to_top_tables!(table_belongs_hash)
    # belongs_toが無いテーブル名を取得
    top_tables = table_belongs_hash.select do |table, belongs|
      if belongs.empty?
        table_belongs_hash.delete(table)
      end
      belongs.empty?
    end.keys
    top_tables.sort
  end

  # キーがレベル、値がテーブルのハッシュに変換する
  def to_level_tables_hash!(table_belongs_hash, level, level_tables_hash)
    # level-1のテーブル名を取得
    prev_levels = []
    (2..level).each do |level|
      prev_levels << level_tables_hash.fetch(level-1, [])
    end
    prev_levels.flatten!

    # level-1のテーブル名がbelongt_to先のテーブル名のレベルをlevelにする
    table_belongs_hash.each do |table, belongs|
      found = false
      belongs.each do |belong|
        if prev_levels.include?(belong)
          found = true
          break
        end
      end
      if found
        level_tables_hash[level] ||= []
        level_tables_hash[level] << table
      end
    end
    # table_belongs_hashのbelongsが
    # 前レベルのテーブルに含まれていたテーブルを取得し、
    # level_tables_hash[level]から除外する
    extract_tables = []
    table_belongs_hash.each do |table, belongs|
      unless belongs.to_set.subset?(prev_levels.to_set)
        # prev_levelsにbelongsがすべて含まれていない場合
        extract_tables << table
      end
    end
    level_tables_hash[level] ||= []
    level_tables_hash[level] -= extract_tables

    level_tables_hash[level].each do |table|
      table_belongs_hash.delete(table)
    end
    level_tables_hash
  end

  # テーブル名を取得
  def gain_tables
    ActiveRecord::Base.connection.tables.sort
  end

  def to_models(tables)
    tables.map{ |table| Object.const_get(table.classify) rescue nil } 
  end

  # テーブル名がキーで値がモデルのハッシュを生成
  def to_table_model_hash
    tables = gain_tables
    models = to_models(tables)
    Hash[*tables.zip(models).flatten]
  end

  # テーブル名がキーで値がモデルのハッシュを生成
  def models_per_table(tables, models)
    Hash[*tables.zip(models).flatten]
  end

  # テーブル名がキーで値がbelongs_to先テーブルのハッシュを生成
  def to_table_belongs_hash
    # テーブル名がキーで値がモデルのハッシュを生成
    table_model_hash = to_table_model_hash

    all_tables = table_model_hash.keys
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

  def debug_hash(hash)
    hash.each{|key, value| puts "#{key}:#{value}" }
  end

  def display_hash(level_tables_hash, table_belongs_hash)
    displayes = []
    displayes << "Level\tTable\tBelongsTo"
    level_tables_hash.each do |level, tables|
      tables.each do |table|
        blongs = table_belongs_hash[table].join(', ')
        displayes << "Lv#{level}\t#{table}\t#{blongs}"
      end
      displayes << "Lv#{level}\t\t" if tables.empty?
    end
    result =  displayes.join("\n")
    puts result
    result
  end
end
