class Libs::Server
  def initialize(port)
    @server = TCPServer.new(port)

    run
  end
  
  def run
    begin
      puts "[!] [#{Time.now.ctime}]: Server is running on port #{@server.addr[2]}"
      loop do
        Thread.new(@server.accept) do |client|
          puts "[+] [#{Time.now.ctime}]: Client #{client.addr[2]} is connected."
          userRes = client.recv(1024)
          $stdin.flush
          if userRes == 'Y'
            file = client.recv(1024)
            size = client.recv(1024)
            fileObj = Libs::Files.new
            if fileObj.create(client, file, size)
              readObj = Libs::Xmls.new(fileObj.get_file)
              readObj.read
              $stdin.flush

              send_respond(client, readObj.get_docx)
            else
              puts "[-] [#{Time.now.ctime}]: Client #{client.addr[2]} is cencel uploding."
              $stdin.flush
              client.close
            end
          else
            puts "[-] [#{Time.now.ctime}]: Client #{client.addr[2]} is disconnected."
            $stdin.flush
            client.close
          end
        end
      end
    rescue => e
      puts "[!] [#{Time.now.ctime}]: Error is founded => #{e}"
      $stdin.flush
    end
  end

  def send_respond(client, data)
    client.send "AAAAAAA", 0 
  end  
end
