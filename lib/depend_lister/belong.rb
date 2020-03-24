class Belong
  # Generates the hash(key: table name, value: belongs_to point table name).
  def to_table_belongs_hash
    # Generates the hash(key: table name, value: model).
    table_model_hash = to_table_model_hash

    all_tables = table_model_hash.keys
    belogs = {}
    table_model_hash.each do |table, model|
    next unless model
      # the model which does not exist is ignored.
      tables = belong_tables(model)
      # models of alias are exclusion.
      belogs[table] = tables & all_tables
    end
    belogs
  end

  private

  # Generates the hash(key: table name, value: model name).
  def make_table_model_hash
    tables = gain_tables
    models = to_models(tables)
    Hash[*tables.zip(models).flatten]
  end

  # Gains table names.
  def gain_tables
    ActiveRecord::Base.connection.tables.sort
  end

  def to_models(tables)
    tables.map{ |table| Object.const_get(table.classify) rescue nil } 
  end

  # Gains the table name of the belongs_to point of the model.
  def belong_tables(model)
    model.reflect_on_all_associations(:belongs_to).map do |belong|
      belong.name.to_s.pluralize
    end.sort
  end
end
