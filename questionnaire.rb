require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze


class Survey
  def self.do_prompt
    loop do
      data = load_data
      correct_answer = 0
      puts "\nPlease enter the Answers in 'Yes', 'Y', 'No' or 'N' format only. \n\n"
      QUESTIONS.each_key do |question_key|
        print QUESTIONS[question_key]
        ans = gets.chomp
        if ans != "Yes" && ans != "Y" && ans != "No" && ans != "N"
          puts "Incorrect value entered. Please answer the question in 'Yes', 'Y', 'No' or 'N' format only. \n"
          redo
        elsif ans == "Yes" || ans == "Y"
          correct_answer += 1
        end
      end

      rating = (correct_answer.to_i * 100)/QUESTIONS.count
      puts "\n Rating for this run: #{rating}\n "

      save_data({ correct_answers: correct_answer, rating: rating })
      average_rating = calculate_average_rating(data + [{ rating: rating }])
      puts "\n Average rating across all runs: #{average_rating}\n "

      print "\n Do you want to run the survey again? (Yes/No): \n"
      answer = gets.chomp.downcase
      break unless %w[yes y].include?(answer)
    end
  end

  def self.load_data
    store = PStore.new(STORE_NAME)
    store.transaction do
      store[:runs] ||= []
    end
  end
  
  def self.save_data(data)
    store = PStore.new(STORE_NAME)
    store.transaction do
      store[:runs] << data
    end
  end
  
  def self.calculate_rating(correct_answers)
    (100.0 * correct_answers / QUESTIONS.size).round(2)
  end
  
  def self.calculate_average_rating(data)
    total_rating = data.sum { |run| run[:rating] }
    (total_rating / data.size).round(2)
  end
end



Survey.do_prompt if __FILE__ == $PROGRAM_NAME