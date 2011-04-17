require File.expand_path(File.join(File.dirname(__FILE__), '../../spec_helper.rb'))

describe TestbotCloud::Server::Bootstrap do

  it "should be able to upload bootstrap files and run them" do
    bootstrap = TestbotCloud::Server::Bootstrap.new("15.14.13.12", "srv-foo")

    bootstrap.should_receive(:system).and_return(true)
    bootstrap.should_receive(:system).with("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@15.14.13.12:~ &> /dev/null").and_return(true)
    bootstrap.should_receive(:system).with("ssh -o StrictHostKeyChecking=no ubuntu@15.14.13.12 'cd bootstrap; sudo sh runner.sh' &> /dev/null").and_return(true)

    bootstrap.stub!(:sleep)
    bootstrap.install
  end

  it "should try to get a connection going before running bootstrap" do
    bootstrap = TestbotCloud::Server::Bootstrap.new("15.14.13.12", "srv-foo")

    bootstrap.should_receive(:system).and_return(false)
    bootstrap.should_receive(:system).and_return(false)
    bootstrap.should_receive(:system).and_return(true)
    bootstrap.should_receive(:system).with("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@15.14.13.12:~ &> /dev/null").and_return(true)
    bootstrap.should_receive(:system).with("ssh -o StrictHostKeyChecking=no ubuntu@15.14.13.12 'cd bootstrap; sudo sh runner.sh' &> /dev/null").and_return(true)

    bootstrap.stub!(:sleep).any_number_of_times
    bootstrap.install
  end

  it "should not try to bootstrap if the connection fails" do
    bootstrap = TestbotCloud::Server::Bootstrap.new("15.14.13.12", "srv-foo")
    bootstrap.stub!(:system).and_return(false)
    bootstrap.should_not_receive(:system).with("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@15.14.13.12:~ &> /dev/null")

    bootstrap.stub!(:sleep)
    bootstrap.stub!(:puts)
    bootstrap.install
  end

end
