RSpec.configure do |config|
  config.before :suite do
    options = YAML.load_file 'spec/parature.yml'
    @options = Hash[ options.keys.collect(&:to_sym).zip options.values ]
    Parature.config @options

    require './spec/vcr_setup.rb'
  end
end

