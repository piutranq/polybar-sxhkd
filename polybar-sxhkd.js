#!/usr/bin/env node

/****************************************************************************
 * Configuration section
 ****************************************************************************/

// The full path of sxhkd status pipe
const pipe = require('os').homedir() + '/.cache/sxhkd.fifo'

const label = {
  prefix: '', // Prefix of label
  suffix: '', // Suffix of label

  /**
   *    List of the labels
   *      Key: 'H' + the prefix of hotkey chain to display including ALL WHITESPACES.
   *          all whitespaces are not trimmed, including the last whitespaces.
   *      Value: Label of the hotkey chain to display
   */
  list: {
    // Example for single prefix
    'Hsuper + r': 'super + r',

    // Example for chained prefix
    'Hsuper + m' : 'super + m',
    'Hsuper + m; n': 'super + m; n',
  }
}


/****************************************************************************
 * Script section
 ****************************************************************************/

/* Data Structure */
const register = {
  chainmode: false
}

/* Main function */
const main = (input) => {

  // If input is hotkey, find label in the list and echo the label
  if (new RegExp('^H').test(input) && label.list[input] != undefined) {
      console.log(label.prefix + label.list[input] + label.suffix)
  }

  // If chain is begin, turn chain mode register on
  if (new RegExp('^BBegin').test(input)) {
    register.chainmode = true
  }

  // If chain is aborted, turn chain mode off and remove the label
  if (new RegExp('^EEnd').test(input)) {
    console.log('')
    register.chainmode = false
  }

  // If chain reaches the last and aborted, remove the label forcely
  if (new RegExp('^C').test(input) && !register.chainmode) {
    console.log('')
  }

}

const pipefd = require('fs').createReadStream(pipe)
const stream = require('readline').createInterface({ input: pipefd })
stream.on('line', (input) => main(input))


