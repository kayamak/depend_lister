require "pry"
require "depend_lister/core"

RSpec.describe DependLister::Core do
  context "there are not belongs_to related each other" do
    let(:table_blongs_hash)  {{
      "accounts"=>[],
      "favourites"=>["accounts", "statuses"],
      "follows"=>["accounts"],
      "mentions"=>["accounts", "statuses"],
      "statuses"=>["accounts"],
      "stream_entries"=>["accounts", "statuses"],
      "users"=>["accounts"]
    }}

    let(:expected_result) {
      [
        "Level\tTable\tBelongsTo",
        "Lv1\taccounts\t",
        "Lv2\tfollows\taccounts",
        "Lv2\tstatuses\taccounts",
        "Lv2\tusers\taccounts",
        "Lv3\tfavourites\taccounts, statuses",
        "Lv3\tmentions\taccounts, statuses",
        "Lv3\tstream_entries\taccounts, statuses"
      ].join("\n")
    }
    
    it "belongs_to is not related each other" do
      core = DependLister::Core.new
      allow(core).to receive(:to_table_belongs_hash).and_return(table_blongs_hash)
      result = core.execute
      expect(result).to eq expected_result
    end
  end
end