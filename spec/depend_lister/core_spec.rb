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
  context "there are belongs_to related each other" do
    let(:table_blongs_hash)  {{
      "purpose"=>["belongs_to"],
      "tint_mats"=>[],
      "component_categories"=>[],
      "fonts"=>[],
      "stockphotos"=>[],
      "aim_types"=>[],
      "output_form_types"=>[],
      "preset_form_tags"=>[],
      "purposes"=>[],
      "view_partitions"=>[],
      "avails"=>[],
      "tags"=>[],
      "transforms"=>[],
      "guide_categories"=>["guide_category"],
      "ambience_tags"=>["guide_category", "tag"],
      "stockphoto_tags"=>["stockphoto", "tag"],
      "purpose_guide_categories"=>["purpose", "guide_category"],
      "view_blueprints"=>["view_partition"],
      "view_partition_blocks"=>["view_partition", "output_form_type"],
      "avail_accounts"=>["avail"],
      "components"=>["avail_account"],
      "guides"=>["avail_account"],
      "aim_styles"=>["avail_account"],
      "public_api_calls"=>["avail_account"],
      "view_blueprint_thumbnails"=>["view_blueprint", "output_form_type"],
      "view_transitions"=>["avail_account"],
      "avail_account_options"=>["avail_account"],
      "component_component_categories"=>["component", "component_category"],
      "guide_guide_categories"=>["guide", "guide_category"],
      "guide_variations"=>["guide", "output_form_type"],
      "aim_associations"=>["aim_type", "aim_style"],
      "view_aims"=>["aim_type", "aim_style"],
      "stockphotos"=>["component", "avail_account"],
      "transcript_words"=>["component"],
      "tint_variations"=>["guide_variation"],
      "blueprint_sets"=>["view_transition", "tint_mat", "view_aim", "avail_account"],
      "main_word_alignments"=>["aim_association"],
      "position_arrangements"=>["view_partition", "output_form_type", "aim_association"],
      "view_aim_words"=>["view_aim", "font"],
      "sub_word_alignments"=>["aim_association"],
      "tint_variation_tags"=>["tint_variation", "tag"],
      "blueprint_set_compabilities"=>["blueprint_set", "tint_variation"],
      "views"=>["tint_variation", "transform"],
      "tint_codes"=>["view"],
      "view_words"=>["view", "font"],
      "view_word_tints"=>["view_word"],
      "tasks"=>["avail_account", "purpose", "output_form_type", "preset_form"],
      "preset_forms"=>["task"],
      "component_tasks"=>["component", "task"],
      "alterations"=>["task", "blueprint_set", "output_form_type", "tint_variation", "bgm"],
      "preset_form_preset_form_tags"=>["preset_form", "preset_form_tag"],
      "build_histories"=>["alteration"],
      "story_boards"=>["alteration", "component"],
      "shared_alteration_credentials"=>["alteration"],
      "alteration_views"=>["view", "alteration", "transform", "view_partition", "view_transition", "view_blueprint"],
      "story_board_words"=>["story_board"],
      "alteration_view_logo_aims"=>["alteration_view"],
      "alteration_view_components"=>["alteration_view", "component"],
      "alteration_view_story_board_associations"=>["alteration_view", "story_board"],
      "alteration_view_aims"=>["alteration_view", "aim_association", "view_aim"],
      "alteration_view_words"=>["alteration_view", "view_word"],
      "alteration_view_aim_words"=>["font", "alteration_view_aim"],
      "schema_migrations"=>[""],
      "ars"=>[""],
      "delayed_jobs"=>[""],
      "downloads"=>[""]
    }}

    let(:expected_result) {
      [
        "Lv1"=>"tint_mats\t\t",
        "Lv1"=>"component_categories\t\t",
        "Lv1"=>"fonts\t\t",
        "Lv1"=>"stockphotos\t\t",
        "Lv1"=>"aim_types\t\t",
        "Lv1"=>"output_form_types\t\t",
        "Lv1"=>"preset_form_tags\t\t",
        "Lv1"=>"purposes\t\t",
        "Lv1"=>"view_partitions\t\t",
        "Lv1"=>"avails\t\t",
        "Lv1"=>"tags\t\t",
        "Lv1"=>"transforms\t\t",
        "Lv1"=>"guide_categories\tguide_category\t",
        "Lv2"=>"ambience_tags\tguide_category, tag\t",
        "Lv2"=>"stockphoto_tags\tstockphoto, tag\t",
        "Lv2"=>"purpose_guide_categories\tpurpose, guide_category\t",
        "Lv2"=>"view_blueprints\tview_partition\t",
        "Lv2"=>"view_partition_blocks\tview_partition, output_form_type\t",
        "Lv2"=>"avail_accounts\tavail\t",
        "Lv3"=>"components\tavail_account\t",
        "Lv3"=>"guides\tavail_account\t",
        "Lv3"=>"aim_styles\tavail_account\t",
        "Lv3"=>"public_api_calls\tavail_account\t",
        "Lv3"=>"view_blueprint_thumbnails\tview_blueprint, output_form_type\t",
        "Lv3"=>"view_transitions\tavail_account\t",
        "Lv3"=>"avail_account_options\tavail_account\t",
        "Lv4"=>"component_component_categories\tcomponent, component_category\t",
        "Lv4"=>"guide_guide_categories\tguide, guide_category\t",
        "Lv4"=>"guide_variations\tguide, output_form_type\t",
        "Lv4"=>"aim_associations\taim_type, aim_style\t",
        "Lv4"=>"view_aims\taim_type, aim_style\t",
        "Lv4"=>"stockphotos\tcomponent, avail_account\t",
        "Lv4"=>"transcript_words\tcomponent\t",
        "Lv5"=>"tint_variations\tguide_variation\t",
        "Lv5"=>"blueprint_sets\tview_transition, tint_mat, view_aim, avail_account\t",
        "Lv5"=>"main_word_alignments\taim_association\t",
        "Lv5"=>"position_arrangements\tview_partition, output_form_type, aim_association\t",
        "Lv5"=>"view_aim_words\tview_aim, font\t",
        "Lv5"=>"sub_word_alignments\taim_association\t",
        "Lv6"=>"tint_variation_tags\ttint_variation, tag\t",
        "Lv6"=>"blueprint_set_compabilities\tblueprint_set, tint_variation\t",
        "Lv6"=>"views\ttint_variation, transform\t",
        "Lv7"=>"tint_codes\tview\t",
        "Lv7"=>"view_words\tview, font\t",
        "Lv8"=>"view_word_tints\tview_word\t",
        "Lv9"=>"tasks\tavail_account, purpose, output_form_type, preset_form\t",
        "Lv10"=>"preset_forms\ttask\t",
        "Lv10"=>"component_tasks\tcomponent, task\t",
        "Lv10"=>"alterations\ttask, blueprint_set, output_form_type, tint_variation, bgm\t",
        "Lv11"=>"preset_form_preset_form_tags\tpreset_form, preset_form_tag\t",
        "Lv11"=>"build_histories\talteration\t",
        "Lv11"=>"story_boards\talteration, component\t",
        "Lv11"=>"shared_alteration_credentials\talteration\t",
        "Lv11"=>"alteration_views\tview, alteration, transform, view_partition, view_transition, view_blueprint\t",
        "Lv12"=>"story_board_words\tstory_board\t",
        "Lv12"=>"alteration_view_logo_aims\talteration_view\t",
        "Lv12"=>"alteration_view_components\talteration_view, component\t",
        "Lv12"=>"alteration_view_story_board_associations\talteration_view, story_board\t",
        "Lv12"=>"alteration_view_aims\talteration_view, aim_association, view_aim\t",
        "Lv12"=>"alteration_view_words\talteration_view, view_word\t",
        "Lv13"=>"alteration_view_aim_words\tfont, alteration_view_aim\t"  
      ].join("\n")
    }
    
    it "belongs_to is related each other" do
      core = DependLister::Core.new
      allow(core).to receive(:to_table_belongs_hash).and_return(table_blongs_hash)
      result = core.execute
      expect(result).to eq expected_result
    end
  end
end