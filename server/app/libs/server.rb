class Libs::Server
  def initialize(ip_address, port)
    @server = TCPServer.new(ip_address, port)

    run
  end
  
  def run
    begin
      puts "[!] [#{Time.now.ctime}], %-7.7s --: Server is running on port %s" % ['INFO', @server.addr[2]]
      loop do
        Thread.new(@server.accept) do |client|
          puts "[+] [#{Time.now.ctime}], %-7.7s --: Client %s is connected." % ['INFO', client.addr[2]]
          userRes = client.recv(1)
          if userRes == 'Y'
            client.send 'req_file_info', 0
            file_info = client.recv(2048).split('|')
            filename  = file_info[0]
            size      = file_info[1]

            client.send 'req_file', 0
            fileObj = Libs::Files.new
            if fileObj.create(client, filename, size)
              readObj = Libs::Xmls.new(fileObj.get_file)
              readObj.read

              readObj.get_xml.each do |str|
                begin
                  send = str + "\n"
                  send_respond(client, eval(send))
                rescue => expt
                  send_respond(client, send)
                end
              end

              puts "[-] [#{Time.now.ctime}], %-7.7s --: Closing connection from Client %s." % ['INFO', client.addr[2]]
              client.close
            else
              puts "[-] [#{Time.now.ctime}], %-7.7s --: Client %s is cencel uploading." % ['INFO', client.addr[2]]
              client.close
            end
          else
            puts "[-] [#{Time.now.ctime}], %-7.7s --: Client %s is disconnected." % ['INFO', client.addr[2]]
            client.close
          end
        end
      end
    rescue => expt
      puts "[!] [#{Time.now.ctime}], %-7.7s --: %s" % ['ERROR', expt]
    end
  end

  def send_respond(client, data)
    client.send data.to_s, 0
  end  
end
