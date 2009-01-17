# the lil' (cute) time tracker

!(http://img.skitch.com/20090117-qf7dq73tgrj3kk65kf86kx4mnb.jpg)

this is a replacement for my old system, with a workflow based on shuffling
post-it's and calculating total hours and all kind of boring shit. this is
teh eazy way:

1. log in to the lil' tracker before you start working and track project X
2. do that work stuff or smoke cigarettes or smth
3. stop tracking project X

and the time you spent will be added to the lil'.

## command line interface
oh yes, even easier.

    $ ltt track project-x
    $ vim /path/to/my/workz
    $ ltt stop

that's it! (that is, when somebody actually write that 4-line wrapper around
curl)

## setup
run it from the cli or configure passenger or however you roll, like this:

    ruby app.rb -e production

you will have to add users manually. something like this:

    sqlite3 db/production.db "INSERT INTO users (login, password) VALUES ('foo',
    'bar)"

## todo
* write that cli wrapper
* add the two calls to Digest::SHAlala for a little obscurity
* check TODO, mhm.

## license
the mit. and really, fuckin' google it yourself, I don't care.

(c) 2009 Harry Vangberg / Imperial Glamour
