$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../config', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../redis', __FILE__)

require 'fileutils'
require 'streamio-ffmpeg'
require 'etc'
require 'dedenne'
require 'redis_connector'

ENV['RACK_ENV'] = 'test'

# Export s3 access id/key for example:
# ENV['AWS_S3_ACCESS_KEY_ID'] = 'foo'
# ENV['AWS_S3_SECRET_ACCESS_KEY'] =  'bar'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
