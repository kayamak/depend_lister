require "pry"
require "depend_lister/depend_lister_core"

RSpec.describe DependListerCore do
  subject {DependListerCore.new.execute}

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
        "Lv3\tstream_entries\taccounts, statuses",
        "Lv4\t\t"
      ].join("\n")
    }
    it "belongs_to is not related each other" do
      allow_any_instance_of(Belong).to receive(:make_table_belongs_hash).and_return(table_blongs_hash)
      expect(subject).to eq expected_result
    end
  end
  context "there are belongs_to related each other" do
    let(:table_blongs_hash)  {{
      "aim_associations"=>["aim_types", "aim_styles"],
      "aim_styles"=>["avail_accounts"],
      "aim_types"=>[],
      "alteration_view_aim_words"=>["fonts", "alteration_view_aims"],
      "alteration_view_aims"=>["alteration_views", "aim_associations", "view_aims"],
      "alteration_view_components"=>["alteration_views", "components"],
      "alteration_view_logo_aims"=>["alteration_views"],
      "alteration_view_story_board_associations"=>["alteration_views", "story_boards"],
      "alteration_view_words"=>["alteration_views", "view_words"],
      "alteration_views"=>["views", "alterations", "transforms", "view_partitions", "view_transitions", "view_blueprints"],
      "alterations"=>["tasks", "blueprint_sets", "output_form_types", "tint_variations", "bgms"],
      "ambience_tags"=>["guide_categories", "tags"],
      "avail_account_options"=>["avail_accounts"],
      "avail_accounts"=>["avails"],
      "avails"=>[],
      "blueprint_set_compabilities"=>["blueprint_sets", "tint_variations"],
      "blueprint_sets"=>["view_transitions", "tint_mats", "view_aims", "avail_accounts"],
      "build_histories"=>["alterations"],
      "component_categories"=>[],
      "component_component_categories"=>["components", "component_categories"],
      "component_tasks"=>["components", "tasks"],
      "components"=>["avail_accounts"],
      "fonts"=>[],
      "guide_categories"=>["guide_categories"],
      "guide_guide_categories"=>["guides", "guide_categories"],
      "guide_variations"=>["guides", "output_form_types"],
      "guides"=>["avail_accounts"],
      "main_word_alignments"=>["aim_associations"],
      "output_form_types"=>[],
      "position_arrangements"=>["view_partitions", "output_form_types", "aim_associations"],
      "preset_form_preset_form_tags"=>["preset_forms", "preset_form_tags"],
      "preset_form_tags"=>[],
      "preset_forms"=>["tasks"],
      "public_api_calls"=>["avail_accounts"],
      "purpose_guide_categories"=>["purposes", "guide_categories"],
      "purposes"=>[],
      "shared_alteration_credentials"=>["alterations"],
      "neo_stockphoto_tags"=>["neo_stockphotos", "tags"],
      "stockphotos"=>["components", "avail_accounts"],
      "neo_stockphotos"=>[],
      "story_board_words"=>["story_boards"],
      "story_boards"=>["alterations", "components"],
      "sub_word_alignments"=>["aim_associations"],
      "tags"=>[],
      "tasks"=>["avail_accounts", "purposes", "output_form_types", "preset_forms"],
      "tint_codes"=>["views"],
      "tint_mats"=>[],
      "tint_variation_tags"=>["tint_variations", "tags"],
      "tint_variations"=>["guide_variations"],
      "transcript_words"=>["components"],
      "transforms"=>[],
      "view_aim_words"=>["view_aims", "fonts"],
      "view_aims"=>["aim_types", "aim_styles"],
      "view_blueprint_thumbnails"=>["view_blueprints", "output_form_types"],
      "view_blueprints"=>["view_partitions"],
      "view_partition_blocks"=>["view_partitions", "output_form_types"],
      "view_partitions"=>[],
      "view_transitions"=>["avail_accounts"],
      "view_word_tints"=>["view_words"],
      "view_words"=>["views", "fonts"],
      "views"=>["tint_variations", "transforms"],
      "another_preset_forms"=>["another_tasks"],
      "another_tasks"=>["avail_accounts", "purposes", "output_form_types", "another_preset_forms"],
    }}

    let(:expected_result) {
      [
        "Level\tTable\tBelongsTo",
        "Lv1\taim_types\t",
        "Lv1\tavails\t",
        "Lv1\tcomponent_categories\t",
        "Lv1\tfonts\t",
        "Lv1\tguide_categories\tguide_categories",
        "Lv1\tneo_stockphotos\t",
        "Lv1\toutput_form_types\t",
        "Lv1\tpreset_form_tags\t",
        "Lv1\tpurposes\t",
        "Lv1\ttags\t",
        "Lv1\ttint_mats\t",
        "Lv1\ttransforms\t",
        "Lv1\tview_partitions\t",
        "Lv2\tambience_tags\tguide_categories, tags",
        "Lv2\tavail_accounts\tavails",
        "Lv2\tpurpose_guide_categories\tpurposes, guide_categories",
        "Lv2\tneo_stockphoto_tags\tneo_stockphotos, tags",
        "Lv2\tview_blueprints\tview_partitions",
        "Lv2\tview_partition_blocks\tview_partitions, output_form_types",
        "Lv3\taim_styles\tavail_accounts",
        "Lv3\tavail_account_options\tavail_accounts",
        "Lv3\tcomponents\tavail_accounts",
        "Lv3\tguides\tavail_accounts",
        "Lv3\tpublic_api_calls\tavail_accounts",
        "Lv3\tview_blueprint_thumbnails\tview_blueprints, output_form_types",
        "Lv3\tview_transitions\tavail_accounts",
        "Lv4\taim_associations\taim_types, aim_styles",
        "Lv4\tcomponent_component_categories\tcomponents, component_categories",
        "Lv4\tguide_guide_categories\tguides, guide_categories",
        "Lv4\tguide_variations\tguides, output_form_types",
        "Lv4\tstockphotos\tcomponents, avail_accounts",
        "Lv4\ttranscript_words\tcomponents",
        "Lv4\tview_aims\taim_types, aim_styles",
        "Lv5\tblueprint_sets\tview_transitions, tint_mats, view_aims, avail_accounts",
        "Lv5\tmain_word_alignments\taim_associations",
        "Lv5\tposition_arrangements\tview_partitions, output_form_types, aim_associations",
        "Lv5\tsub_word_alignments\taim_associations",
        "Lv5\ttint_variations\tguide_variations",
        "Lv5\tview_aim_words\tview_aims, fonts",
        "Lv6\tblueprint_set_compabilities\tblueprint_sets, tint_variations",
        "Lv6\ttint_variation_tags\ttint_variations, tags",
        "Lv6\tviews\ttint_variations, transforms",
        "Lv7\ttint_codes\tviews",
        "Lv7\tview_words\tviews, fonts",
        "Lv8\tview_word_tints\tview_words",
        "Lv9\t\t",
        "Lv10\tpreset_forms\ttasks",
        "Lv10\ttasks\tavail_accounts, purposes, output_form_types, preset_forms",
        "Lv11\talterations\ttasks, blueprint_sets, output_form_types, tint_variations, bgms",
        "Lv11\tcomponent_tasks\tcomponents, tasks",
        "Lv11\tpreset_form_preset_form_tags\tpreset_forms, preset_form_tags",
        "Lv12\talteration_views\tviews, alterations, transforms, view_partitions, view_transitions, view_blueprints",
        "Lv12\tbuild_histories\talterations",
        "Lv12\tshared_alteration_credentials\talterations",
        "Lv12\tstory_boards\talterations, components",
        "Lv13\talteration_view_aims\talteration_views, aim_associations, view_aims",
        "Lv13\talteration_view_components\talteration_views, components",
        "Lv13\talteration_view_logo_aims\talteration_views",
        "Lv13\talteration_view_story_board_associations\talteration_views, story_boards",
        "Lv13\talteration_view_words\talteration_views, view_words",
        "Lv13\tstory_board_words\tstory_boards",
        "Lv14\talteration_view_aim_words\tfonts, alteration_view_aims",
        "Lv15\t\t",
        "Lv16\tanother_preset_forms\tanother_tasks",
        "Lv16\tanother_tasks\tavail_accounts, purposes, output_form_types, another_preset_forms",
        "Lv17\t\t"
      ].join("\n")
    }
    
    it "belongs_to is related each other" do
      allow_any_instance_of(Belong).to receive(:make_table_belongs_hash).and_return(table_blongs_hash)
      expect(subject).to eq expected_result
    end
  end
end