class ServersController < ApplicationController
  def show
    ips = ['de.qlrace.com', 'tx.qlrace.com']
    ports = [27960, 27961]
    servers = []
    ips.each do |ip|
      ports.each do |port|
        servers << SourceServer.new(ip, port)
      end
    end
    byebug
  end
end
