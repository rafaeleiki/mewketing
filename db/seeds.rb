client = Client.create({ name: 'MewKeting' })
sender = Sender.create({
    email: 'a@a.com',
    password: '1234',
    admin: true,
    client: client
})

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
