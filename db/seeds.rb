# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# client = Client.create({ name: 'MewKeting' })
# sender = Sender.create({
#     email: 'a@a.com',
#     password: '1234',
#     admin: true,
#     client: client
# })

Sender.create({
  email: 'b@b.com',
  password: '1234',
  admin: false,
  client: Client.find(1)
  })

Sender.create({
  email: 'c@c.com',
  password: '1234',
  admin: false,
  client: Client.find(1)
  })
