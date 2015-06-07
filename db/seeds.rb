[
  "Adrian Ossowski",
  "Aga Pawlicka",
  "Arek Janik",
  "Arek Kwasny",
  "Blazej Kosmowski",
  "Bartek Wojtowicz",
  "Bartek Danek",
  "Darek Wylon",
  "Darek Pienczykowski",
  "Dawid Poslinski",
  "Eunika Tabak",
  "Grzesiek Rduch",
  "Irek Skrobis",
  "Marek Caputa",
  "Mateusz Skrobis",
  "Mateusz Swiszcz",
  "Michal Czyz",
  "Monika Wroblewska",
  "Pawel Duda",
  "Radek Jedryszczak",
  "Szymon Kieloch",
  "Tomek Bak",
  "Tomek Borowski",
  "Tomek Czana",
  "Tomek Dudzik",
  "Tomek Noworyta",
  "Wojtek Wrona",
  "Wojtek Ryrych"
].each do |user|
  first_name = user.split.first
  last_name = user.split.last
  email = "#{first_name.first.downcase}.#{last_name.downcase}@selleo.com"

  User.where(email: email,
             first_name: first_name,
             last_name: last_name).first_or_create(password: 'secret',
                                                   password_confirmation: 'secret')
end

User.find_by(first_name: 'Irek').update_attribute(:admin, true)
