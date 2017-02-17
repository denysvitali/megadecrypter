require "./megadecrypter/*"
require "openssl/cipher"
require "base64"
require "secure_random"

module Megadecrypter
  class Crypto
    @enc_xor = [12, 0x39, 0xfb, 120, 0x12, 0x4b, 6, 250, 0x55]
    @pwd2 = "nYrXa@9Q\x00bf1&hCWM\\9(731Bp?t42=!k3.";

    def getBytes
      #length = 0
      #remaining = 0
      #byteDecKey = [] of UInt8
      #temp = ""

      #length = @pwd2.size
      #if length >= 32
      #  temp = @pwd2[0, 32]
      #else
      #  remaining = 32 - length
      #  temp = @pwd2 + "X"*remaining
      #end

      ##byteDecKey = temp.to_slice

      #array = [] of UInt8
      #temp.each_char do |char|
      #  array << char.bytes[0] unless !char.ascii?
      #end

      #puts array
      ##byteDecKey = array
      #maxBK = array.size - 1


      #0.upto(159) do |i|
      #  byteDecKey[i % 32] = byteDecKey[i % 32] ^ @enc_xor[i % 9]
      #  puts "#{byteDecKey[i%32]}^#{@enc_xor[i%9]} = #{byteDecKey[i % 32] ^ @enc_xor[i % 9]} (#{i % maxBK})"
      #end
      #slice = Slice(UInt8).new(32)
      ##puts slice
      #0.upto(maxBK) do |i|
      #  #puts byteDecKey[i]
      #  slice[i] = byteDecKey[i]
      #end
      #slice
      Base64.decode("7R9MIAs1E5gGsmBWOz04dvARtHUPOhpKXv0LvmdVS0Q=")
    end

    def decrypt(string)
      string = Base64.decode(cleanString(string))
      key = getBytes()
      iv = UInt8.slice(0x79, 0xf1, 10, 1, 0x84, 0x4a, 11, 0x27, 0xff, 0x5b, 0x2d, 0x4e, 14, 0xd3, 0x16, 0x3e)

      ciphertext = string.to_slice
      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      buffer4 = string.to_slice
      cipher.decrypt
      cipher.iv = iv
      cipher.key = key
      s1 = IO::Memory.new
      s1.write(cipher.update(buffer4))
      s1.write(cipher.final)
      s1 = s1.to_s
      s1 = s1.gsub("+", "-")
           .gsub("/", "_")
           .gsub("=", "")
      s1
    end

    def cleanString(string)
      string = string
        .gsub("-","+")
        .gsub("_", "/")
        .gsub(",", "")
      string + "=="
    end
  end

  def self.decryptLink(string)
    # mega://enc2?lsV5qNM_0Mfq0DlWxCPvJdD...
    mdata = string.match(/^mega:\/\/(f|)enc2\?(.*)$/i)
    if mdata
      folder = mdata[1] == "f"
      dec = Crypto.new.decrypt(mdata[2])
      md2 = dec.match(/^(.*?)\!(.*)$/)
      if md2
        if folder
          puts "https://mega.nz/#F#{dec}"
        else
          puts "https://mega.nz/##{dec}"
        end
      end
    else
      puts "Invalid mega encrypted link"
    end
  end

  def self.printHelp()
    puts "Usage: ./megadec mega://enc2?encryptedString"
  end

  if ARGV.size < 1
    self.printHelp()
  end

  self.decryptLink(ARGV[0])
end
