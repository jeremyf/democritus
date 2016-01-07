# Democritus

[![Build Status](https://travis-ci.org/jeremyf/democritus.png?branch=master)](https://travis-ci.org/jeremyf/democritus)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)
[![Code Climate](https://codeclimate.com/github/jeremyf/democritus.png)](https://codeclimate.com/github/jeremyf/democritus)
[![Test Coverage](https://codeclimate.com/github/jeremyf/democritus/badges/coverage.svg)](https://codeclimate.com/github/jeremyf/democritus)
[![Documentation Status](http://inch-ci.org/github/jeremyf/democritus.svg?branch=master)](http://inch-ci.org/github/jeremyf/democritus)

Democritus is a plugin for building class from reusable components.

Democritus is inspired as followup of a common pattern that I saw in the development of [Sipity's](https://github.com/ndlib/sipity/) form objects.
It also aims to address the needs of Sipity's yet to be developed sibling application; The dissemination of processed data.

I'm looking to apply the ideas put forward in Avdi Grimm's [Naught gem](https://github.com/avdi/naught).

## Goal

I would like to be able to declare in Ruby the following:

```ruby
ApprovalForm = Democritus.build(command_namespaces: ['Sipity::DemocritusCommands', 'Democritus::ClassBuilder::Commands']) do |builder|
  builder.form do
    attributes do
      attribute(name: 'agree_to_terms_of_service', type: 'Boolean', validates: 'acceptance')
    end
    action_name(name: 'approval')
  end
end
```

With an `ApprovalForm`, I could `#submit` if `#valid?` (i.e. the `agree_to_terms_of_service` has been accepted).

From that point forward, I would like to be able to create the class based on a JSON description:

```json
{
  "#command_namespaces": ["Sipity::DemocritusCommands", "Democritus::ClassBuilder::Commands"],
  "#form": {
    "#attributes": {
      "#attribute": [
        { "name": "agree_to_terms_of_service", "type": "Boolean", "validates": "acceptance" }
      ]
    },
    "#action_name": { "name": "approval" }
  }
}
```

```ruby
ApprovalForm = Demcritus.build_from_json(json)
```

## Roadmap

- [x] Rudimentary plugin command behavior
  - [x] [Command::Attribute](./lib/democritus/class_builder/commands/attribute.rb)
  - [x] [Command::Attirubtes](./lib/democritus/class_builder/commands/attributes.rb)
- [ ] Create the commands that build a Sipity processing form
- [X] Build class from JSON configuration
  - [ ] Basic case for nested commands
  - [ ] Allow for "constantization" of command_namespaces option.
