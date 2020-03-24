require 'depend_lister/belong'
class DependListerCore
  LEVEL_LIMITTER = 1000

  def execute
    make_table_belongs_hash
 
    level_tables_hash = to_level_tables_hash_main!

    adjust_circulation_main!(level_tables_hash)
    
    displayed = display_hash(level_tables_hash)
  end
  
  private

  def make_table_belongs_hash
    @table_belongs_hash = Belong.new.make_table_belongs_hash
    @table_belongs_hash_bak = @table_belongs_hash.dup
  end

  def adjust_circulation_main!(level_tables_hash)
    loop do
      adjust_circulation!(level_tables_hash)
      break if @table_belongs_hash.empty?
      if level_tables_hash.keys.max > LEVEL_LIMITTER
        puts 'over loop!'
        break
      end
    end
  end

  def adjust_circulation!(level_tables_hash)
    unless @table_belongs_hash.empty?
      extract_no_belong!
      table, blong = find_circulation
      if table
        @table_belongs_hash[table] = []
        @table_belongs_hash[blong] = []
        next_level = level_tables_hash.keys.max + 1
        next_level_tables_hash = to_level_tables_hash_main!(next_level)
        level_tables_hash.merge!(next_level_tables_hash)
      end
    end
  end

  def extract_belogs_to_self!
    @table_belongs_hash.each do |table, belongs|
      
      if belongs.include?(table)
        @table_belongs_hash[table] = belongs - [table]
      end
    end
  end

  def to_level_tables_hash_main!(level=1)
    extract_belogs_to_self!
    level_tables_hash = {}
    top_tables = to_top_tables!
    level_tables_hash[level] = top_tables
    loop do
      level += 1
      next_hash = to_level_tables_hash!(level, level_tables_hash)
      level_tables_hash.merge!(next_hash)
      break if level_tables_hash[level].empty?
      if level > LEVEL_LIMITTER
        puts 'over loop!!'
        break
      end
    end
    level_tables_hash
  end

  def extract_no_belong!
    tables = @table_belongs_hash.keys
    @table_belongs_hash.each do |table, belongs|
      @table_belongs_hash[table] = belongs.select { |belong| tables.include?(belong) }
    end
  end

  def find_circulation
    tables = @table_belongs_hash.keys
    @table_belongs_hash.each do |table, belongs|
      belongs.each do |belong|
        # 参照先がないbelongは対象外
        next unless tables.include?(belong)
        # 参照先belog
        next_belongs = @table_belongs_hash[belong]
        if next_belongs.include?(table)
          # 参照先belogに元tableが含まれる場合
          return [table, belong].sort
        end
      end
    end
    return [nil, nil]
  end

  def to_top_tables!
    # belongs_toが無いテーブル名を取得
    top_tables = @table_belongs_hash.select do |table, belongs|
      if belongs.empty?
        @table_belongs_hash.delete(table)
      end
      belongs.empty?
    end.keys
    top_tables.sort
  end

  # キーがレベル、値がテーブルのハッシュに変換する
  def to_level_tables_hash!(level, level_tables_hash)
    # level-1のテーブル名を取得
    prev_levels = []
    (2..level).each do |level|
      prev_levels << level_tables_hash.fetch(level-1, [])
    end
    prev_levels.flatten!

    # level-1のテーブル名がbelongt_to先のテーブル名のレベルをlevelにする
    @table_belongs_hash.each do |table, belongs|
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
    # @table_belongs_hashのbelongsが
    # 前レベルのテーブルに含まれていたテーブルを取得し、
    # level_tables_hash[level]から除外する
    extract_tables = []
    @table_belongs_hash.each do |table, belongs|
      unless belongs.to_set.subset?(prev_levels.to_set)
        # prev_levelsにbelongsがすべて含まれていない場合
        extract_tables << table
      end
    end
    level_tables_hash[level] ||= []
    level_tables_hash[level] -= extract_tables

    level_tables_hash[level].each do |table|
      @table_belongs_hash.delete(table)
    end
    level_tables_hash
  end

  def debug_hash(hash)
    hash.each{|key, value| puts "#{key}:#{value}" }
  end

  def display_hash(level_tables_hash)
    displayes = []
    displayes << "Level\tTable\tBelongsTo"
    level_tables_hash.each do |level, tables|
      tables.each do |table|
        blongs = @table_belongs_hash_bak[table].join(', ')
        displayes << "Lv#{level}\t#{table}\t#{blongs}"
      end
      displayes << "Lv#{level}\t\t" if tables.empty?
    end
    result =  displayes.join("\n")
    puts result
    result
  end
end
