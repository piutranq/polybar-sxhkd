# polybar-sxhkd

![super + r is displayed on polybar, next bspwm module.](./img/demo.png)

- Read `sxhkd` status fifo and display the label of hotkey chain

## Require

- `bash` (tested on GNU bash version 5.0.7)
    - need to support the associative array feature (at least `bash` version 4)
- need nodejs version? see [here](https://github.com/piutranq/polybar-sxhkd/tree/409aedda0fbadbd0bf26c234086e24f967d4cf17)

## Usage

- Download [the script](https://raw.githubusercontent.com/piutranq/polybar-sxhkd/master/polybar-sxhkd.sh) and put it in path you want.
- Edit the configuration section in the script for your customization.
- Make the fifo to write sxhkd status (eg. `$ mkfifo $HOME/.cache/sxhkd.fifo`)
- Run sxhkd with the status fifo. (eg. `$ sxhkd -s $HOME/.cache/sxhkd.fifo &`)
- Add this module in your polybar config, and reload polybar.

```ini
[module/sxhkd]
type = custom/script
tail = true
label = %output%
exec = /path/of/the/script.sh
```

## Configuration section

- Configuration is stored directly in the script

### PIPE

- The full path of sxhkd status pipe.
- eg. `declare -r PIPE="/run/user/$UID/sxhkd.fifo"`

### LABEL

- When you have started hotkey chain, the script will display the label.

#### LABEL_PREFIX, LABEL_SUFFIX

- Prefix and suffix of the label. it is useful for formatting the label.

#### LABEL_TABLE

- Assigned label list for each hotkey, as the `["key"]="value"` format

##### key
- `H` + the prefix of hotkey chain to display, including all whitespace.
- single prefix example:
    - `'Hsuper + m'` can be used for `super + m;` in sxhkdrc
- chained prefix example:
    - `'Hsuper + m; n; o'` for `super + m; n; o;`
- branched chain example: 
    - `'Hsuper + m; n; o'` can be used also, when `super + {m,M}; {n,N}; {o,O};` is written in sxhkdrc.
- all whitespaces are not trimmed, including the last whitespaces.
    - When the hotkey is written as `super + m ;` in sxhkdrc, `'super + m'` may not be recognized.
    - Because, there is one whitespace between `m` and `;` in sxhkdrc. key in LABEL_TABLE should be `'super + m '`

##### value
- The label for the hotkey. it will be displayed actually.

## Script section

- The actual script is written in this. if you are familiar with bash, you can edit it yourself.

## License
- This script is under the MIT license.

