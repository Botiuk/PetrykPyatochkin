require "faker"

case Rails.env
when "development"

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
            date_of_birth: Faker::Date.between(from: 64.year.ago, to: 23.year.ago),
            place_of_birth: Faker::Address.city,
            home_adress: Faker::Address.full_address,
            date_of_hired: Faker::Date.between(from: 5.year.ago, to: (Date.today-1))
        )
    end

    ActiveStorage::Blob.create!(
        key: 'pbcj80wo1ggewlfs6zfrjqhg93va',
        filename: 'doctor_empty_photo.jpg',
        content_type: 'image/jpeg',
        metadata: '{"identified":true,"width":380,"height":380,"analyzed":true}',
        service_name: 'cloudinary',
        byte_size: 5704,
        checksum: 'Yp8xTVxnrsK16TZ6wJaPbw=='
    )
    (1..100).each do |worker_id|
        ActiveStorage::Attachment.create!(
            record_type: 'Worker',
            record_id: worker_id,
            name: 'worker_photo',
            blob_id: 1
        )
    end

    25.times do
        Position.create(
            name: Faker::Job.unique.position,
            salary: Faker::Number.decimal(l_digits: 5, r_digits: 2),
            vacation_days: Faker::Number.between(from: 20, to: 30)
        )
    end

    300.times do
        WorkerPosition.create(
            worker_id: rand(1..100),
            position_id: rand(1..25),
            start_date: Faker::Date.between(from: 1.year.ago, to: 6.month.ago),
            end_date: Faker::Date.between(from: 5.month.ago, to: 1.month.ago)
        )
    end

    (1..100).each do |worker_id|
        WorkerPosition.create(
            worker_id: worker_id,
            position_id: rand(1..25),
            start_date: Faker::Date.between(from: 1.month.ago, to: Date.today)
        )
    end

    19.times do
        Department.create(
            abbreviation: Faker::Alphanumeric.unique.alphanumeric(number: 4, min_alpha: 4),
            name: Faker::Company.unique.department
        )
    end

    (1..19).each do |department_id|
        5.times do
            DepartmentWorker.create(
                worker_id: Faker::Number.unique.between(from: 1, to: 100),
                department_id: department_id,
                status: "worker"
            )
        end
    end

    (1..18).each do |department_id|
        department_manager = DepartmentWorker.where(department_id: department_id).first
        department_manager.update(status: "manager")
    end

    worker_with_department_ids = DepartmentWorker.pluck(:worker_id)
    worker_with_department_ids.each do |worker_with_department_id|
        Vacation.create(
            worker_id: worker_with_department_id,
            start_date: Faker::Date.between(from: 2.month.ago, to: Date.today),
            duration_days: Faker::Number.between(from: 20, to: 30)
        )
    end

when "production"

    user = User.where(email: "svetabotiuk@gmail.com").first_or_initialize
    user.update!(
        password: ENV['SEEDS_PASS'],
        password_confirmation: ENV['SEEDS_PASS']
    )

end