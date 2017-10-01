client = Client.create({ name: 'MewKeting' })
sender1 = Sender.create({
    email: 'a@a.com',
    password: '1234',
    admin: true,
    client: client
})
receiver = Receiver.create({
    name: 'Nano',
    email: 'abba@meucoracao.com',
    sender: sender1
})
group = Group.create({
    name: 'testName',
    private: false,
    sender: sender1
})
group_receivers = GroupReceiver.create({
    group: group,
    receiver: receiver
})

sender2 = Sender.create({
  email: 'b@b.com',
  password: '1234',
  admin: false,
  client: client
  })

sender3 = Sender.create({
  email: 'c@c.com',
  password: '1234',
  admin: false,
  client: client
  })

client2 = Client.create({ name: 'Two'})

sender4 = Sender.create({
  email: '1@1.com',
  password: '1234',
  admin: true,
  client: client2
  })

group1 = Group.create({
  name: 'Pobres',
  private: true,
  sender: sender2
  })

group2 = Group.create({
  name: 'Rykos',
  private: false,
  sender: sender3
  })

template1 = Template.create({
  title: 'corpinho',
  body: 'esse corpo nu',
  sender: sender2
  })

receiver1 = Receiver.create({
  name: 'Mindinho',
  email: 'mindin433@meuemials.com',
  sender: sender2
  })

email1 = Email.create ({
  schedule: Time.new,
  title: 'VEXA NOSSAS PROMOSSAUM',
  body: 'nossaaa quantos produtus baratusss',
  sender: sender3
  })

Receiver.create({
  name: 'Ze',
  email: 'emailze@mo.com',
  sender: sender1
  })
