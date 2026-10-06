puts "Cleaning database..."

Repair.find_each do |repair|
  repair.intake_photos.each(&:purge)
end

RepairService.destroy_all
Repair.destroy_all
Bike.destroy_all
Mechanic.destroy_all
Customer.destroy_all
Service.destroy_all

ActionText::RichText.where(record_type: "Repair").destroy_all

ActiveStorage::Attachment.where(record_type: "Repair", name: "intake_photos").destroy_all

ActiveStorage::Blob.left_joins(:attachments).where(active_storage_attachments: { id: nil }).find_each(&:purge)


puts "Creating personal..."

m1 = Mechanic.create!(name: "Philip")
m2 = Mechanic.create!(name: "Theo")
m3 = Mechanic.create!(name: "Joseph")
m_mostrador = Mechanic.create!(name: "Sara")

puts "Creating 20 services..."
services = [
  { name: "Foreign exchange regulations", price: 10000.00 },
  { name: "Brake adjustment", price: 10000.00 },
  { name: "Wheel truing", price: 10000.00 },
  { name: "Front or rear hub maintenance", price: 12000.00 },
  { name: "Engine maintenance", price: 14000.00 },
  { name: "Chain replacement", price: 10000.00 },
  { name: "Tire replacement", price: 8000.00 },
  { name: "Tube replacement", price: 7000.00 },
  { name: "Steering maintenance cleaning", price: 12000.00 },
  { name: "Camera switch", price: 2000.00 },
  { name: "Chain lubrication", price: 5000.00 },
  { name: "Safety inspection", price: 7000.00 },
  { name: "Bottom bracket maintenance", price: 15000.00 },
  { name: "Hydraulic brake bleeding", price: 25000.00 },
  { name: "Suspension fork service", price: 45000.00 },
  { name: "Full wash and degreasing", price: 18000.00 },
  { name: "Rear shock maintenance", price: 35000.00 },
  { name: "Derailleur adjustment and tuning", price: 10000.00 },
  { name: "Cassette or freewheel replacement", price: 12000.00 },
  { name: "Tubeless tire conversion", price: 20000.00 }
]

services.each do |service|
  Service.create!(service)
end

s_reg = Service.find_by!(name: "Foreign exchange regulations")
s_wash = Service.find_by!(name: "Full wash and degreasing")
s_maintenance = Service.find_by!(name: "Front or rear hub maintenance")
s_tire = Service.find_by!(name: "Tire replacement")


puts "Creating 10 customers and 12 bikes..."
c1 = Customer.create!(name: "Simon White", phone: "923983411")
b1_a = Bike.create!(customer_id: c1.id, brand: "Trek", model: "Domane", color: "black", serial_number: "bk-01")
b1_b = Bike.create!(customer_id: c1.id, brand: "Trek", model: "Domane", color: "black", serial_number: "bk-02")

c2 = Customer.create!(name: "Judas White", phone: "9959736499")
b2_a = Bike.create!(customer_id: c2.id, brand: "Oxford", model: "Emonda", color: "blue", serial_number: "bk-03")
b2_b = Bike.create!(customer_id: c2.id, brand: "Canyon", model: "Aeroad", color: "red", serial_number: "bk-04")

c3 = Customer.create!(name: "Ana Jones", phone: "973825677")
b3_a = Bike.create!(customer_id: c3.id, brand: "Giant", model: "Talon", color: "purple", serial_number: "bk-05")
b3_b = Bike.create!(customer_id: c3.id, brand: "Cannondale", model: "MTB", color: "blue", serial_number: "bk-06")

c4 = Customer.create!(name: "Peter Williams", phone: "922234455")
b4 = Bike.create!(customer_id: c4.id, brand: "Trek", model: "Roscoe", color: "red", serial_number: "bk-07")

c5 = Customer.create!(name: "Mathew Miller", phone: "987157881")
b5 = Bike.create!(customer_id: c5.id, brand: "Scott", model: "Scale", color: "yellow", serial_number: "bk-08")

c6 = Customer.create!(name: "Jhon Taylor", phone: "927354327")
b6 = Bike.create!(customer_id: c6.id, brand: "Oxford", model: "Merak", color: "orange", serial_number: "bk-09")

c7 = Customer.create!(name: "James Harington", phone: "922342537")
b7 = Bike.create!(customer_id: c7.id, brand: "Giant", model: "Anthem", color: "pink", serial_number: "bk-10")

c8 = Customer.create!(name: "Thomas Green", phone: "915243248")
b8 = Bike.create!(customer_id: c8.id, brand: "Scott", model: "Spark", color: "light blue", serial_number: "bk-11")

c9 = Customer.create!(name: "Mary Crawford", phone: "944367527")
b9 = Bike.create!(customer_id: c9.id, brand: "Cannondale", model: "Synapse", color: "green", serial_number: "bk-12")

# Customer with no bikes or repairs.
c10 = Customer.create!(name: "Nathanael Fitzgerald", phone: "988275142")

puts "Creating 15 repairs..."

# 1. Overdue and not handed back
r1 = Repair.create!( bike_id: b1_a.id, mechanic_id: m1.id, started_on: 10.days.ago, promised_on: 2.days.ago, state: "in_repair")
RepairService.create!(repair_id: r1.id, service_id: s_reg.id, charged_price: s_reg.price)

# 2. In and out the same day
r2 = Repair.create!(bike_id: b1_b.id, mechanic_id: m2.id, started_on: 5.days.ago, promised_on: 5.days.ago, state: "picked_up", handed_back_at: 5.days.ago + 4.hours)
RepairService.create!(repair_id: r2.id, service_id: s_wash.id, charged_price: s_wash.price)

# 3. Customer heard price and said no
r3 = Repair.create!(bike_id: b2_a.id, mechanic_id: m_mostrador.id, started_on: 1.day.ago, promised_on: 1.day.from_now, state: "rejected", handed_back_at: 1.day.ago + 2.hours)
RepairService.create!(repair_id: r3.id, service_id: s_reg.id, charged_price: s_reg.price)

# 4. Same bike, different repair
r4 = Repair.create!(bike_id: b1_a.id, mechanic_id: m3.id, started_on: 2.months.ago, promised_on: 2.months.ago + 2.days, state: "picked_up", handed_back_at: 2.months.ago + 3.days)
RepairService.create!(repair_id: r4.id, service_id: s_wash.id, charged_price: s_wash.price)

# 5. Old repair with charged price below list price
r5 = Repair.create!(bike_id: b5.id, mechanic_id: m1.id, started_on: 2.years.ago, promised_on: 2.years.ago + 1.day, state: "picked_up", handed_back_at: 2.years.ago + 2.days)
RepairService.create!(repair_id: r5.id, service_id: s_maintenance.id, charged_price: s_maintenance.price - 5000)

# 6. Just received. Intentionally has no diagnosis.
r6 = Repair.create!(bike_id: b4.id, mechanic_id: nil, started_on: Date.current, promised_on: 3.days.from_now, state: "received")
RepairService.create!(repair_id: r6.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)

# 7. Quoted, waiting client response
r7 = Repair.create!(bike_id: b8.id, mechanic_id: m3.id, started_on: 1.day.ago, promised_on: 2.days.from_now, state: "waiting_for_approval")
RepairService.create!(repair_id: r7.id, service_id: s_reg.id, charged_price: s_reg.price)

# 8. Approved, waiting for repair
r8 = Repair.create!(bike_id: b9.id, mechanic_id: m2.id, started_on: 4.days.ago, promised_on: 1.day.from_now, state: "approved")
RepairService.create!(repair_id: r8.id, service_id: s_wash.id, charged_price: s_wash.price)

# 9. Ready
r9 = Repair.create!(bike_id: b3_b.id, mechanic_id: m3.id, started_on: 2.weeks.ago, promised_on: 2.weeks.ago + 3.days, state: "ready")
RepairService.create!(repair_id: r9.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)

# 10. In repair
r10 = Repair.create!(bike_id: b7.id, mechanic_id: m1.id, started_on: Date.current, promised_on: 2.weeks.from_now, state: "in_repair")
RepairService.create!(repair_id: r10.id, service_id: s_wash.id, charged_price: s_wash.price)

# 11. Just received
r11 = Repair.create!(bike_id: b3_a.id, mechanic_id: nil, started_on: Date.current, promised_on: 5.days.from_now, state: "received")
RepairService.create!(repair_id: r11.id, service_id: s_wash.id, charged_price: s_wash.price)

# 12. Diagnosing
r12 = Repair.create!(bike_id: b9.id, mechanic_id: m1.id, started_on: 2.days.ago, promised_on: 1.day.from_now, state: "diagnosing")
RepairService.create!(repair_id: r12.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)

# 13. Ready
r13 = Repair.create!(bike_id: b8.id, mechanic_id: m2.id, started_on: 2.days.ago, promised_on: 2.days.from_now, state: "ready")
RepairService.create!(repair_id: r13.id, service_id: s_wash.id, charged_price: s_wash.price)

# 14. Approved
r14 = Repair.create!(bike_id: b2_b.id, mechanic_id: m3.id, started_on: 1.day.ago, promised_on: 3.days.from_now, state: "approved")
RepairService.create!(repair_id: r14.id, service_id: s_reg.id, charged_price: s_reg.price)

# 15. Picked up with 4 services
r15 = Repair.create!(bike_id: b6.id, mechanic_id: m1.id, started_on: 3.days.ago, promised_on: 1.day.ago, state: "picked_up", handed_back_at: 1.day.ago)
RepairService.create!(repair_id: r15.id, service_id: s_wash.id, charged_price: s_wash.price)
RepairService.create!(repair_id: r15.id, service_id: s_reg.id, charged_price: s_reg.price)
RepairService.create!(repair_id: r15.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)
RepairService.create!(repair_id: r15.id, service_id: s_tire.id, charged_price: s_tire.price)

puts "Adding intake photos..."
seed_images = [
  Rails.root.join("db/seeds/images/bike1.png"),
  Rails.root.join("db/seeds/images/bike2.png"),
  Rails.root.join("db/seeds/images/bike3.png"),
  Rails.root.join("db/seeds/images/bike4.png")
]
seed_images.each do |image_path|
  raise "Missing seed image: #{image_path}" unless File.exist?(image_path)
end

repairs_with_photos = [r1, r2, r3, r4, r5, r6, r7, r8, r9, r10]

repairs_with_photos.each_with_index do |repair, index|
  image_path = seed_images[index % seed_images.length]
  repair.intake_photos.attach(io: File.open(image_path, "rb"), filename: "repair-#{repair.id}-intake.png", content_type: "image/png"
  )
end

3.times do |index|
  image_path = seed_images[index + 1]
  r1.intake_photos.attach(io: File.open(image_path, "rb"), filename: "repair-#{r1.id}-extra-#{index + 1}.png", content_type: "image/png"
  )
end

puts "Adding diagnoses..."
diagnoses = {
  r1 => "<p>The bicycle has <strong>significant drivetrain wear</strong>.</p><ul><li>Clean and lubricate the chain.</li><li>Check cassette wear.</li></ul>",
  r2 => "<p>The bicycle required a <strong>general cleaning</strong>.</p><ul><li>Degrease the drivetrain.</li><li>Check tire pressure.</li></ul>",
  r3 => "<p>The inspection found <strong>several worn components</strong>.</p><ul><li>Replace worn parts.</li><li>Adjust the brakes.</li></ul>",
  r4 => "<p>The bicycle has a <strong>wheel alignment issue</strong>.</p><ul><li>True the wheel.</li><li>Inspect spoke tension.</li></ul>",
  r5 => "<p>The hub requires <strong>preventive maintenance</strong>.</p><ul><li>Clean the bearings.</li><li>Apply new grease.</li></ul>",
  r7 => "<p>The bicycle requires a <strong>complete inspection</strong>.</p><ul><li>Review the estimate.</li><li>Wait for authorization.</li></ul>",
  r8 => "<p>The customer approved the <strong>recommended service</strong>.</p><ul><li>Prepare components.</li><li>Schedule the repair.</li></ul>",
  r9 => "<p>The repair is <strong>complete and ready</strong>.</p><ul><li>Complete safety inspection.</li><li>Check tire pressure.</li></ul>",
  r10 => "<p>The bicycle is undergoing <strong>drivetrain maintenance</strong>.</p><ul><li>Clean the drivetrain.</li><li>Adjust the derailleur.</li></ul>",
  r12 => "<p>The mechanic is performing a <strong>detailed diagnosis</strong>.</p><ul><li>Inspect the brakes.</li><li>Inspect the drivetrain.</li></ul>"
}

diagnoses.each do |repair, diagnosis|
  repair.diagnosis.update!(body: diagnosis)
end

puts "--------------------------------------------------"
puts "SEED REPORT:"
puts "- Services created: #{Service.count} (expected: 20)"
puts "- Mechanics created: #{Mechanic.count} (expected: 4)"
puts "- Customers created: #{Customer.count} (expected: 10)"
puts "- Bikes created: #{Bike.count} (expected: 12)"
puts "- Repairs created: #{Repair.count} (expected: 15)"
puts "- Repair services: #{RepairService.count}"
puts "- Repairs with photos: #{Repair.joins(:intake_photos_attachments).distinct.count} (expected: 10)"
puts "- Intake photos attached: #{ActiveStorage::Attachment.where(record_type: "Repair", name: "intake_photos").count} (expected: 13)"
puts "- Repairs with diagnosis: #{Repair.joins(:rich_text_diagnosis).distinct.count} (expected: 10)"
puts "- r1 photos: #{r1.intake_photos.count} (expected: 4)"
puts "- r6 diagnosis empty: #{r6.diagnosis.blank?} (expected: true)"
puts "--------------------------------------------------"
puts "Database seeded successfully!"