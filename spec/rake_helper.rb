require 'rake'
RSpec.configure do |config|
  config.before(:suite) do
    # Load all the tasks just as Rails does (`load 'Rakefile'` is another simple way)
    Rails.application.load_tasks 
  end

  config.before(:each) do
    # Remove persistency between examples
    Rake.application.tasks.each(&:reenable) 
  end
end
