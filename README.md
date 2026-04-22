### Ever wanted your linux to ***not*** work consistenty?
#### Well now you can have your commands work only *sometimes*!

---

All this really does is it moves your `/bin` to `/bin-copy` and fills up `/bin` with
lots of copied executables of the same name of the original commands (made from `main.c`)
that then calls the original, moved executables in the `/bin-copy` directory. Sometimes.

This will likely break your system.
I recommend using this in a VM unless you know what you are doing.

To run it just do:
```sh
./build.sh && sudo ./setup.sh
```

