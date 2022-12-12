require 'mongo'


def add_to_db(client, collection, answers)
    doc = {
    name: answers[:name],
    "#{answers[:first_subject_name]}": answers[:first_subject_grade],
    "#{answers[:second_subject_name]}": answers[:second_subject_grade],
}
    collection.insert_one(doc)
end

def initialisation
    client = Mongo::Client.new('mongodb://localhost:27017/Accounts')
    collection = client[:Accounts]
    puts "Would you like to add an entry to the database? type 'y' or 'n', if you would like to delete an existing document, type 'delete'. If you would like to update an existing document, type 'update'. "
    entry = gets.chomp.downcase
    if entry == "y"
       answers = get_answers
       add_to_db(client, collection, answers)
    elsif entry == "n"
        puts "Nothing has been added, thankyou."
    elsif entry == "delete"
        delete(client, collection)
    elsif entry == "update"
        updateh = update(client, collection, answers, updateh)
        update(client, collection, answers, updateh)
    else
        puts "This letter has not been recongised."
    initialisation
    end
end

def get_answers
    puts "[To restart, type 'restart'] What is your first name?: "
    first_name = gets.chomp.capitalize
    if first_name == "Restart"
    initialisation
    end
    puts "[To restart, type 'restart'] What subject was your first A-Level?: "
    first_subject = gets.chomp.downcase
    if first_subject == "restart"
    initialisation
    end
    puts "[To restart, type 'restart'] What grade was your first A-Level?: "
    first_grade = gets.chomp.upcase
    if first_grade == "RESTART"
    initialisation
    end
    puts "[To restart, type 'restart'] What subject was your second A-Level?: "
    second_subject = gets.chomp.downcase
    if second_subject == "restart"
    initialisation
    end
    puts "[To restart, type 'restart'] What grade was your second A-Level?: "
    second_grade = gets.chomp.upcase
    if second_grade == "RESTART"
    initialisation
    end
    puts "Thankyou for adding your details, would you like to add another entry? type 'y' or 'n' to continue: "
    final = gets.chomp.downcase
    if final == 'y'
        initialisation
    elsif final == 'n'
        puts "Thankyou, your details have been updated to the system."
    else
        puts "This letter has not been recognised"
        initialisation
    end
    answers = {name: first_name, first_subject_name: first_subject, first_subject_grade: first_grade, second_subject_name: second_subject, second_subject_grade: second_grade}
    return answers
end


def delete(client, collection)
    puts "what is the name of the document you would like to delete?: "
    user_delete = gets.chomp.capitalize
    result = collection.find(:name => user_delete).delete_one
    if result.deleted_count == 1
        puts "This document has been succesfully deleted, thankyou."
    else puts "This document could not be found"
    end 
end

def update(client, collection, answers, updateh)
    puts "What is the first name of the document you would like to update?: "
    name_update = gets.chomp.capitalize
    puts "What is the first subject for this name you would like to update?: "
    first_subject_update = gets.chomp.capitalize
    puts "What is the grade for #{first_subject_update}?: "
    first_subject_update_grade = gets.chomp.upcase
    puts "What is the second subject for this name that you would like to update?: "
    second_subject_update = gets.chomp.capitalize
    puts "What is the grade for #{second_subject_update}?: "
    second_subject_update_grade = gets.chomp.upcase
    puts "Thankyou for these details, we will attempt to update this document."

    updateh = {name: name_update, subject1update: first_subject_update, subject1grade: first_subject_update_grade, subject2update: second_subject_update, subject2grade: second_subject_update_grade}

    result = collection.find(:name => updateh[:name]).update_one(:name => "#{updateh[:name]}", :"#{updateh[:subject1update]}" => updateh[:subject1grade], :"#{updateh[:subject2update]}" => updateh[:subject2grade] )
    result.n
end






initialisation