# Democritus

[![Build Status](https://travis-ci.org/jeremyf/democritus.png?branch=master)](https://travis-ci.org/jeremyf/democritus)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Democritus is a plugin for building class from reusable components.

Democritus is inspired as followup of a common pattern that I saw in the development of [Sipity's](https://github.com/ndlib/sipity/) form objects.
It also aims to address the needs of Sipity's yet to be developed sibling application; The dissemination of processed data.

I'm looking to apply the ideas put forward in Avdi Grimm's [Naught gem](https://github.com/avdi/naught).

## Goal

I would like to be able to declare in Ruby the following:

```ruby
ApprovalForm = Democritus.build do |builder|
  builder.form do
    attributes do
      attribute(name: 'agree_to_terms_of_service', type: 'Boolean', validates: 'acceptance')
    end
    action_name(name: 'approval', command_namespace: 'Sipity::DemocritusCommands')
  end
end
```

With an `ApprovalForm`, I could `#submit` if `#valid?` (i.e. the `agree_to_terms_of_service` has been accepted).

From that point forward, I would like to be able to create the class based on a JSON description:

```json
{
  "form": {
    "command_namespace:": "Sipity::DemocritusCommands",
    "attributes": [
      {
        "attribute": {
          "name": "agree_to_terms_of_service", "type": "Boolean", "validates": "acceptance"
        }
      }
    ]},
    "action_name": {
      "name": "approval", "command_namespace": "Sipity::DemocritusCommands"
    }
  }
}
```

```ruby
ApprovalForm = Demcritus.build_from_json('file.json')
```

## Roadmap

- [x] Rudimentary plugin command behavior
  - [x] [Command::Attribute](./lib/democritus/class_builder/commands/attribute.rb)
  - [x] [Command::Attirubtes](./lib/democritus/class_builder/commands/attributes.rb)
- [ ] Create the commands that build a Sipity processing form
- [ ] Build class from JSON configuration
