class Belong
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

  private

  # テーブル名がキーで値がモデルのハッシュを生成
  def make_table_model_hash
    tables = gain_tables
    models = to_models(tables)
    Hash[*tables.zip(models).flatten]
  end

  # テーブル名を取得
  def gain_tables
    ActiveRecord::Base.connection.tables.sort
  end

  def to_models(tables)
    tables.map{ |table| Object.const_get(table.classify) rescue nil } 
  end

  # モデルのbelongs_to先のテーブル名を取得
  def belong_tables(model)
    model.reflect_on_all_associations(:belongs_to).map do |belong|
      belong.name.to_s.pluralize
    end.sort
  end

end