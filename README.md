# tag-by-folder

## What?

Ruby CLI tool that automatically sets MP3 ID tags to match the track's containing folder name

## Get Started

Manually install the [taglib](https://github.com/robinst/taglib-ruby#installation) library for the system you're running on.

```
bundle install
chmod +x main.rb
./main.rb /path/to/my/mp3s
```
## Known Issues

* Does not save tags on GVFS (Samba) shares.
