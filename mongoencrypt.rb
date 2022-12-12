require 'mongo'
require 'openssl'
require 'uri'
require 'json'
require 'base64'


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
    puts "Would you like to add a document to this secret database? type 'y' or 'n' to continue: "
    user_input = gets.chomp.downcase
    if user_input == "y"
        answers = get_answers
        add_to_db(client, collection, answers)
    elsif user_input == " "
        puts "White space is not prohibited"
        initialisation
    else user_input == "n"
        puts "Your input has been noted and this program will end."
    end
end

def get_answers

    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv

    puts "What name would you like to have for this document?: "
    user_name = gets.chomp.capitalize
    if user_name == " "
        puts "White space is not prohibited"
        return get_answers
    end 
    puts "What secret information would you like to be encrypted?: "
    user_encryption = gets.chomp
    if user_encryption == " "
        puts "White space is not prohibited"
        return get_answers
    else
        puts "This has now encrypted and saved in the database, thankyou."
        encrypted = cipher.update(user_encryption.to_json) + cipher.final
        encoded = CGI.escape(Base64.encode64(encrypted))
    end
    answers = {name: user_name, final_encrypt: encoded}
    return answers
end

initialisation