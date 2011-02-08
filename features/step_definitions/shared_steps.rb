Given /^there is no project$/ do
  system "rm -rf tmp/cluster"
end

When /^I generate a project$/ do
  system("bin/testbot_cloud new tmp/cluster 1> /dev/null") || raise
end

Then /^there should be a project folder$/ do
  File.exists?("tmp/cluster") || raise
end

Then /^the project folder should contain a config file$/ do
  File.exists?("tmp/cluster/config.yml") || raise
end

Then /^the project folder should contain bootstrap files$/ do
  File.exists?("tmp/cluster/bootstrap/runner.sh") || raise
end

Given /^I start the testbot cluster$/ do
  @results = `cd tmp/cluster; INTEGRATION_TEST=true ../../bin/testbot_cloud start 2>&1`
end

Then /^I should see "([^"]*)"$/ do |text|
  @results.include?(text) || raise
end

Then /^I should not see any errors$/ do
  if @results.include?("testbot_cloud/lib")
    puts @results
    raise
  end
end

