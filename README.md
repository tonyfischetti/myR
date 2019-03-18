myR
===

A place to update and store my R configuration

This will create a symlink to a custom .Rprofile that's
(largely) safe to use for reproducibility purposes

You can also (for quick tasks) use `RR` to run a super
custom R profile that automatically loads your most
used packages and things.
`RR` is a shell script that will invoke R with that very special
R profile. You can create a shell alias to run that shell
script

    git clone https://github.com/tonyfischetti/myR.git ~/.R/
    ln -s ~/.R/Rprofile ~/.Rprofile
    ln -s ~/.R/.inputrc ~/.inputrc
