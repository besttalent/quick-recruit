# Optionally override some pagy default with your own in the pagy initializer
pagy_defaults = Pagy::DEFAULT.dup
pagy_defaults[:limit] = 30 # items per page
pagy_defaults[:size] = 20  # nav bar links

Pagy.send(:remove_const, :DEFAULT)
Pagy.const_set(:DEFAULT, pagy_defaults.freeze)
