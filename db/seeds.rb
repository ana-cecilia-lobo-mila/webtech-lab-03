puts "Cleaning database..."
RepairService.destroy_all
Repair.destroy_all
Bike.destroy_all
Mechanic.destroy_all
Customer.destroy_all
Service.destroy_all

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
services.each { |s| Service.create!(s) }

s_reg = Service.find_by(name: "Foreign exchange regulations")
s_wash = Service.find_by(name: "Full wash and degreasing")
s_maintenance = Service.find_by(name: "Front or rear hub maintenance")

puts "Creating 10 clients and 12 bikes..."
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

# Cliente 10 sin bicis ni reparaciones (Cumple requisito: "At least one customer has no repairs at all")
c10 = Customer.create!(name: "Nathanael Fitzgerald", phone: "988275142")

puts "Creating 15 reparations..."

# 1. Overdue and not handed back
r1 = Repair.create!(bike_id: b1_a.id, mechanic_id: m1.id, started_on: 10.days.ago, promised_on: 2.days.ago, state: "in_repair")
RepairService.create!(repair_id: r1.id, service_id: s_reg.id, charged_price: s_reg.price)

# 2. In and out the same day
r2 = Repair.create!(bike_id: b1_b.id, mechanic_id: m2.id, started_on: 5.days.ago, promised_on: 5.days.ago, state: "picked_up", handed_back_at: 5.days.ago + 4.hours)
RepairService.create!(repair_id: r2.id, service_id: s_wash.id, charged_price: s_wash.price)

# 3. Customer heard price and said no (rejected)
r3 = Repair.create!(bike_id: b2_a.id, mechanic_id: m_mostrador.id, started_on: 1.day.ago, promised_on: 1.day.from_now, state: "rejected", handed_back_at: 1.day.ago + 2.hours)

# 4. Same bike, different repair (b1_a has repair r1 and r4)
r4 = Repair.create!(bike_id: b1_a.id, mechanic_id: m3.id, started_on: 2.months.ago, promised_on: 2.months.ago + 2.days, state: "delivered", handed_back_at: 2.months.ago + 3.days)
RepairService.create!(repair_id: r4.id, service_id: s_wash.id, charged_price: s_wash.price)

# 5. Old repair (before last Jan) with charged price below list price
r5 = Repair.create!(bike_id: b5.id, mechanic_id: m1.id, started_on: 2.years.ago, promised_on: 2.years.ago + 1.day, state: "picked_up", handed_back_at: 2.years.ago + 2.days)
RepairService.create!(repair_id: r5.id, service_id: s_maintenance.id, charged_price: s_maintenance.price - 5000) 

# 6. Just received (No quote, no services yet)
r6 = Repair.create!(bike_id: b4.id, mechanic_id: nil, started_on: Date.today, promised_on: 3.days.from_now, state: "received")

# 7. Quoted, waiting client response
r7 = Repair.create!(bike_id: b8.id, mechanic_id: m3.id, started_on: 1.day.ago, promised_on: 2.days.from_now, state: "waiting_for_approval")
RepairService.create!(repair_id: r7.id, service_id: s_reg.id, charged_price: s_reg.price)

# 8. Approved, waiting for repair
r8 = Repair.create!(bike_id: b9.id, mechanic_id: m2.id, started_on: 4.days.ago, promised_on: 1.day.from_now, state: "approved")
RepairService.create!(repair_id: r8.id, service_id: s_wash.id, charged_price: s_wash.price)

# 9. Ready (Finished but not picked up yet)
r9 = Repair.create!(bike_id: b3_b.id, mechanic_id: m3.id, started_on: 2.weeks.ago, promised_on: 2.weeks.ago + 3.days, state: "ready")
RepairService.create!(repair_id: r9.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)

# 10. In repair (Busy mechanic)
r10 = Repair.create!(bike_id: b7.id, mechanic_id: m1.id, started_on: Date.today, promised_on: 2.weeks.from_now, state: "in_repair")
RepairService.create!(repair_id: r10.id, service_id: s_wash.id, charged_price: s_wash.price)

# 11. Just received (No quote, no services yet)
r11 = Repair.create!(bike_id: b3_a.id, mechanic_id: nil, started_on: Date.today, promised_on: 5.days.from_now, state: "received")

# 12. Quoted
r12 = Repair.create!(bike_id: b9.id, mechanic_id: m1.id, started_on: 2.days.ago, promised_on: 1.day.from_now, state: "waiting_for_approval")
RepairService.create!(repair_id: r12.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)

# 13. Ready
r13 = Repair.create!(bike_id: b8.id, mechanic_id: m2.id, started_on: 2.days.ago, promised_on: 2.days.from_now, state: "ready")
RepairService.create!(repair_id: r13.id, service_id: s_wash.id, charged_price: s_wash.price)

# 14. Approved
r14 = Repair.create!(bike_id: b2_b.id, mechanic_id: m3.id, started_on: 1.day.ago, promised_on: 3.days.from_now, state: "approved")
RepairService.create!(repair_id: r14.id, service_id: s_reg.id, charged_price: s_reg.price)

# 15. Delivered with 4 services (Testing max limit)
r15 = Repair.create!(bike_id: b6.id, mechanic_id: m1.id, started_on: 3.days.ago, promised_on: 1.day.ago, state: "picked_up", handed_back_at: 1.day.ago)
RepairService.create!(repair_id: r15.id, service_id: s_wash.id, charged_price: s_wash.price)
RepairService.create!(repair_id: r15.id, service_id: s_reg.id, charged_price: s_reg.price)
RepairService.create!(repair_id: r15.id, service_id: s_maintenance.id, charged_price: s_maintenance.price)
RepairService.create!(repair_id: r15.id, service_id: Service.find_by(name: "Tire replacement").id, charged_price: 8000.00)



# Verification 
puts "--------------------------------------------------"
puts "REPORT  SEED:"
puts "- Services created: #{Service.count} (At least: 20)"
puts "- Mechanics created: #{Mechanic.count} (At least: 4)"
puts "- Customers created: #{Customer.count} (At least: 10)"
puts "- Bikes created: #{Bike.count} (At least: 12)"
puts "- Repairs created: #{Repair.count} (At least: 15)"
puts "--------------------------------------------------"
puts "Database seeded successfully!"