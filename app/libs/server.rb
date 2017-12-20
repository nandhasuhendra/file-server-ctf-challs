class Libs::Server
  def initialize(port)
    @server = TCPServer.new(port)
  end
  
  def runServer
    begin
      puts "[!] [#{Time.now.ctime}]: Server is running on port #{@server.addr[2]}"
      loop do
        Thread.new(@server.accept) do |client|
          puts "[+] [#{Time.now.ctime}]: Client #{client.addr[2]} is connected."
          userRes = client.recv(1024)
          if userRes == 'Y'
            file = client.recv(1024)
            fileObj = Libs::Files.new
            if fileObj.create(client, file)
              readObj = Libs::Xmls.new(fileObj.get_file)
              readObj.read
            else
              puts "[-] [#{Time.now.ctime}]: Client #{client.addr[2]} is disconnected."
              client.close
            end
          else
            puts "[-] [#{Time.now.ctime}]: Client #{client.addr[2]} is disconnected."
            client.close
          end
        end
      end
    rescue => e
      puts "[!] [#{Time.now.ctime}]: Error is founded => #{e}"
    end
  end
end
