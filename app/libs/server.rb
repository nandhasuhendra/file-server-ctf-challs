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
          userRes = client.recv(1)
          if userRes == 'Y'
            client.send 'req_file_info', 0
            file_info = client.recv(2048).split('|')
            filename = file_info[0]
            size     = file_info[1]

            client.send 'req_file', 0
            fileObj = Libs::Files.new
            if fileObj.create(client, filename, size)
              readObj = Libs::Xmls.new(fileObj.get_file)
              readObj.read

              readObj.get_docx.each do |str|
                begin
                  send = str + "\n"
                  send_respond(client, eval(send))
                rescue => e
                  send_respond(client, send)
                end
              end

              puts "[-] [#{Time.now.ctime}]: Closing connection from Client #{client.addr[2]}."
              client.close
            else
              puts "[-] [#{Time.now.ctime}]: Client #{client.addr[2]} is cencel uploding."
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

  def send_respond(client, data)
    client.send data.to_s, 0
  end  
end
