require 'rspec'
require_relative  'questionnaire'

describe 'Questionnaire' do 
  it 'should calculate rating correctly' do
    expect(Survey.calculate_rating(3)).to eq(60)
    expect(Survey.calculate_rating(5)).to eq(100)
    expect(Survey.calculate_rating(0)).to eq(0)
  end

  it 'should calculate average rating correctly' do
      data = [
        { correct_answers: 3, rating: 60 },
        { correct_answers: 4, rating: 80 },
        { correct_answers: 2, rating: 40 }
      ]

      puts Survey.load_data

      expect(Survey.calculate_average_rating(data)).to eq(60)

  end
end