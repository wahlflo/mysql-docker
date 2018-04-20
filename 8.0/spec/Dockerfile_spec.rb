require "docker"
require "serverspec"

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, family: :redhat
    set :backend, :docker
    set :docker_image, @image.id
    set :docker_container_create_options, { 'Entrypoint' => ['bash'] }
  end

  it 'exposes correct ports' do
    expect(@image.json['ContainerConfig']['ExposedPorts']).to include("6446/tcp")
    expect(@image.json['ContainerConfig']['ExposedPorts']).to include("6447/tcp")
    expect(@image.json['ContainerConfig']['ExposedPorts']).to include("64460/tcp")
    expect(@image.json['ContainerConfig']['ExposedPorts']).to include("64470/tcp")
  end
  it "sets maintainer label" do
    expect(@image.json["Config"]["Labels"].has_key?("maintainer"))
  end
  
  it "sets run.sh as entrypoint" do
    expect(@image.json["Config"]["Entrypoint"][0]).to eq("/run.sh")
  end

  it "passes mysqlrouter by default" do
    expect(@image.json["Config"]["Cmd"][0]).to eq("mysqlrouter")
  end
  
  it 'is based on oraclelinux' do
    expect(file('/etc/oracle-release')).to be_file
  end
  
  it 'installs required packages' do
    expect(package('mysql-community-server-minimal')).to be_installed
    expect(package('mysql-router')).to be_installed.with_version('8.0.11')
  end
end
