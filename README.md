
## Encryption Activator

This gem lets you encrypt fields in your Rails app's database, and by
default, raise an exception if you try to access any of the fields, until
you call the prompt method which will ask for the encryption key.


## Examples

    gem 'encryption_activator'
    
    EncryptionActivator.key     # raises EncryptionActivator::KeyNotSetException
    EncryptionActivator.prompt  # prompts for key at the terminal
    EncryptionActivator.key     # => returns key

    
## Use with Rails: attr_encrypted

### Key-less mode

Put this in eg. config/initializers/activerecord_attr_encrypted.rb :

    ActiveRecord::Base.attr_encrypted_options.merge!(
      key:    EncryptionActivator.keyproc,
      encode: true
    )

Your app will work without the key being set, as long as you don't try to
read any of the encrypted fields.

### Activate encrypted mode

Somewhere in your worker process or
startup thread, you call this:

    EncryptionActivator.prompt

After this, the app can read and write the encrypted fields.

OR you can use the environment variable ENCRYPTION_ACTIVATOR_KEY
