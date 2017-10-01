client = Client.create({ name: 'MewKeting' })
sender = Sender.create({
    email: 'a@a.com',
    password: '1234',
    admin: true,
    client: client
})
receiver = Receiver.create({
    name: 'Nano',
    email: 'abba@meucoracao.com',
    sender: sender
})
group = Group.create({
    name: 'testName',
    private: false,
    sender: sender
})
group_receivers = GroupReceiver.create({
    group: group,
    receiver: receiver
})

Sender.create({
  email: 'b@b.com',
  password: '1234',
  admin: false,
  client: client
  })

Sender.create({
  email: 'c@c.com',
  password: '1234',
  admin: false,
  client: client
  })

Receiver.create({
  name: 'Ze',
  email: 'emailze@mo.com',
  sender: sender
  })
