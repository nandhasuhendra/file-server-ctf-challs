require "socket"
require "highline/import"

class FileClient
  def initialize(ip, port)
    @socket = TCPSocket.new(ip, port)

    request
    response
  end

  def request
    filename = ask "[+] Input Filename -> "
    if File.exists? filename
      puts "[!] File #{filename} is available."
      puts "[!] File size is #{File.size(filename)} byte."
      ans = ask "[?] Do you want to upload this file? (Y/n) "
      if ans.upcase == 'Y'
        @socket.send ans.upcase, 0
        @socket.send filename, 0
        @socket.send File.size(filename).to_s, 0
        File.open(filename, 'rb') do |file|
          buff = file.read
          @socket.send buff, 0
        end
      else
        puts "[!] Upload has been cencel!"
      end
    else
      puts "[!] File doesn't available!"
    end
  end

  def response
    puts "="*10
    puts @socket.gets
  end
end


if __FILE__ == $0
  FileClient.new('127.0.0.1',31337)
end
