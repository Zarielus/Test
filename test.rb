require 'telegram/bot'

token = ""



Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Привіт! Я бот для тестування Ruby.")
    when '/test'
      questions = {
        'Яка функція використовується для виводу тексту на консоль?' => 'puts',
        'Який метод використовується для додавання елемента до масиву?' => 'push',
        'Як перевірити, чи містить масив певний елемент?' => 'include',
        'Який оператор використовується для порівняння значень?' => '==',
        'Яка конструкція використовується для умовного виконання коду?' => 'if',
        'Як видалити елемент з масиву?' => 'delete',
        'Як визначити довжину масиву?' => 'length',
        'Як перетворити рядок в символи верхнього регістру?' => 'upcase',
        'Як округлити число до найближчого цілого?' => 'round',
        'Яка функція використовується для отримання введення від користувача?' => 'gets',
        'Який метод використовується для злиття двох масивів?' => 'concat',
        'Як видалити всі пробіли з рядка?' => 'gsub',
        'Як перетворити рядок в число?' => 'to_i',
        'Які логічні значення існують в Ruby?' => 'true и false',
        'Яка функція використовується для визначення типу об\'єкта?' => 'class',
        'Який метод використовується для перетворення рядка в масив?' => 'split',
        'Як вивести останній елемент масиву?' => 'last',
        'Як перевірити, чи містить рядок певний підрядок?' => 'include?',
        'Як визначити час виконання певного участку коду?' => 'Benchmark.measure',
        'Як з\'єднати два рядки?' => 'concatenate'
      }

      total_score = 0
      correct_answers = 0
      incorrect_answers = 0

      questions
      questions.each do |question, correct_answer|
        bot.api.send_message(chat_id: message.chat.id, text: question)
        sleep(1)

        bot.listen do |response|
          next unless response.is_a?(Telegram::Bot::Types::Message)
          next unless response.chat.id == message.chat.id

          answer = response.text

          if answer.downcase == correct_answer.downcase
            bot.api.send_message(chat_id: message.chat.id, text: "Правильно!")
            correct_answers += 1
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Неправильно. Правильна відповідь: #{correct_answer}")
            incorrect_answers += 1
          end

          break
        end
      end

      total_score = correct_answers.to_f / questions.length.to_f
      percentage = (total_score * 100).to_i

      bot.api.send_message(chat_id: message.chat.id, text: "Тест завершено!")
      bot.api.send_message(chat_id: message.chat.id, text: "Правильних відповідей: #{correct_answers}")
      bot.api.send_message(chat_id: message.chat.id, text: "Неправильних відповідей: #{incorrect_answers}")
      bot.api.send_message(chat_id: message.chat.id, text: "Загальний результат: #{percentage}%")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Не розумію команду. Використайте /start для початку.")
    end
  end
end
