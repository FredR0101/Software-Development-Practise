require 'mongo'
require 'openssl'
require 'uri'
require 'json'
require 'base64'
require 'dotenv/load'
require 'byebug'


def add_to_db(client, collection, answers)
    doc = {
        name: answers[:name],
        secret_data: answers[:final_encrypt],

    }
        collection.insert_one(doc)
end


def initialisation
    client = Mongo::Client.new('mongodb://localhost:27017/secretinfo')
    collection = client[:secrets]
    key = ENV['ENCRYPTION_KEY']
    iv = ENV['ENCRYPTION_IV']
    
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv


    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv

    puts "Would you like to add a document to this secret database? type 'y' or 'n' to continue, if you would like to review your document, type 'review': "
    user_input = gets.chomp.downcase
    if user_input == "y"
        answers = get_answers(key, iv, cipher)
        add_to_db(client, collection, answers)
    elsif user_input == " "
        puts "White space is not prohibited"
        initialisation
    elsif user_input == "review"
        review(client, collection, decipher, key, iv)
    else user_input == "n"
        puts "Your input has been noted and this program will end."
    end
end

def get_answers(key, iv, cipher)

    puts "What name would you like to have for this document?: "
    user_name = gets.chomp.capitalize
    if user_name == " "
        puts "White space is not prohibited"
        return get_answers(key, iv, cipher)
    end 
    puts "What secret information would you like to be encrypted?: "
    user_encryption = gets.chomp
    if user_encryption == " "
        puts "White space is not prohibited"
        return get_answers(key, iv, cipher)
    else
        puts "This has now encrypted and saved in the database, thankyou."
        encrypted = cipher.update(user_encryption.to_json) + cipher.final
        encoded = Base64.encode64(encrypted)
    end
    answers = {name: user_name, final_encrypt: encoded}
    return answers
end

def review(client, collection, decipher, key, iv)


    puts "What is the name of the document you wish to review?: "
    user_review_decrypt = gets.chomp.capitalize
    result = collection.find(:name => user_review_decrypt)
    decoded = Base64.decode64(result.first[:secret_data])
    if result.count == 1
        plain = decipher.update(decoded) + decipher.final
        data = JSON.parse(plain)
        puts "This has been found, the stored data for #{user_review_decrypt} is: #{data}"
    else
        puts "We have been unable to locate this file"
        review(client, collection, decipher, key, iv)
    end
end



initialisation