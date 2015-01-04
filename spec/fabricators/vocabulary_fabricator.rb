Fabricator(:vocabulary) do
  word {Faker::Lorem.word}
  part_of_speech 'Noun'
  example {Faker::Lorem.sentence}
end