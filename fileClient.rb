require "socket"
require "highline/import"

class FileClient
  def initialize(ip, port)
    @socket = TCPSocket.new(ip, port)

    send_file
    get_respond
  end

  def send_file
    filename = ask "[+] Input Filename -> "
    if File.exists? filename
      puts "[!] File #{filename} is available."
      puts "[!] File size is #{File.size(filename)} byte."
      ans = ask "[?] Do you want to upload this file? (Y/n) "
      if ans.upcase == 'Y'
        @socket.send ans.upcase, 0
        @socket.send filename, 0
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

  def get_respond
    #puts @socket.gets.chomp
  end
end


if __FILE__ == $0
  FileClient.new('127.0.0.1',31337)
end
