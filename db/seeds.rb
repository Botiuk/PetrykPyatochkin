user = User.where(email: "svetabotiuk@gmail.com").first_or_initialize
user.update!(
    password: ENV['SEEDS_PASS'],
    password_confirmation: ENV['SEEDS_PASS']
)