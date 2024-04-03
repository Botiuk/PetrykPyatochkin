user = User.where(email: "svetabotiuk@gmail.com").first_or_initialize
user.update!(
    password: ENV['SEEDS_PASS'],
    password_confirmation: ENV['SEEDS_PASS']
)

100.times do
    Worker.create(
        roll_number: Faker::Number.unique.within(range: 1..10000),
        last_name: Faker::Name.last_name,
        first_name: Faker::Name.first_name,
        middle_name: Faker::Name.middle_name,
        passport: Faker::Code.unique.nric,
        date_of_birth: Faker::Date.between(from: 64.year.ago, to: 19.year.ago),
        place_of_birth: Faker::Address.city,
        home_adress: Faker::Address.full_address,
        date_of_hired: Faker::Date.between(from: 1.year.ago, to: (Date.today-1))
    )
end

25.times do
    Position.create(
        name: Faker::Job.unique.position,
        salary: Faker::Number.decimal(l_digits: 5, r_digits: 2),
        vacation_days: Faker::Number.between(from: 20, to: 30)
    )
end