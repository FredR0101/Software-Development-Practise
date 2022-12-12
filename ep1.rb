require 'openssl'
require 'uri'

cipher = OpenSSL::Cipher::AES.new(256, :CBC)
cipher.encrypt

key = cipher.random_key
iv = cipher.random_iv

puts "What would you like to encrypt?: "
user_input = gets.chomp
userinput1 = user_input

encrypted = cipher.update(userinput1) + cipher.final 

puts "#{user_input} is equal to #{encrypted}"

decipher = OpenSSL::Cipher::AES.new(256, :CBC)

decipher.decrypt
decipher.key = key
decipher.iv = iv

puts "Would you like to decrypt your previous message #{userinput1} back to normal? type 'y' or 'n'."
decrypt_input1 = gets.chomp
if decrypt_input1 == "y"
  plain = decipher.update(encrypted) + decipher.final
else
  puts "Thankyou."
end 

puts "#{encrypted} has been decrypted to #{plain}"