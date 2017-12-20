require "socket"
require "highline/import"

def fileClient(ip, port)
  socket = TCPSocket.new(ip, port)

  filename = ask "[+] Input Filename -> "
  if File.exists? filename
    puts "[!] File #{filename} is available."
    puts "[!] File size is #{File.size(filename)} byte."
    ans = ask "[?] Do you want to upload this file? (Y/n) "
    if ans.upcase == 'Y'
      socket.send ans.upcase, 0
      socket.send filename, 0
      File.open(filename, 'rb') do |file|
        file.each do |buff|
          socket.send buff, 0
        end
      end
    else
      puts "[!] Upload has been cencel!"
    end
  else
    puts "[!] File doesn't available!"
  end
end

if __FILE__ == $0
  fileClient('127.0.0.1',31337)
end
