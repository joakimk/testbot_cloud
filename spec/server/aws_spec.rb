require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Server::AWS, "bootstrap!" do

  it "should return false if the online check fails" do
    fog_server = mock(Object, :dns_name => "server.somewhere.ec2", :id => "i-aaa")
    server = TestbotCloud::Server::AWS.new(nil, fog_server)
    
    server.bootstrap.should_receive(:system).any_number_of_times.with("ssh -o StrictHostKeyChecking=no -i testbot.pem ubuntu@server.somewhere.ec2 'true' &> /dev/null").and_return(false)
    server.bootstrap.stub!(:sleep)
    server.bootstrap.stub!(:puts)
    server.bootstrap!(Mutex.new).should be_false
  end

  it "should upload bootstrap files and run them" do
    fog_server = mock(Object, :dns_name => "server.somewhere.ec2", :id => "i-aaa")
    server = TestbotCloud::Server::AWS.new(nil, fog_server)
    
    server.bootstrap.should_receive(:system).and_return(true)
    server.bootstrap.should_receive(:system).with("scp -r bootstrap -o StrictHostKeyChecking=no -i testbot.pem ubuntu@server.somewhere.ec2:~ &> /dev/null").and_return(true)
    server.bootstrap.should_receive(:system).with("ssh -o StrictHostKeyChecking=no -i testbot.pem ubuntu@server.somewhere.ec2 'cd bootstrap; sudo sh runner.sh' &> /dev/null").and_return(true)

    server.bootstrap.stub!(:sleep)
    server.bootstrap!(Mutex.new).should be_true
  end

end

