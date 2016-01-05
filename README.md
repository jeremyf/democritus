# Democritus

[![Build Status](https://travis-ci.org/jeremyf/democritus.png?branch=master)](https://travis-ci.org/jeremyf/democritus)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Democritus is a plugin for building class from reusable components.

Democritus is inspired as followup of a common pattern that I saw in the development of [Sipity's](https://github.com/ndlib/sipity/) form objects.
It also aims to address the needs of Sipity's yet to be developed sibling application; The dissemination of processed data.

I'm looking to apply the ideas put forward in Avdi Grimm's [Naught gem](https://github.com/avdi/naught).

## Goal

```ruby
ApproveForm = Democritus.build do |builder|
  builder.form
  builder.action_name('approve', command_namespace: Sipity::DemocritusCommands)
  builder.attribute('agree_to_terms_of_service', type: :Boolean)
end
```

## Roadmap

* Plugin for declaring a form
  - #submit
  - #valid?
  - #persisted?
  - #to_param
  - #model_name
* Plugin for declaring an attribute
  - setter method
  - getter method
* Plugin for declaring a view object
