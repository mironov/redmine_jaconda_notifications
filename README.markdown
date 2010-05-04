# Jaconda Notifications Plugin for Redmine

This plugin is intended to provide basic integration with [Jaconda](http://jaconda.im).
Following actions will result in notifications to your Jaconda room:

- Create and update issues
- Create and reply to messages
- Update wiki articles

## Installation & Configuration

- The Jaconda Notifications Plugin depends on the [official ruby wrapper](http://github.com/mironov/jaconda-api) for Jaconda API. This can be installed with:
    $ sudo gem install jaconda
- Then install the Plugin following the general Redmine [plugin installation instructions](http://www.redmine.org/wiki/redmine/Plugins).
- Go to the Plugins section of the Administration page, select Configure.  
- On this page fill out the numerical room id and api token.
- Restart your Redmine web servers (e.g. mongrel, thin, mod_rails).